"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.adapt = void 0;
const eventgrid_1 = require("@azure/eventgrid");
const adapt = async (event) => {
    const endpoint = process.env["EVENT_GRID_EVENT_GRID_SCHEMA_ENDPOINT"] || "";
    const accessKey = process.env["EVENT_GRID_EVENT_GRID_SCHEMA_API_KEY"] || "";
    try {
        const client = new eventgrid_1.EventGridPublisherClient(endpoint, "EventGrid", new eventgrid_1.AzureKeyCredential(accessKey));
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
    }
    catch (err) {
        console.log(err);
    }
    return true;
};
exports.adapt = adapt;
//# sourceMappingURL=main.js.map