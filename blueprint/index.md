---
title: Send Genesys Cloud events from AWS EventBridge to Azure Event Grid
author: john.carnell
indextype: blueprint
icon: blueprint
image: images/overview.png
category: 5	
summary: This Genesys Cloud Developer blueprint demonstrates how to use Genesys Cloud's AWS EventBridge integration and an AWS Lambda to send messages from Genesys Cloud to Amazon Event Azure Event Grid.
---
:::{"alert":"primary","title":"About Genesys Cloud Blueprints","autoCollapse":false} 
Genesys Cloud blueprints were built to help you jump-start building an application or integrating with a third-party partner. 
Blueprints are meant to outline how to build and deploy your solutions, not a production-ready turn-key solution.
 
For more details on Genesys Cloud blueprint support and practices 
please see our Genesys Cloud blueprint [FAQ](https://developer.genesys.cloud/blueprints/faq)sheet.
:::

![Send Genesys Cloud events from AWS EventBridge to Azure Event Grid](images/overview.png "Send Genesys Cloud events from AWS EventBridge to Azure Event Grid")

This blueprint also demonstrates how to:

* Configure Genesys Cloud/AWS EventBridge integration using CX as Code
* Configure Azure to subscribe to an Event Grid topic that will post the event to an Azure Queue using the Terraform providers
* Build and deploy a Typescript for AWS Lambda to proxy the request to the subscribed Event Grid endpoint

## Scenario
Genesys Cloud is an event-driven platform that can publish events occurring within the platform in a near-time event stream. Currently, there are two mechanisms to consume events from Genesys Cloud:

1. [Notification Service](/notificationsalerts/notifications/). The notification service is a web-socket based API for listening to Genesys Cloud events. The notification service APIs are primarily used for near-time event processing in a UI-based integration like a dashboard or agent-based tool.
2. [AWS EventBridge](/notificationsalerts/notifications/event-bridge). An enterprise-level AWS managed message bus with high resiliency and scalability degrees. This mechanism is primarily used for back-end, system-to-system style integrations.

Genesys Cloud supports only native integration with AWS resources. When most of your development effort and infrastructure are in the cloud other than AWS, you require a solution that minimizes your AWS footprint and allows you to use your preferred cloud platform.

## Solution
 Build a proxy from Amazon EventBridge to your target cloud environment. This blueprint explains how to achieve this solution using the following Genesys Cloud features:

1. **Genesys Cloud Integration for AWS EventBridge**. A Genesys Cloud integration sends Genesys Cloud events to AWS EventBridge. 
2. **AWS EventBridge**. A managed message bus that receives messages from Genesys Cloud and routes them to an AWS target.
3. **AWS Lambda**. A serverless function that takes a message from Genesys Cloud and changes it into a message format as required in Event Grid. The message is then sent to Event Grid.
4. **Azure Event Grid**. A managed message bus hosted in Azure. In this implementation, the Azure Event Grid routes the incoming message to an Azure message topic for future processing.
5. **Azure Queue**. An Azure message queue that holds the Genesys Cloud events passed over to Azure Event Grid

:::{"alert":"Warning","title":"This blueprint is not a turnkey solution","autoCollapse":false}
This blueprint is an illustrative example of how to integrate Genesys Cloud, AWS and Microsoft Azure features. It is not a turnkey solution that is resilient and secure. Ensure that you take adequate measures for error handling and security needs for your organization when you implement this blueprint solution.
:::

## Solution components

* **Genesys Cloud CX**. A suite of services for enterprise-grade communications, collaboration, and contact center management. You use an Architect bot, Architect message flow, a Genesys Cloud integration, data action, queues, and a web messaging widget.
* **CX as Code**. A Genesys Cloud Terraform provider that provides an interface for declaring core Genesys Cloud objects.
* **AWS Terraform Provider** - An Amazon-supported Terraform service provides an interface for declaring AWS infrastructure resources including EC2, Lambda, EKS, ECS, VPC, S3, RDS, DynamoDB, and more.
* **Amazon Web Services (AWS) Cloud**. A set of cloud computing capabilities managed by Amazon. Genesys Cloud events can be sent to AWS EventBridge.
* **Microsoft Azure Cloud**. A set of cloud computing capabilities managed by Microsoft. 

 ## Software development kits

Genesys Cloud SDKs are not required for this blueprint solution. If you want to change the AWS Lambda, install the Node runtime and Typescript programming language. For the latest node installation, see the [node](https://nodejs.org/en/) website. For the latest Typescript installation, see the [TypeScript is JavaScript with syntax for types](https://www.typescriptlang.org/ "Goes to the TypeScript is JavaScript with syntax for types page") on the TypeScript website.

By default, the Terraform files deploys a pre-compiled AWS lambda. The source code for the AWS Lambda is available in this blueprint and if you want to make changes, see [Optionally update the AWS Lambda](#optionally-update-the-aws-lambda "Goes to the Optionally update the AWS Lambda section").

## Prerequisites

### Specialized knowledge

* Administrator-level knowledge of Genesys Cloud
* AWS Cloud Practitioner-level knowledge of AWS IAM, AWS EventBridge, and AWS Lambda
* Azure Cloud Practitioner-level knowledge of Azure Event Grid, Azure Storage, and Azure 
* Experience with Terraform
* A working knowledge of Node and Typescript

### Genesys Cloud account

* A Genesys Cloud license. For more information, see [Genesys Cloud Pricing](https://www.genesys.com/pricing "Opens the Genesys Cloud pricing page") on the Genesys website. 
* Master Admin role. For more information, see [Roles and permissions overview](https://help.mypurecloud.com/?p=24360 "Goes to the Roles and permissions overview article") in the Genesys Cloud Resource Center.
* CX as Code. For more information, see [CX as Code](https://developer.genesys.cloud/api/rest/CX-as-Code/ "Goes to the CX as Code page") in the Genesys Cloud Developer Center.

### AWS account

* An administrator account with permission to access these services:
  * AWS Identity and Access Management (IAM)
  * AWS EventBridge
  * AWS Lambda
  * AWS credentials

### Azure account

* An administrator account with permission to access these services:
  * Azure Security
  * Azure Event Grid
  * Azure Storage
  * Azure Queue
  * Azure credentials  

### Development tools running in your local environment

* Terraform (v1.1.8 or higher). For more information, see [Download Terraform](https://www.terraform.io/downloads.html "Goes to the Download Terraform page") on the Terraform website.
* Typescript 4.6.3 or higher. For more information, see [Downloads](https://www.typescriptlang.org/ "Goes to the Typescript Downloads page") on the Typescript website.
* Node 17.9.0 or higher. For more information, see [Downloads](https://nodejs.org/en/ "Goes to the Node page") on the node website.

## Implementation steps

### Clone the GitHub repository

Clone the [deploy-evenbridge-eventgrid-blueprint](https://github.com/GenesysCloudBlueprints/genesyscloud-eventbridge-eventgrid-blueprint "Goes to the https://github.com/GenesysCloudBlueprints/genesyscloud-eventbridge-eventgrid-blueprint page") in the GitHub repository on your local machine. The `deploy-evenbridge-eventgrid-blueprint` folder includes solution-specific scripts and files in these subfolders.

* `blueprint/lambdas/eventbridge_eventgrid_adapter` - Source code for the AWS Lambda used in this application
* `terraform` - All Terraform file flows that are required to deploy the solution

### Set up your AWS credentials

For information about setting up your AWS credentials on your local machine, see [Sign in with Azure CLI](https://docs.aws.amazon.com/sdkref/latest/guide/creds-config-files.html "Goes to the Configuration page") on the AWS website.

### Set up your Azure credentials

For information about setting up your Azure credentials on your local machine, see [Sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli "Goes to the Sign in with Azure CLI page") on the Microsoft Azure website. 

:::{"alert":"primary","title":"Authenticating with the Terraform provider","autoCollapse":false}
To use the Terraform provider with Azure, you must create a service principal with a client secret. For more information, see [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret "Goes the Azure Provider: Authenticating using a Service Principal with a Client Secret page") on the Terraform website.
:::

### Set up your Genesys Cloud credentials

1. To run this project using the CX as Code, AWS Terraform provider, and Azure Terraform provider, open a Terminal window and set the following environment variables:

 * `GENESYSCLOUD_OAUTHCLIENT_ID` - The Genesys Cloud client credential grant Id that CX as Code executes against. 
 * `GENESYSCLOUD_OAUTHCLIENT_SECRET` - The Genesys Cloud client credential secret that CX as Code executes against. 
 * `GENESYSCLOUD_REGION` - The Genesys Cloud region for your organization.
 * `AWS_ACCESS_KEY_ID` - The AWS Access Key you must set up in your Amazon account to allow the AWS Terraform provider to act against your account.
 * `AWS_SECRET_ACCESS_KEY` - The AWS Secret you must set up in your Amazon account to allow the AWS Terraform provider to act against your account.
 * `CLIENT_ID` - The Azure Access Key you must set up in your Azure account to allow the Azure Terraform provider to act against your account.
 * `CLIENT_SECRET` - The Azure Secret you must set up in your Azure account to allow the Azure Terraform provider to act against your account.
 * `TENANT_ID` - The Azure Tenant id for your Azure account.

2. Run all the required Terraform commands in the same terminal window.

:::primary
**Note:** In this project, the Genesys Cloud OAuth client is given the Master Admin role.
:::

### Configure your Terraform build

You must define several values that are specific to Genesys Cloud, AWS, and Azure account configuration.

The following values must be defined:

* `aws_region` - The AWS region (for example, us-east-1, us-west-2) where you are going to deploy the target AWS Event bus.
* `aws_account_id` - The AWS account identifier of your AWS account.
* `event_bus_name` - The AWS EventBus name of the Terraform code you created.
* `genesys_cloud_organization_id` - Your Genesys Cloud organization ID.
* `genesys_cloud_event_bridge_topic_filters` - A list of Genesys Cloud events that you want to pass to Event Bridge. See the list of available events [here](/notificationsalerts/notifications/available-topics). Make sure to filter on "Event Bridge"
*  `azure_storage_account_name` - A globally unique name for your azure storage account that will hold your message queue.
*  `azure_storage_queue_name` - A globally unique queue name for the message queue

You can pass these values via the terraform command, a terraform autovars file, or environment values. The Terraform directory of this project has the two files `setup.sh` (for *nix and OS X) and a 
`setup.bat`. Populate these fields with the values and run the script or bat file to launch the Terraform project in your environment. 

An example of the `setup.sh` file:

```
# CX AS CODE PROVIDER-CONFIG 
export GENESYSCLOUD_OAUTHCLIENT_ID="3myb45d2-ate32-4709-a652-DUMMYCLIENTID"
export GENESYSCLOUD_OAUTHCLIENT_SECRET="dummyWqwOoauthWEo0PC2iKu22Owsecret"
export GENESYSCLOUD_REGION="us-west-2"

# Azure Provider Environment values
export CLIENT_ID=dummy478-bd88-azureclient-bbb8-6f211f9867678a
export CLIENT_SECRET=LdummyPErU6yfazureclientsecrets.4gUJ36JY0r4dtf
export TENANT_ID=dummy6fd-azure0fc5-tenant-a6bd-8bssdf32947

# AWS Provider Environment variables
export AWS_ACCESS_KEY_ID="ASdummy_aws_keyB4FPddfsd"
export AWS_SECRET_ACCESS_KEY="xdsfsdfsdm2fasdgsdfgsdfgewrtewrtdsfgsdfgds"

# AWS_SESSION_TOKEN is only needed if you are using two-factor authentication
export AWS_SESSION_TOKEN="TOKEN"

# Configuration the terraform resources need to setup the integration
export TF_VAR_aws_region="us-west-2"
export TF_VAR_aws_account_id="435681138675"     #Your AWS Account Id
export TF_VAR_event_bus_name="genesys-carnell1"
export TF_VAR_genesys_cloud_organization_id="011a0480-9a1e-4da9-8cdd-2642474cf92a"   # Your Genesys Cloud Org Id
export TF_VAR_genesys_cloud_event_bridge_topic_filters='["v2.users.{id}.presence"]'  # Note how array of events are positioned
export TF_VAR_azure_storage_account_name="genesyseventstorage"
export TF_VAR_azurerm_storage_queue_name="genesyseventqueuejcc"

# Running a terraform plan
echo "Running Terraform plan and saving to myplan file.  Note: This plan file is in a binary encoded format and is not readable in a text editor"
echo "------------------------------------------------------"
terraform plan -out=myplan
echo "------------------------------------------------------"
echo "To apply your changes run terraform apply.  You will be prompted to approve the changes before deployment. " 
echo "To deploy without auto-approval run terraform apply --auto-approve"
```

:::{"alert":"primary","title":"The above values are examples only","autoCollapse":false}
Ensure that you replace the values that are specific to your organization.
:::

### Run Terraform

You are ready to run this blueprint solution for your organization. 

Change to the `blueprints/terraform` and run the `setup.sh`  or `setup.bat` command from the command prompt (For example, in Linux or Windows, execute the command as `./setup.sh`). The script executes only a Terraform plan. However, all the environmental variables are set in your shell, and you can perform the following Terraform commands from the terminal window:

* `terraform init` - This initializes your Terraform project by installing the CX as Code and setting up AWS, Azure providers, and other remote modules. Note: `terraform init` is idempotent and can be run by multiple teams even if the project is already initialized.

* `terraform plan` - This executes a trial run against your Genesys Cloud organization and shows you a list of all the created AWS and Genesys Cloud resources. Review this list and ensure you are comfortable with the activity before continuing.

* `terraform apply --auto-approve` - This executes the actual object creation and deployment against your AWS and Genesys Cloud accounts. After the --auto--approve commands are complete, you should see the approval step required before creating the objects.

After the `terraform apply --auto-approve` command completes, you should see the output of the entire run along with the number of objects successfully created by Terraform.

* This project assumes you are running using a local Terraform backing state. This means that the `tfstate` files will be created in the same folder where you ran the project. Terraform does not recommend using local Terraform backing state files unless you run from a desktop and are comfortable with the deleted files.

* As long as you keep your local Terraform backing state projects, you can tear down the blueprint in question by changing to the `blueprint/terraform` folder and issuing a `terraform destroy --auto-approve` command. This destroys all objects currently managed by the local Terraform backing state.

### Test your deployment
Deploy your blueprint and send it across v2.users.{id}.presence events.

1.  Log in to your Genesys Cloud organization.
2.  Change your presence status to something other than available (e.g., Busy, Away, Break, Meal, etc...)
3.  Log in to your Microsoft Azure account.
4.  Navigate to `Event Grid>Topics->genesyscloudtopic`.
5.  Search the `genesyseventsubscription`, and click the link.
6.  Search the `genesyseventqueue`, and click the link.
7.  For the `genesyseventstorage` object, select Data storage->Queues.
8.  Search and click the `genesyseventqueue`.


Displays a table of Genesys Cloud events that are passed over.

9. Click the event Id to display the details. 

## Additional resources
* [Amazon EventBridge integration](https://developer.genesys.cloud/notificationsalerts/notifications/event-bridge "Goes to the GAmazon EventBridge integration page") in the Genesys Cloud Developer Center.
* [AWS EventBridge documentation](https://docs.aws.amazon.com/eventbridge/?id=docs_gateway "Goes to the AWS EventBridge documentation page") on the AWS website.
* [Azure Event Grid documentation](https://learn.microsoft.com/en-us/azure/event-grid/ "Goes to the Microsoft Azure documentation page") on the Microsoft Azure website.
* [Event Driven Integrations in Genesys Cloud](https://developer.genesys.cloud/blog/2021-12-02-Event-Streaming-In-Action/ "Goes to the Event Driven Integrations blog page") in the Genesys Cloud Developer Center.
* [Introducing the Genesys Cloud AWS EventBridge Integration](https://www.youtube.com/watch?v=1uqEUpFtk8Q&t=402s "Goes to the DevDrop 15: Introducing the Genesys AWS EventBridge Integration video") in YouTube.
