# gcp-onboarding
GCP Project Onboarding for Rapticore


Use the Terraform template in this repository to create the service account using workload-identity-federation for access from your Rapticore environment.

You will need the _Rapticore Account Id_ (a Terraform template Parameter) which will be provided as part of your Rapticore setup and onboarding.

Deployment Options:

1. Google Cloud Console
- Log into your target GCP Project with permissions to create deployments in Infrastructure Manager.
- Click Create Deployment button on the top of the screen.
- Under Deployment details:
    - Enter a Friendly Id for the deployment e.g., Rapticore-cloud-extractor-setup.
    - Select appropriate region.
    - Select a terraform version.
    - Select a service account with owner role attached to it.
    - Download the terraform template for infrastructure manager on your device from [this link](https://raw.githubusercontent.com/rapticore/gcp-onboarding/refs/heads/main/infra-manager-template/main.tf)
    - Create a cloud storage bucket, and upload the terraform template.
    - Select gcs as Source of Terraform configuration and provide the link of the gcs bucket containing the terraform template i.e gs://your_bucket_name.
    - Click continue and enter rapticore_account_id as key1. Enter Rapticore Account Id provided to you by Rapticore as value1 for rapticore_account_id key.
    - Click add value and enter gcp_project_id as key2. Enter project id of your gcp project as value2 for gcp_project_id.
    - Click Create Deployment button on the bottom of the screen.
    - Review Progress, and once the deployment is created, provide the GCP Project Id and Project Number in Rapticore Portal.
    - If you've already deployed the infrastructure once and need to update it, update the terraform template in GCS bucket by downloading the up to date template from terraform templateand create a new revision for the previous deployment in infrastructure manager.


2. Google Cloud Command Line Deployment
- Install Terraform by following HashiCorp's official documentation for your operating system.
- Install Google Cloud CLI (gcloud) and configure Google Cloud account for deploying the stack using the gcloud CLI. Please consult Google Cloud documentation on gcloud CLI installation and configure gcloud authentication.
- Download the terraform template for cli with terraform on your device from [this link](https://raw.githubusercontent.com/rapticore/gcp-onboarding/refs/heads/main/terraform-cli/main.tf).
- Once both Terraform and gcloud are configured, run the following commands replacing:
  - YOUR-PROJECT-ID: Your Google Cloud project ID
  - YOUR-RAPTICORE-ID: Your Rapticore account ID (12 digits)
  - BUCKET_NAME_FOR_STATEFILE : Your gcs bucket to store terraform statefile.

### Initialize the working directory containing Terraform configuration files
`terraform init`
***

### Preview the execution plan and verify resources that will be created
`terraform plan -var="gcp_project_id=YOUR-PROJECT-ID" -var="rapticore_account_id=YOUR-RAPTICORE-ID"`
***

### Apply the changes to reach the desired state of configuration
`terraform apply -var="gcp_project_id=YOUR-PROJECT-ID" -var="rapticore_account_id=YOUR-RAPTICORE-ID"`
