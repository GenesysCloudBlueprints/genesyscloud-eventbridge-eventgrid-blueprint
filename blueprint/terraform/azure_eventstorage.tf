
//Create an event storage
resource "azurerm_storage_account" "genesyseventstorage" {
  name                     = var.azure_storage_account_name
  resource_group_name    = azurerm_resource_group.eventbridge_eventgrid_resource.name
  location               = azurerm_resource_group.eventbridge_eventgrid_resource.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

///Create a queue for the storage
resource "azurerm_storage_queue" "genesyseventqueue" {
  name                 = "genesyseventqueue"
  storage_account_name = azurerm_storage_account.genesyseventstorage.name
}

//Subscribe the queue to the event grid
resource "azurerm_eventgrid_event_subscription" "genesyseventsubscription" {
  name  = "genesyseventsubscription"
  scope = azurerm_eventgrid_topic.eventbridge_eventgrid_topic.id
  
  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.genesyseventstorage.id
    queue_name         = azurerm_storage_queue.genesyseventqueue.name
  }
}