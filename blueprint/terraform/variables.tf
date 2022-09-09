variable "aws_account_id" {
  type        = string
  description = "The target AWS account id that Genesys Cloud will install the AWS EventBridge Partner Event Source"
}

variable "aws_region" {
  type        = string
  description = "Aws region where the resources to be provisioned."
}

variable "event_bus_name" {
  type        = string
  description = "Aws region where the resources to be provisioned."
}


variable "genesys_cloud_organization_id" {
  type        = string
  description = "Genesys Cloud Organization Id"
}

variable "genesys_cloud_event_bridge_topic_filters" {
  type        = list
  description = "List of Genesys Cloud events you want to sent to AWS event bridge"
}

