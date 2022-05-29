locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.this :
    subnet.name => subnet.id
  }
}
