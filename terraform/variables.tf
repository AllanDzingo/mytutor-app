variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "db_tier" {
  description = "Cloud SQL tier"
  type        = string
  default     = "db-f1-micro"  # Free tier eligible
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "mytutor_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
