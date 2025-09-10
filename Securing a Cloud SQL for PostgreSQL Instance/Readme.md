Task 1. Create a Cloud SQL for PostgreSQL instance with CMEK enabled
```
curl -LO raw.githubusercontent.com/Haeratunnisa/GCA/main/Securing%20a%20Cloud%20SQL%20for%20PostgreSQL%20Instance/gsp920.sh
sudo chmod +x gsp920.sh
./gsp920.sh
```
Task 2. Enable and configure pgAudit on a Cloud SQL for PostgreSQL database
- Navigation menu (Navigation menu icon), click SQL
- Click on the Cloud SQL instance named postgres-orders.
- In the Connect to this instance section, click Open Cloud Shell.
- Run that command as is, and enter the password **supersecret!** when prompted.
- In psql, run the following command to create the orders database and enable the pgAudit extension to log all reads and writes:
```
CREATE DATABASE orders;
\c orders;
```
Enter the password **supersecret!** again.
```
CREATE EXTENSION pgaudit;
ALTER DATABASE orders SET pgaudit.log = 'read,write';
