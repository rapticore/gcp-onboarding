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
    - For Source of Terraform configuration, select Git.
    - Provide the link of this repository for git repository field.
    - Click continue button

- Under Terraform details:  
    - Enter project id of your GCP project as input value for gcp_project_id parameter.
    - Enter Rapticore Account Id provided to you by Rapticore as input value for rapticore_account_id parameter.
    - Click Create Deployment button on the bottom of the screen.
    - Review Progress, and once the deployment is created, provide the GCP Project Id and Project Number in Rapticore Portal. 

2. Google Cloud Command Line Deployment
- Install Terraform by following HashiCorp's official documentation for your operating system.
- Install Google Cloud CLI (gcloud) and configure Google Cloud account for deploying the stack using the gcloud CLI. Please consult Google Cloud documentation on gcloud CLI installation and configure gcloud authentication.
- Once both Terraform and gcloud are configured, run the following commands replacing:
  - YOUR-PROJECT-ID: Your Google Cloud project ID
  - YOUR-RAPTICORE-ID: Your Rapticore account ID (12 digits)

### Initialize the working directory containing Terraform configuration files
`terraform init`
***

### Preview the execution plan and verify resources that will be created
`terraform plan -var="gcp_project_id=YOUR-PROJECT-ID" -var="rapticore_account_id=YOUR-RAPTICORE-ID"`
***

### Apply the changes to reach the desired state of configuration
`terraform apply -var="gcp_project_id=YOUR-PROJECT-ID" -var="rapticore_account_id=YOUR-RAPTICORE-ID"`
