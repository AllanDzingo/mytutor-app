#!/bin/bash

# MyTutor GCP Deployment Script
# This script builds and pushes Docker images to Google Artifact Registry

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}MyTutor GCP Deployment Script${NC}"
echo -e "${BLUE}========================================${NC}"

# Check if required variables are set
if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}ERROR: PROJECT_ID environment variable is not set${NC}"
    echo "Usage: export PROJECT_ID=your-gcp-project-id"
    exit 1
fi

REGION=${REGION:-us-central1}
REPO_NAME="mytutor"

echo -e "\n${GREEN}Project ID:${NC} $PROJECT_ID"
echo -e "${GREEN}Region:${NC} $REGION"
echo -e "${GREEN}Repository:${NC} $REPO_NAME"

# Configure Docker to use gcloud as credential helper
echo -e "\n${BLUE}Configuring Docker authentication...${NC}"
gcloud auth configure-docker ${REGION}-docker.pkg.dev

# Build and push AI service
echo -e "\n${BLUE}Building AI Service Docker image...${NC}"
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/ai-service:latest ./ai-service

echo -e "${BLUE}Pushing AI Service to Artifact Registry...${NC}"
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/ai-service:latest

# Build and push Frontend
echo -e "\n${BLUE}Building Frontend Docker image...${NC}"
docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/frontend:latest ./frontend

echo -e "${BLUE}Pushing Frontend to Artifact Registry...${NC}"
docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/frontend:latest

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Docker images pushed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nNext steps:"
echo -e "1. cd terraform"
echo -e "2. terraform init"
echo -e "3. terraform plan"
echo -e "4. terraform apply"
