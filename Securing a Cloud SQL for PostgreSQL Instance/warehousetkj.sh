#!/bin/bash

# Menyimpan Project ID
export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

# Task 1: Membuat service account untuk Cloud SQL
echo "Membuat service account untuk Cloud SQL..."
gcloud beta services identity create --service=sqladmin.googleapis.com --project=$PROJECT_ID

# Task 2: Membuat KMS keyring dan key
echo "Membuat KMS Keyring..."
export KMS_KEYRING_ID=cloud-sql-keyring
export ZONE=$(gcloud compute instances list --filter="NAME=bastion-vm" --format=json | jq -r .[].zone | awk -F "/zones/" '{print $NF}')
export REGION=${ZONE::-2}
gcloud kms keyrings create $KMS_KEYRING_ID --location=$REGION

echo "Membuat KMS Key..."
export KMS_KEY_ID=cloud-sql-key
gcloud kms keys create $KMS_KEY_ID --location=$REGION --keyring=$KMS_KEYRING_ID --purpose=encryption

echo "Menambahkan IAM Policy Binding untuk KMS Key..."
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format 'value(projectNumber)')
gcloud kms keys add-iam-policy-binding $KMS_KEY_ID \
    --location=$REGION \
    --keyring=$KMS_KEYRING_ID \
    --member=serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-cloud-sql.iam.gserviceaccount.com \
    --role=roles/cloudkms.cryptoKeyEncrypterDecrypter

# Task 3: Mendapatkan IP eksternal dari VM bastion-vm dan Cloud Shell
echo "Mendapatkan IP eksternal VM Bastion..."
export AUTHORIZED_IP=$(gcloud compute instances describe bastion-vm --zone=$ZONE --format 'value(networkInterfaces[0].accessConfigs.natIP)')
echo "IP eksternal VM Bastion: $AUTHORIZED_IP"

echo "Mendapatkan IP eksternal Cloud Shell..."
export CLOUD_SHELL_IP=$(curl ifconfig.me)
echo "IP eksternal Cloud Shell: $CLOUD_SHELL_IP"

# Task 4: Membuat Cloud SQL untuk PostgreSQL dengan CMEK
echo "Membuat Cloud SQL untuk PostgreSQL dengan CMEK..."
export KEY_NAME=$(gcloud kms keys describe $KMS_KEY_ID --keyring=$KMS_KEYRING_ID --location=$REGION --format 'value(name)')
export CLOUDSQL_INSTANCE=postgres-orders
gcloud sql instances create $CLOUDSQL_INSTANCE \
    --project=$PROJECT_ID \
    --authorized-networks=${AUTHORIZED_IP}/32,$CLOUD_SHELL_IP/32 \
    --disk-encryption-key=$KEY_NAME \
    --database-version=POSTGRES_13 \
    --cpu=1 \
    --memory=3840MB \
    --region=$REGION \
    --root-password=supersecret!

# Task 5: Enable pgAudit di Cloud SQL
echo "Mengaktifkan pgAudit di Cloud SQL..."
gcloud sql instances patch $CLOUDSQL_INSTANCE \
    --database-flags cloudsql.enable_pgaudit=on,pgaudit.log=all

# Restart instance
echo "Restarting PostgreSQL instance..."
gcloud sql instances restart $CLOUDSQL_INSTANCE

# Task 6: Membuat dan mengonfigurasi database orders dan pgAudit extension
echo "Membuat database orders dan mengaktifkan pgAudit..."
psql --host=$POSTGRESQL_IP -U postgres -d postgres -c "CREATE DATABASE orders;"
psql --host=$POSTGRESQL_IP -U postgres -d orders -c "CREATE EXTENSION pgaudit;"
psql --host=$POSTGRESQL_IP -U postgres -d orders -c "ALTER DATABASE orders SET pgaudit.log = 'read,write';"

# Task 7: Mengonfigurasi dan Menambahkan Cloud IAM Authentication
echo "Mengonfigurasi Cloud IAM Authentication..."
gcloud sql instances patch $CLOUDSQL_INSTANCE --database-flags cloudsql.iam_authentication=on

# Menambahkan Cloud IAM User
echo "Menambahkan Cloud IAM User..."
gcloud sql users create student-00-df72b4c0458b@qwiklabs.net --instance=$CLOUDSQL_INSTANCE --password=supersecret!

# Memberikan akses ke tabel order_items
echo "Memberikan akses ke tabel order_items..."
psql --host=$POSTGRESQL_IP -U postgres -d orders -c "GRANT ALL PRIVILEGES ON TABLE order_items TO student-00-df72b4c0458b@qwiklabs.net;"

# Task 8: Menguji koneksi dengan Cloud IAM user
echo "Mengujicoba koneksi dengan Cloud IAM user..."
export PGPASSWORD=$(gcloud auth print-access-token)
psql --host=$POSTGRESQL_IP -U student-00-df72b4c0458b@qwiklabs.net --dbname=orders -c "SELECT COUNT(*) FROM order_items;"

# Task 9: Menambahkan data ke dalam database
echo "Menambahkan data ke dalam database..."
gsutil -m cp gs://spls/gsp920/create_orders_db.sql .
gsutil -m cp gs://spls/gsp920/DDL/* .

psql --host=$POSTGRESQL_IP -U postgres -d orders -c "\i create_orders_db.sql"

# Task 10: Melihat pgAudit logs
echo "Melihat pgAudit logs..."
gcloud logging read 'resource.type="cloudsql_database" logName="projects/${PROJECT_ID}/logs/cloudaudit.googleapis.com%2Fdata_access" protoPayload.request.@type="type.googleapis.com/google.cloud.sql.audit.v1.PgAuditEntry"' --limit 10 --format json

echo "Selesai!"
