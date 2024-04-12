resource "azurerm_resource_group" "a12_rg" {

  name = "${var.label_prefix}-a12-rg"

  location = var.region

}
