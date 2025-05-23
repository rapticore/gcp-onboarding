terraform {
  backend "gcs" {}
}

provider "google" {
  project = var.gcp_project_id
}

data "terraform_remote_state" "current" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
  }
}

variable "state_bucket" {
  description = "GCS bucket for Terraform state"
  type        = string
}

variable "rapticore_account_id" {
  description = "Rapticore Account ID"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.rapticore_account_id))
    error_message = "Please enter a valid AWS Account ID (12 digits, provided by Rapticore)"
  }
}

variable "gcp_project_id" {
  description = "GCP Project ID (not the project number)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.gcp_project_id))
    error_message = "GCP project ID must be 6-30 characters long, start with a letter, and contain only lowercase letters, numbers, and hyphens"
  }
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "cloudasset.googleapis.com" 
  ])
  
  service = each.key
  disable_dependent_services = false
}

resource "google_iam_workload_identity_pool" "rapticore_workload_pool" {
  workload_identity_pool_id = "rapticore-pool-standarddev1"
  display_name              = "Rapticore Pool for standarddev1"
  description               = "Identity pool for Rapticore security scanning service for standarddev1"
  disabled                  = false
  
  depends_on = [google_project_service.required_apis]
}

resource "google_iam_workload_identity_pool_provider" "rapticore_workload_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.rapticore_workload_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "rapticore-provider-standarddev1"
  display_name                       = "Rapticore Provider for stddev1"
  description                        = "Identity provider for Rapticore AWS security scanning service for standarddev1"
  
  attribute_mapping = {
    "google.subject"      = "assertion.arn"
    "attribute.aws_account" = "assertion.account"
  }
  
  attribute_condition = "assertion.account == \"${var.rapticore_account_id}\""
  
  aws {
    account_id = var.rapticore_account_id
  }
  
  depends_on = [google_iam_workload_identity_pool.rapticore_workload_pool]
}

resource "google_service_account" "rapticore_service_account" {
  account_id   = "rapticore-sa-standarddev1"
  display_name = "Rapticore sa standarddev1"
  description  = "Service account for Rapticore security vulnerability scanning for standarddev1"
  
  depends_on = [google_project_service.required_apis]
}

resource "google_project_iam_member" "rapticore_service_account_roles" {
  for_each = toset([
    "roles/viewer",  
    "roles/iam.workloadIdentityUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/compute.viewer",
    "roles/compute.networkViewer",
    "roles/container.viewer",
    "roles/cloudfunctions.viewer",
    "roles/run.viewer",
    "roles/appengine.appViewer",
    "roles/storage.objectViewer",
    "roles/bigquery.dataViewer",
    "roles/cloudsql.viewer",
    "roles/datastore.viewer",
    "roles/spanner.viewer",
    "roles/cloudasset.viewer",
    "roles/secretmanager.viewer",
    "roles/iam.securityReviewer",
    "roles/logging.viewer",
    "roles/monitoring.viewer",
    "roles/cloudkms.viewer",
    "roles/pubsub.viewer",
    "roles/artifactregistry.reader",
    "roles/cloudbuild.builds.viewer"
  ])
  
  project = var.gcp_project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.rapticore_service_account.email}"
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.rapticore_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.rapticore_workload_pool.name}/attribute.aws_account/${var.rapticore_account_id}"
  ]
}

# Outputs
output "pool_id" {
  value       = google_iam_workload_identity_pool.rapticore_workload_pool.workload_identity_pool_id
  description = "Pool Id for the Workload Identity Pool"
}

output "provider_id" {
  value       = google_iam_workload_identity_pool_provider.rapticore_workload_provider.workload_identity_pool_provider_id
  description = "Provider Id of the Workload Identity Pool Provider"
}

output "service_account_email" {
  value       = google_service_account.rapticore_service_account.email
  description = "The email address of the Rapticore Scanner service account"
}

output "service_account_name" {
  value       = google_service_account.rapticore_service_account.account_id
  description = "The account id of the Rapticore Scanner service account"
}
