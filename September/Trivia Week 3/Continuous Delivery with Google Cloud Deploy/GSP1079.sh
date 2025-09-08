#!/bin/bash
# Define color variables

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`

echo "${BG_YELLOW}${BOLD}Starting Execution${RESET}"

# Task 1: Set the variables
export PROJECT_ID=$(gcloud config get-value project)
export REGION=us-east4
gcloud config set compute/region $REGION

# Task 2: Create three GKE clusters
gcloud services enable \
    container.googleapis.com \
    clouddeploy.googleapis.com

# Create GKE clusters
gcloud container clusters create test --node-locations=us-east4-a --num-nodes=1 --async
gcloud container clusters create staging --node-locations=us-east4-a --num-nodes=1 --async
gcloud container clusters create prod --node-locations=us-east4-a --num-nodes=1 --async

# Check cluster status
gcloud container clusters list --format="csv(name,status)"

# Task 3: Prepare the web application container image
gcloud services enable artifactregistry.googleapis.com

# Create Artifact Registry repository
gcloud artifacts repositories create web-app \
    --description="Image registry for tutorial web app" \
    --repository-format=docker \
    --location=$REGION

# Task 4: Build and deploy the container images to the Artifact Registry
gcloud services enable cloudaicompanion.googleapis.com
cd ~/
git clone https://github.com/GoogleCloudPlatform/cloud-deploy-tutorials.git
cd cloud-deploy-tutorials
git checkout c3cae80 --quiet
cd tutorials/base

# Create the skaffold.yaml configuration
envsubst < clouddeploy-config/skaffold.yaml.template > web/skaffold.yaml
cat web/skaffold.yaml

# Enable Cloud Build API
gcloud services enable cloudbuild.googleapis.com

# Create Cloud Storage bucket for Cloud Build
gsutil mb -p $PROJECT_ID gs://${PROJECT_ID}_cloudbuild

# Build the application and deploy the container image
cd web
skaffold build --interactive=false \
    --default-repo $REGION-docker.pkg.dev/$PROJECT_ID/web-app \
    --file-output artifacts.json
cd ..

# Check the container images in Artifact Registry
gcloud artifacts docker images list \
    $REGION-docker.pkg.dev/$PROJECT_ID/web-app \
    --include-tags \
    --format yaml

# Review the deployed images in artifacts.json
cat web/artifacts.json | jq

# Task 5: Create the delivery pipeline
gcloud services enable clouddeploy.googleapis.com
gcloud config set deploy/region $REGION
cp clouddeploy-config/delivery-pipeline.yaml.template clouddeploy-config/delivery-pipeline.yaml

# Open delivery-pipeline.yaml file in Cloud Shell Editor for explanation with Gemini Code Assist
# (Manual step required for Gemini Code Assist)

# Create delivery pipeline
gcloud beta deploy apply --file=clouddeploy-config/delivery-pipeline.yaml

# Verify delivery pipeline creation
gcloud beta deploy delivery-pipelines describe web-app

# Task 6: Configure the deployment targets
# Ensure clusters are running
gcloud container clusters list --format="csv(name,status)"

# Create context for each cluster
CONTEXTS=("test" "staging" "prod")
for CONTEXT in ${CONTEXTS[@]}; do
    gcloud container clusters get-credentials ${CONTEXT} --region ${REGION}
    kubectl config rename-context gke_${PROJECT_ID}_${REGION}_${CONTEXT} ${CONTEXT}
done

# Create namespaces in each cluster
for CONTEXT in ${CONTEXTS[@]}; do
    kubectl --context ${CONTEXT} apply -f kubernetes-config/web-app-namespace.yaml
done

# Create delivery pipeline targets
for CONTEXT in ${CONTEXTS[@]}; do
    envsubst < clouddeploy-config/target-$CONTEXT.yaml.template > clouddeploy-config/target-$CONTEXT.yaml
    gcloud beta deploy apply --file clouddeploy-config/target-$CONTEXT.yaml
done

# Verify the targets
gcloud beta deploy targets list

# Task 7: Create a release
gcloud beta deploy releases create web-app-001 \
    --delivery-pipeline web-app \
    --build-artifacts web/artifacts.json \
    --source web/

# Confirm the test target deployment
gcloud beta deploy rollouts list \
    --delivery-pipeline web-app \
    --release web-app-001

# Task 8: Promote the application to staging
gcloud beta deploy releases promote \
    --delivery-pipeline web-app \
    --release web-app-001

# Confirm the staging target deployment
gcloud beta deploy rollouts list \
    --delivery-pipeline web-app \
    --release web-app-001

# Task 9: Promote the application to prod
gcloud beta deploy releases promote \
    --delivery-pipeline web-app \
    --release web-app-001

# Review the prod target deployment status
gcloud beta deploy rollouts list \
    --delivery-pipeline web-app \
    --release web-app-001

# Approve the prod rollout
gcloud beta deploy rollouts approve web-app-001-to-prod-0001 \
    --delivery-pipeline web-app \
    --release web-app-001

# Confirm the prod target deployment
gcloud beta deploy rollouts list \
    --delivery-pipeline web-app \
    --release web-app-001

# Check the prod deployment status in Kubernetes
kubectx prod
kubectl get all -n web-app

echo "${BG_GREEN}${BOLD}The Lab is Done...${RESET}"
