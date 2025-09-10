module "resource_group_name" {
  source = "../modules/azurerm_resource_group"

  resource_group_name     = "yuviinsiders"
  resource_group_location = "centralindia"
}
module "virtual_network" {
  depends_on = [module.resource_group_name]
  source     = "../modules/azurerm_virtual_network"

  virtual_network_name     = "yuvi_vnet"
  virtual_network_location = "centralindia"
  resource_group_name      = "yuviinsiders"
  address_space            = ["10.0.0.0/16"]

}

module "frontend_subnet" {
  depends_on = [module.resource_group_name, module.virtual_network]

  source = "../modules/azurerm_subnet"

  resource_group_name  = "yuviinsiders"
  subnet_name          = "frontend_subnet"
  virtual_network_name = "yuvi_vnet"
  address_prefixes     = ["10.0.0.0/24"]
}

module "superlinux_vm" {

  depends_on = [ module.resource_group_name, module.frontend_subnet, module.virtual_network ]

  source     = "../modules/azurerm_virtual_machine"

  resource_group_name     = "yuviinsiders"
  resource_group_location = "centralindia"
  vm_name                 = "superlinux-vm"
  vm_size                 = "Standard_B1s"
  admin_username          = "adminuser"
  admin_password          = "Welcome@1234"
  image_publisher         = "canonical"
  image_offer             = "0001-com-ubuntu-server-jammy"
  image_sku               = "22_04-lts"
  image_version           = "latest"
  nic_name                = "nic-superlinux-vm"
  frontend_subnet_name    = "frontend_subnet"
  virtual_network_name    = "yuvi_vnet"

}
