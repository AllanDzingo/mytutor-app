# MyTutor GCP Deployment Script (PowerShell)
# This script builds and pushes Docker images to Google Artifact Registry

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectId,
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "us-central1"
)

$RepoName = "mytutor"

Write-Host "========================================" -ForegroundColor Blue
Write-Host "MyTutor GCP Deployment Script" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

Write-Host "`nProject ID: $ProjectId" -ForegroundColor Green
Write-Host "Region: $Region" -ForegroundColor Green
Write-Host "Repository: $RepoName" -ForegroundColor Green

# Configure Docker to use gcloud as credential helper
Write-Host "`nConfiguring Docker authentication..." -ForegroundColor Blue
gcloud auth configure-docker "$Region-docker.pkg.dev"

# Build and push AI service
Write-Host "`nBuilding AI Service Docker image..." -ForegroundColor Blue
docker build -t "$Region-docker.pkg.dev/$ProjectId/$RepoName/ai-service:latest" ./ai-service

Write-Host "Pushing AI Service to Artifact Registry..." -ForegroundColor Blue
docker push "$Region-docker.pkg.dev/$ProjectId/$RepoName/ai-service:latest"

# Build and push Frontend
Write-Host "`nBuilding Frontend Docker image..." -ForegroundColor Blue
docker build -t "$Region-docker.pkg.dev/$ProjectId/$RepoName/frontend:latest" ./frontend

Write-Host "Pushing Frontend to Artifact Registry..." -ForegroundColor Blue
docker push "$Region-docker.pkg.dev/$ProjectId/$RepoName/frontend:latest"

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Docker images pushed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nNext steps:"
Write-Host "1. cd terraform"
Write-Host "2. terraform init"
Write-Host "3. terraform plan"
Write-Host "4. terraform apply"
