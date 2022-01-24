resource "azurerm_resource_group" "rg01" {
  name     = "${var.prefix}-${var.environment}-rg01"
  location = var.location

  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_virtual_network" "vnet01" {
  name                = "${var.prefix}-${var.environment}-vnet01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  address_space       = ["10.1.0.0/16"]

  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_subnet" "subnet01" {
  name                                           = "${var.prefix}-${var.environment}-subnet01"
  resource_group_name                            = azurerm_resource_group.rg01.name
  virtual_network_name                           = azurerm_virtual_network.vnet01.name
  address_prefixes                               = ["10.1.0.0/25"]
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.Storage"]
}

resource "azurerm_network_security_group" "nsg01" {
  name                = "${var.prefix}-${var.environment}-nsg01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location

  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet01-nsg01" {
  subnet_id                 = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}

resource "azurerm_private_endpoint" "pe01" {
  name                = "${var.prefix}-${var.environment}-pe01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  subnet_id           = azurerm_subnet.subnet01.id

  private_service_connection {
    name                           = azurerm_storage_account.sa01.name
    private_connection_resource_id = azurerm_storage_account.sa01.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "nfs-internal-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dsnz01.id]
  }
}

resource "azurerm_private_dns_zone" "dsnz01" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg01.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dsnzvnetlink01" {
  name                  = "${var.prefix}-${var.environment}-dsnzvnetlink01"
  resource_group_name   = azurerm_resource_group.rg01.name
  private_dns_zone_name = azurerm_private_dns_zone.dsnz01.name
  virtual_network_id    = azurerm_virtual_network.vnet01.id
}

resource "azurerm_kubernetes_cluster" "aks01" {
  name                = "${var.prefix}-${var.environment}-aks01"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  dns_prefix          = "${var.prefix}-${var.environment}-aks01"
  kubernetes_version  = "1.22.6"

  default_node_pool {
    name                = "default"
    node_count          = var.vm_min_count
    vm_size             = var.vm_size
    vnet_subnet_id      = azurerm_subnet.subnet01.id
    enable_auto_scaling = true
    min_count           = var.vm_min_count
    max_count           = var.vm_max_count
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_role_assignment" "ra01" {
  scope                = azurerm_resource_group.rg01.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks01.identity[0].principal_id
}

data "azurerm_kubernetes_cluster" "dataaks01" {
  name                = resource.azurerm_kubernetes_cluster.aks01.name
  resource_group_name = azurerm_resource_group.rg01.name
}

resource "azurerm_role_assignment" "ra02" {
  scope                = azurerm_storage_account.sa01.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_kubernetes_cluster.dataaks01.kubelet_identity[0].object_id
}

resource "azurerm_managed_disk" "md01" {
  name                 = "${var.prefix}-${var.environment}-md01"
  resource_group_name  = azurerm_resource_group.rg01.name
  location             = azurerm_resource_group.rg01.location
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "32"

  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_storage_account" "sa01" {
  name                      = replace("${var.prefix}-${var.environment}-sa01", "-", "")
  resource_group_name       = azurerm_resource_group.rg01.name
  location                  = azurerm_resource_group.rg01.location
  account_tier              = "Premium"
  account_replication_type  = "LRS"
  account_kind              = "FileStorage"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = false

  tags = {
    managed-by = "terraform"
  }
}

resource "azurerm_storage_share" "ss01" {
  name                 = "${var.prefix}-${var.environment}-ss01"
  storage_account_name = azurerm_storage_account.sa01.name
  enabled_protocol     = "NFS"
  quota                = 100
}

resource "azurerm_storage_share" "ss02" {
  name                 = "${var.prefix}-${var.environment}-ss02"
  storage_account_name = azurerm_storage_account.sa01.name
  enabled_protocol     = "NFS"
  quota                = 100
}

resource "azurerm_storage_account_network_rules" "sanr01" {
  storage_account_id         = azurerm_storage_account.sa01.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.subnet01.id]
  bypass                     = ["Metrics"]
}
