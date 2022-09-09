# Send Genesys Cloud events from AWS EventBridge to Azure EventGrid (DRAFT)
This Genesys Cloud blueprint demonstrates how to pass Genesys Cloud events over to AWS EventBridge and then via an AWS Lambda, to Microsoft Azure's EventGrid.

This blueprint also demonstrates how to:

* Build and configure the Genesys Cloud/AWS EventBridge integration
* Build and configure Azure to expose an EventGrid topic that will post the event to an Azure Queue
* Build a simple Typescript AWS lambda to proxy the request to exposed Azure EventGrid endpoint


![Send Genesys Cloud events from AWS EventBridge to Azure EventGrid](blueprint/images/overview.png "Send Genesys Cloud events from AWS EventBridge to Azure EventGrid")

