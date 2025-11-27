# Quick Start - GCP Deployment

## Prerequisites
1. Google Cloud account with billing enabled
2. gcloud CLI installed
3. Terraform installed
4. Docker running

## Deploy in 5 Steps

### 1. Login to GCP
```powershell
gcloud auth login
gcloud config set project YOUR-PROJECT-ID
```

### 2. Build and Push Images
```powershell
.\deploy.ps1 -ProjectId "YOUR-PROJECT-ID"
```

### 3. Configure Terraform
```powershell
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project ID and password
```

### 4. Deploy Infrastructure
```powershell
terraform init
terraform apply
```

### 5. Get Your URLs
```powershell
terraform output frontend_url
terraform output ai_service_url
```

## Estimated Cost
- **Development**: ~$7-16/month
- **Free Tier**: First 2M requests/month free on Cloud Run

## Full Documentation
See [GCP_DEPLOYMENT.md](GCP_DEPLOYMENT.md) for complete instructions.

## Cleanup
```powershell
terraform destroy
```
