# CX AS CODE PROVIDER-CONFIG 
export GENESYSCLOUD_OAUTHCLIENT_ID=""
export GENESYSCLOUD_OAUTHCLIENT_SECRET=""
export GENESYSCLOUD_REGION="us-west-2"

# Azure Provider Environment variables
export CLIENT_ID=""
export CLIENT_SECRET=""
export TENANT_ID=""

# AWS Provider Environment variables
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

# AWS_SESSION_TOKEN is only needed you are using two factor authentication
export AWS_SESSION_TOKEN=""

# Configuration the terraform resources need to setup the integration
export TF_VAR_aws_region=""
export TF_VAR_aws_account_id=""
export TF_VAR_event_bus_name=""
export TF_VAR_genesys_cloud_organization_id=""
export TF_VAR_genesys_cloud_event_bridge_topic_filters="" #Example string -> '["v2.users.{id}.presence"]'
export TF_VAR_azure_storage_account_name=""
export TF_VAR_azurerm_storage_queue_name=""

# Running a terraform plan
echo "Running Terraform plan and saving to myplan file.  Note: This plan file is in a binary encoded format and is not readable in a text editor"
echo "------------------------------------------------------"
terraform init
terraform plan -out=myplan
echo "------------------------------------------------------"
echo "To apply your changes run terraform apply.  You will be prompted to approve the changes before deployment. " 
echo "To deploy with auto-approval run terraform apply --auto-approve"

