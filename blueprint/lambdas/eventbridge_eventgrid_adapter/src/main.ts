import { EventBridgeHandler } from 'aws-lambda';
import { EventGridPublisherClient, AzureKeyCredential } from "@azure/eventgrid";

export const adapt:  EventBridgeHandler<string, {message: string}, boolean> = async (event) => {
    const endpoint = process.env["EVENT_GRID_EVENT_GRID_SCHEMA_ENDPOINT"] || "";
    const accessKey = process.env["EVENT_GRID_EVENT_GRID_SCHEMA_API_KEY"] || "";

    try {
        const client = new EventGridPublisherClient(endpoint,"EventGrid",new AzureKeyCredential(accessKey));

        await client.send([
            {
              eventType: "GenesysCloudEvent",
              subject: "genesysCloud/sendEvent",
              dataVersion: "1.0",
              data: {
                message: event
              }
            }
          ]);
        
        console.log(event);
        
    } catch (err) {
        console.log(err);
    }

    return true;
};