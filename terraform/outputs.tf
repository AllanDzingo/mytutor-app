output "frontend_url" {
  description = "URL of the frontend Cloud Run service"
  value       = google_cloud_run_service.frontend.status[0].url
}

output "ai_service_url" {
  description = "URL of the AI service Cloud Run service"
  value       = google_cloud_run_service.ai_service.status[0].url
}

output "database_connection_name" {
  description = "Cloud SQL connection name"
  value       = google_sql_database_instance.postgres.connection_name
}

output "database_ip" {
  description = "Cloud SQL public IP address"
  value       = google_sql_database_instance.postgres.public_ip_address
}

output "artifact_registry_url" {
  description = "Artifact Registry repository URL"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/mytutor"
}
