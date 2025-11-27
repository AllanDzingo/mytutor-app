terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "vpcaccess.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
  ])
  
  service = each.key
  disable_on_destroy = false
}

# Artifact Registry for Docker images
resource "google_artifact_registry_repository" "mytutor" {
  location      = var.region
  repository_id = "mytutor"
  description   = "MyTutor Docker repository"
  format        = "DOCKER"
  
  depends_on = [google_project_service.required_apis]
}

# Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "postgres" {
  name             = "mytutor-db-${var.environment}"
  database_version = "POSTGRES_15"
  region           = var.region
  
  settings {
    tier = var.db_tier
    
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-all"
        value = "0.0.0.0/0"
      }
    }
    
    backup_configuration {
      enabled = true
      start_time = "03:00"
    }
  }
  
  deletion_protection = false
  
  depends_on = [google_project_service.required_apis]
}

# Database
resource "google_sql_database" "mytutor" {
  name     = "mytutor"
  instance = google_sql_database_instance.postgres.name
}

# Database user
resource "google_sql_user" "mytutor" {
  name     = var.db_user
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

# Cloud Run service for AI backend
resource "google_cloud_run_service" "ai_service" {
  name     = "mytutor-ai-service"
  location = var.region
  
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/mytutor/ai-service:latest"
        
        ports {
          container_port = 8080
        }
        
        env {
          name  = "DATABASE_URL"
          value = "postgresql://${var.db_user}:${var.db_password}@${google_sql_database_instance.postgres.public_ip_address}:5432/${google_sql_database.mytutor.name}"
        }
        
        resources {
          limits = {
            cpu    = "2"
            memory = "2Gi"
          }
        }
      }
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "10"
        "autoscaling.knative.dev/minScale" = "1"
      }
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [
    google_project_service.required_apis,
    google_sql_database_instance.postgres
  ]
}

# Cloud Run service for Frontend
resource "google_cloud_run_service" "frontend" {
  name     = "mytutor-frontend"
  location = var.region
  
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/mytutor/frontend:latest"
        
        ports {
          container_port = 5173
        }
        
        env {
          name  = "VITE_API_URL"
          value = google_cloud_run_service.ai_service.status[0].url
        }
        
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [
    google_project_service.required_apis,
    google_cloud_run_service.ai_service
  ]
}

# IAM policy to allow unauthenticated access (make services public)
resource "google_cloud_run_service_iam_member" "ai_service_public" {
  service  = google_cloud_run_service.ai_service.name
  location = google_cloud_run_service.ai_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "frontend_public" {
  service  = google_cloud_run_service.frontend.name
  location = google_cloud_run_service.frontend.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
