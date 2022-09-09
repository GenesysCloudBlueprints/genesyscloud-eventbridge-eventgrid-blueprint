
resource "azurerm_resource_group" "eventbridge_eventgrid_resource" {
  name     = "devengage-eventbridge-eventgrid"
  location = "West US"
}

resource "azurerm_eventgrid_topic" "eventbridge_eventgrid_topic" {
  name                   = "genesyscloudtopic"
  resource_group_name    = azurerm_resource_group.eventbridge_eventgrid_resource.name
  location               = azurerm_resource_group.eventbridge_eventgrid_resource.location
}

data "azurerm_eventgrid_topic" "created_eventgrid" {
  name                = azurerm_eventgrid_topic.eventbridge_eventgrid_topic.name
  resource_group_name = azurerm_resource_group.eventbridge_eventgrid_resource.name
}
