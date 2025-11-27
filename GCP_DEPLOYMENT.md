# MyTutor - Google Cloud Platform Deployment Guide

## 📋 Prerequisites

Before deploying to GCP, ensure you have:

1. **Google Cloud Account** - [Sign up here](https://cloud.google.com/free)
2. **GCP Project** - Create a new project in [GCP Console](https://console.cloud.google.com/)
3. **Billing Enabled** - Required for Cloud Run and Cloud SQL
4. **Tools Installed**:
   - [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
   - [Terraform](https://www.terraform.io/downloads)
   - Docker Desktop

## 🚀 Deployment Steps

### Step 1: Set Up GCP Project

```bash
# Login to Google Cloud
gcloud auth login

# Set your project ID
export PROJECT_ID="your-gcp-project-id"
gcloud config set project $PROJECT_ID

# Enable billing (required)
# Go to: https://console.cloud.google.com/billing

# Set default region
gcloud config set run/region us-central1
```

### Step 2: Create Service Account (Optional but Recommended)

```bash
# Create service account
gcloud iam service-accounts create mytutor-deployer \
    --display-name="MyTutor Deployer"

# Grant necessary roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:mytutor-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

# Create and download key
gcloud iam service-accounts keys create gcp-key.json \
    --iam-account=mytutor-deployer@$PROJECT_ID.iam.gserviceaccount.com

# Set credentials
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/gcp-key.json"
```

### Step 3: Build and Push Docker Images

#### On Windows (PowerShell):
```powershell
# Set your project ID
$env:PROJECT_ID = "your-gcp-project-id"

# Run deployment script
.\deploy.ps1 -ProjectId $env:PROJECT_ID -Region "us-central1"
```

#### On Linux/Mac (Bash):
```bash
# Set your project ID
export PROJECT_ID="your-gcp-project-id"
export REGION="us-central1"

# Make script executable
chmod +x deploy.sh

# Run deployment script
./deploy.sh
```

### Step 4: Configure Terraform

```bash
cd terraform

# Copy example tfvars
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Use your favorite editor (nano, vim, code, etc.)
nano terraform.tfvars
```

**Update `terraform.tfvars`:**
```hcl
project_id  = "your-gcp-project-id"
region      = "us-central1"
environment = "dev"
db_tier     = "db-f1-micro"
db_user     = "mytutor_user"
db_password = "your-secure-password-here"
```

### Step 5: Deploy with Terraform

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Type 'yes' when prompted
```

**Deployment will take 5-10 minutes.**

### Step 6: Get Your URLs

After deployment completes, Terraform will output your URLs:

```bash
# View outputs
terraform output

# Get specific URLs
terraform output frontend_url
terraform output ai_service_url
```

## 🌐 Access Your Application

Your application will be available at the URLs provided by Terraform:

- **Frontend**: `https://mytutor-frontend-xxxxx-uc.a.run.app`
- **API**: `https://mytutor-ai-service-xxxxx-uc.a.run.app`
- **API Docs**: `https://mytutor-ai-service-xxxxx-uc.a.run.app/docs`

## 🔧 Configuration

### Update Frontend API URL

After deployment, update the frontend to use the correct API URL:

1. Get the AI service URL:
   ```bash
   terraform output ai_service_url
   ```

2. Update `frontend/src/App.jsx`:
   ```javascript
   const API_URL = 'https://your-ai-service-url.a.run.app'
   ```

3. Rebuild and redeploy:
   ```bash
   # From project root
   export PROJECT_ID="your-gcp-project-id"
   export REGION="us-central1"
   
   # Rebuild frontend
   docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/mytutor/frontend:latest ./frontend
   docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/mytutor/frontend:latest
   
   # Redeploy
   cd terraform
   terraform apply
   ```

## 💰 Cost Estimation

### Free Tier Eligible:
- **Cloud Run**: 2 million requests/month free
- **Cloud SQL**: db-f1-micro (shared CPU, 0.6GB RAM)
- **Artifact Registry**: 0.5GB storage free

### Estimated Monthly Costs (Low Traffic):
- Cloud Run (2 services): ~$0-5
- Cloud SQL (db-f1-micro): ~$7-10
- Artifact Registry: ~$0-1
- **Total**: ~$7-16/month

### Cost Optimization:
- Use Cloud Run's auto-scaling (scales to zero)
- Use smallest Cloud SQL tier for development
- Delete unused resources with `terraform destroy`

## 🔒 Security Best Practices

### 1. Secure Database Password
```bash
# Generate strong password
openssl rand -base64 32

# Update terraform.tfvars
db_password = "generated-secure-password"
```

### 2. Restrict Database Access
Edit `terraform/main.tf` to limit IP access:
```hcl
authorized_networks {
  name  = "cloud-run"
  value = "your-cloud-run-ip/32"
}
```

### 3. Enable HTTPS Only
Cloud Run enforces HTTPS by default ✅

### 4. Add Authentication
Consider adding:
- JWT tokens for API
- Google Identity Platform
- OAuth 2.0

## 📊 Monitoring

### View Logs
```bash
# AI Service logs
gcloud run services logs read mytutor-ai-service --region=us-central1

# Frontend logs
gcloud run services logs read mytutor-frontend --region=us-central1

# Database logs
gcloud sql operations list --instance=mytutor-db-dev
```

### View Metrics
Go to [Cloud Console](https://console.cloud.google.com/):
- Cloud Run → Select service → Metrics
- Cloud SQL → Select instance → Monitoring

## 🔄 Updates and Redeployment

### Update Application Code
```bash
# Make your changes
# Then rebuild and push images
./deploy.ps1 -ProjectId your-project-id

# Redeploy with Terraform
cd terraform
terraform apply
```

### Update Infrastructure
```bash
# Edit terraform files
# Then apply changes
cd terraform
terraform plan
terraform apply
```

## 🗑️ Cleanup / Destroy Resources

**⚠️ Warning: This will delete all resources and data!**

```bash
cd terraform
terraform destroy

# Type 'yes' when prompted
```

## 🐛 Troubleshooting

### Error: "API not enabled"
```bash
# Enable required APIs manually
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

### Error: "Permission denied"
```bash
# Ensure you have necessary roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="user:your-email@gmail.com" \
    --role="roles/editor"
```

### Database Connection Issues
- Check Cloud SQL instance is running
- Verify database credentials in terraform.tfvars
- Check Cloud Run environment variables

### Images Not Found
```bash
# Verify images were pushed
gcloud artifacts docker images list \
    us-central1-docker.pkg.dev/$PROJECT_ID/mytutor
```

## 📚 Additional Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud SQL Documentation](https://cloud.google.com/sql/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Free Tier](https://cloud.google.com/free)

## 🎯 Next Steps

1. **Custom Domain**: Add your own domain to Cloud Run
2. **CI/CD**: Set up GitHub Actions for automatic deployment
3. **Monitoring**: Configure Cloud Monitoring alerts
4. **Backup**: Set up automated database backups
5. **Scaling**: Configure auto-scaling policies

---

**Your MyTutor app is now running on Google Cloud! 🎉**
