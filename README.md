# gcp-onboarding
GCP Project Onboarding for Rapticore


Use the Terraform template in this repository to create the service account using workload-identity-federation for access from your Rapticore environment.

You will need the _Rapticore Account Id_ (a Terraform template Parameter) which will be provided as part of your Rapticore setup and onboarding.

Deployment Options:

1 Google Cloud Command Line Deployment
- Install Terraform by following HashiCorp's official documentation for your operating system.
- Install Google Cloud CLI (gcloud) and configure Google Cloud account for deploying the stack using the gcloud CLI. Please consult Google Cloud documentation on gcloud CLI installation and configure gcloud authentication.
- Once both Terraform and gcloud are configured, run the following commands replacing:
  - YOUR-PROJECT-ID: Your Google Cloud project ID
  - YOUR-RAPTICORE-ID: Your Rapticore account ID (12 digits)
  - BUCKET_NAME_FOR_STATEFILE: GCS Bucket name to store terraform statefile

### Initialize the working directory containing Terraform configuration files
`terraform init -backend-config="bucket=BUCKET_NAME_FOR_STATEFILE" -backend-config="prefix=terraform/state"
`
***

### Preview the execution plan and verify resources that will be created
`terraform apply \
  -var="YOUR-RAPTICORE-ID" \
  -var="gcp_project_id=YOUR-PROJECT-ID" \
  -var="state_bucket=BUCKET_NAME_FOR_STATEFILE"`
***

### Apply the changes to reach the desired state of configuration
`terraform apply \
  -var="YOUR-RAPTICORE-ID" \
  -var="gcp_project_id=YOUR-PROJECT-ID" \
  -var="state_bucket=GCS_PATH_FOR_STATEFILE"`
