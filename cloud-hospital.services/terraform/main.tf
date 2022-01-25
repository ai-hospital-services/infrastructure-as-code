resource "azurerm_resource_group" "rg01" {
  name     = "${var.prefix}-${var.environment}-rg01"
  location = var.location

  tags = {
    managedby = "terraform"
  }
}

resource "azurerm_virtual_network" "vnet01" {
  name                = "${var.prefix}-${var.environment}-vnet01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  address_space       = ["10.1.0.0/16"]

  tags = {
    managedby = "terraform"
  }
}

resource "azurerm_subnet" "subnet01" {
  name                 = "${var.prefix}-${var.environment}-subnet01"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["10.1.0.0/25"]
}

resource "azurerm_network_security_group" "nsg01" {
  name                = "${var.prefix}-${var.environment}-nsg01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location

  tags = {
    managedby = "terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet01-nsg01" {
  subnet_id                 = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}

resource "azurerm_kubernetes_cluster" "aks01" {
  name                = "${var.prefix}-${var.environment}-aks01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  dns_prefix          = "${var.prefix}-${var.environment}-aks01"
  kubernetes_version  = "1.22.4"

  default_node_pool {
    name           = "default"
    node_count     = var.vm_count
    vm_size        = var.vm_size
    vnet_subnet_id = azurerm_subnet.subnet01.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    managedby = "terraform"
  }
}

resource "azurerm_role_assignment" "ra01" {
  scope                = azurerm_resource_group.rg01.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks01.identity[0].principal_id
}

resource "azurerm_managed_disk" "md01" {
  name                 = "${var.prefix}-${var.environment}-md01"
  resource_group_name  = azurerm_resource_group.rg01.name
  location             = azurerm_resource_group.rg01.location
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "16"

  tags = {
    managedby = "terraform"
  }
}

resource "azurerm_managed_disk" "md02" {
  name                 = "${var.prefix}-${var.environment}-md02"
  resource_group_name  = azurerm_resource_group.rg01.name
  location             = azurerm_resource_group.rg01.location
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "32"

  tags = {
    managedby = "terraform"
  }
}