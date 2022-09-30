# CX AS CODE PROVIDER-CONFIG 
set GENESYSCLOUD_OAUTHCLIENT_ID=""
set GENESYSCLOUD_OAUTHCLIENT_SECRET=""
set GENESYSCLOUD_REGION=""

# Azure Provider Environment variables
set CLIENT_ID=""
set CLIENT_SECRET=""
set TENANT_ID=""

# AWS Provider Environment variables
set AWS_ACCESS_KEY_ID=""
set AWS_SECRET_ACCESS_KEY=""

# AWS_SESSION_TOKEN is only needed you are using two factor authentication
set AWS_SESSION_TOKEN=""

# Configuration the terraform resources need to setup the integration
set TF_VAR_aws_region=""
set TF_VAR_aws_account_id=""
set TF_VAR_event_bus_name=""
set TF_VAR_genesys_cloud_organization_id=""
set TF_VAR_genesys_cloud_event_bridge_topic_filters="" #Example string -> '["v2.users.{id}.presence"]'
set TF_VAR_azure_storage_account_name=""
set TF_VAR_azurerm_storage_queue_name=""

# Running a terraform plan
echo "Running Terraform plan and saving to myplan file.  Note: This plan file is in a binary encoded format and is not readable in a text editor"
echo "------------------------------------------------------"
terraform.exe plan -out=myplan
echo "------------------------------------------------------"
echo "To apply your changes run terraform.exe apply.  You will be prompted to approve the changes before deployment. " 
echo "To deploy with auto-approval run terraform.exe apply --auto-approve"