provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tst-eta" {
  name     = "rg-tst-mlapps-eta"
  location = "southcentralus"
  tags = {
    "Application Name"    = "Expected Time of Arrival"
    "Team Name"           = "Enterprise Analytics"
    "Cost Center"         = "94112"
    "IS Owner"            = "Zee Hussain"
    "Business Unit Owner" = "Tony Ricchio"
    "Created By"          = "Cloud Product Team"
    "Environment"         = "tst"
    "Requested By"        = "Zee  Hussain"
    "Medline Tier"        = "Tier 2"
    "STAR"                = ""
    "POC Expiration"      = ""
    "PHI Data"            = "No"
  }
}

resource "azurerm_template_deployment" "dev-eta" {
  name                = "ml-eta-tst-template"
  resource_group_name = azurerm_resource_group.tst-eta.name
  template_body = jsonencode(
    {
      "contentVersion" : "1.0.0.0",
      "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
      "variables" : {
        "namePrefix" : "[resourceGroup().name]",
        "location" : "[resourceGroup().location]",
        "mlVersion" : "2016-04-01",
        "stgVersion" : "2020-08-01-preview",
        "storageAccountName" : "storussctstmlapps",
        "mlWorkspaceName" : "ml-ussc-tst-mlapps-eta",
        "mlResourceId" : "[resourceId('Microsoft.MachineLearning/workspaces', variables('mlWorkspaceName'))]",
        "stgResourceId" : "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]",
        "storageAccountType" : "Standard_LRS"
      },
      "resources" : [
        {
          "apiVersion" : "[variables('stgVersion')]",
          "name" : "[variables('storageAccountName')]",
          "type" : "Microsoft.Storage/storageAccounts",
          "location" : "[variables('location')]",
          "tags" : {
            "Application Name"    = "Expected Time of Arrival",
            "Team Name"           = "Enterprise Analytics",
            "Cost Center"         = "94112",
            "IS Owner"            = "Syed Zee Hussain",
            "Business Unit Owner" = "Tony Ricchio",
            "Created By"          = "Cloud Product Team",
            "Environment"         = "tst",
            "Requested By"        = "Zee  Hussain",
            "Medline Tier"        = "Tier 2",
            "STAR"                = "",
            "POC Expiration"      = "",
            "PHI Data"            = "No"
          },
          "properties" : {
            "accountType" : "[variables('storageAccountType')]"
            "kind" : "StorageV2",
          }
        },
        {
          "apiVersion" : "[variables('mlVersion')]",
          "type" : "Microsoft.MachineLearning/workspaces",
          "name" : "[variables('mlWorkspaceName')]",
          "location" : "[variables('location')]",
          "dependsOn" : ["[variables('stgResourceId')]"],
          "tags" : {
            "Application Name"    = "Expected Time of Arrival",
            "Team Name"           = "Enterprise Analytics",
            "Cost Center"         = "94112",
            "IS Owner"            = "Syed Zee Hussain",
            "Business Unit Owner" = "Tony Ricchio",
            "Created By"          = "Cloud Product Team",
            "Environment"         = "tst",
            "Requested By"        = "Zee  Hussain",
            "Medline Tier"        = "Tier 2",
            "STAR"                = "",
            "POC Expiration"      = "",
            "PHI Data"            = "No"
          },
          "properties" : {
            "UserStorageAccountId" : "[variables('stgResourceId')]"
            "ownerEmail" : "pa-gmyneni@medline.com"
          }
        }
      ],
      "outputs" : {
        "mlWorkspaceObject" : { "type" : "object", "value" : "[reference(variables('mlResourceId'), variables('mlVersion'))]" },
        "mlWorkspaceToken" : { "type" : "string", "value" : "[listWorkspaceKeys(variables('mlResourceId'), variables('mlVersion')).primaryToken]" },
        "mlWorkspaceWorkspaceID" : { "type" : "string", "value" : "[reference(variables('mlResourceId'), variables('mlVersion')).WorkspaceId]" },
        "mlWorkspaceWorkspaceLink" : { "type" : "string", "value" : "[concat('https://studio.azureml.net/Home/ViewWorkspace/', reference(variables('mlResourceId'), variables('mlVersion')).WorkspaceId)]" }
      }
    }
  )
  deployment_mode = "Incremental"
}

data "azurerm_storage_account" "storage02" {
  name                = "storussctstmlapps"
  resource_group_name = "rg-tst-mlapps-eta"
}


resource "azurerm_storage_account_network_rules" "storage-network" {
  storage_account_id = data.azurerm_storage_account.storage02.id
  default_action     = "Deny"
  ip_rules           = ["205.233.244.5", "205.233.246.4", "205.233.247.4", "50.223.46.210", "103.127.255.4"]
}


########### New Machine Learning Demand-forecast workspace deployment ##################

/*provider "azurerm" {
  features {}
}*/

locals {
  tags = {
    "Application Name"    = "Demand Forecasting"
    "Team Name"           = "Enterprise Analytics"
    "Cost Center"         = "94112"
    "IS Owner"            = "Syed Zee Hussain"
    "Business Unit Owner" = "Tony Ricchio"
    "Created By"          = "Cloud Product Team"
    "Environment"         = "tst"
    "Requested By"        = "Zee  Hussain"
    "Medline Tier"        = "Tier 2"
    "STAR"                = ""
    "POC Expiration"      = ""
    "PHI Data"            = "No"
  }

  firewall_rules = [{
    corp : {
      start_ip = "205.233.244.5"
      end_ip   = "205.233.244.5"
    },
    frp : {
      start_ip = "205.233.246.4"
      end_ip   = "205.233.246.4"
    },
    polk : {
      start_ip = "205.233.247.4"
      end_ip   = "205.233.247.4"
    },
    campus : {
      start_ip = "50.223.46.210"
      end_ip   = "50.223.46.210"
    },
    pune : {
      start_ip = "103.127.255.7"
      end_ip   = "103.127.255.7"
    }
  }]

}
resource "azurerm_resource_group" "tst-rg" {
  name     = "rg-tst-mlapps"
  location = "centralus"
  tags = {
    "Application Name"    = "Demand Forecasting"
    "Team Name"           = "Enterprise Analytics"
    "Cost Center"         = "94112"
    "IS Owner"            = "Syed Zee Hussain"
    "Business Unit Owner" = "Tony Ricchio"
    "Created By"          = "Cloud Product Team"
    "Environment"         = "tst"
    "Requested By"        = "Zee  Hussain"
    "Medline Tier"        = "Tier 2"
    "STAR"                = ""
    "POC Expiration"      = ""
    "PHI Data"            = "No"
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "mlapps" {
  name                = "law-usce-tst-workspace01"
  resource_group_name = "rg-tst-monitorservices"
}

# Updating ACR SKU
resource "azurerm_container_registry" "mlapps" {
	# checkov:skip=CKV_AZURE_139: Azure Container registries Public access to All networks is enabled - LOW
	# checkov:skip=CKV_AZURE_137: Azure ACR admin account is enabled - LOW
  name                = "mlapps"
  resource_group_name = azurerm_resource_group.tst-rg.name
  location            = azurerm_resource_group.tst-rg.location
  sku                 = "Premium"
  anonymous_pull_enabled = false
  admin_enabled       = true
  tags                = local.tags
  network_rule_set {
    default_action    = "Deny"
    ip_rule {
       action = "Allow"
       ip_range = "205.233.244.5/32"
    }
    ip_rule {
       action = "Allow"
       ip_range = "205.233.246.4/32"
    }
    ip_rule {
       action = "Allow"
       ip_range = "205.233.247.4/32"
    }
    ip_rule {
       action = "Allow"
       ip_range = "50.223.46.210/32"
    }
    ip_rule {
       action = "Allow"
       ip_range = "103.127.255.4/32"
    }
    ip_rule {
       action = "Allow"
       ip_range = "103.127.255.7/32"
    }
  }
}


module "key_vault_01" {
  source = "git::ssh://git@bitbucket.org/medlineis/terraform-modules.git//azure/resources/terraform-azure-keyvault"

  key_vault_name      = "vault-${var.environment}-mlapps01"
  resource_group_name = azurerm_resource_group.tst-rg.name
  environment         = var.environment
  location            = azurerm_resource_group.tst-rg.location
  sku                 = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  admin_sp_object_id  = [data.azurerm_client_config.current.object_id]

  keyvault_extra_tags = local.tags
}

module "diagnostic_settings_kv-demandfc" {
  source                     = "git::ssh://git@bitbucket.org/medlineis/terraform-modules.git//azure/resources/terraform-azure-diagnostic-setting"
  name                       = "diag-setting-keyvault"
  resource_id                = module.key_vault_01.key_vault_id
  retention_days             = 90
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.mlapps.id
}


module "storage_01" {
  source = "git::ssh://git@bitbucket.org/medlineis/terraform-modules.git//azure/resources/terraform-azure-storage"

  storage_name                 = "stor${var.medline_default_location}${var.environment}demandfc"
  azure_resource_group_name    = azurerm_resource_group.tst-rg.name
  blob_retention               = "7"
  container_retention          = "14"
  access_tier                  = "Hot"
  account_replication_type     = "LRS"
  network_rule_default_action  = "Deny"
  data_lake_enabled            = false
  CMK_enabled                  = true
  key_vault_name               = "vault-tst-mlapps01"
  kv_azure_resource_group_name = "rg-tst-mlapps"
  cmk_keyname                  = "CMK-${var.project-name}"
  environment                  = var.environment
  enable_static_website        = false
  extra_storage_tags           = local.tags
  network_rules                = local.firewall_rules
  ip_rules                     = ["205.233.244.5", "205.233.246.4", "205.233.247.4", "50.223.46.210", "103.127.255.4"]

  cors_rule = [{

    allowed_headers = [
      "*",
    ]
    allowed_methods = [
      "GET", "HEAD",
    ]
    allowed_origins = [
      "https://mlworkspace.azure.ai",
      "https://ml.azure.com",
      "https://*.ml.azure.com",
    ]
    exposed_headers = [
      "*",
    ]
    max_age_in_seconds = 1800
  }]

}

module "diagnostic_settings_storage-demandfc" {
  source             = "git::ssh://git@bitbucket.org/medlineis/terraform-modules.git//azure/resources/terraform-azure-diagnostic-setting"
  name               = "diag-setting-storage-containeraudit"
  resource_id        = "${module.storage_01.storage_account_id}/blobServices/default/"
  retention_days     = 90
  storage_account_id = module.storage_01.storage_account_id
}
resource "azurerm_application_insights" "mlapps" {
  name                = "appin-${var.medline_default_location}-${var.environment}-${var.project-team-name}-${var.project-name}"
  location            = azurerm_resource_group.tst-rg.location
  resource_group_name = azurerm_resource_group.tst-rg.name
  application_type    = "web"

  tags = local.tags
}

resource "azurerm_machine_learning_workspace" "mlapps" {
  # checkov:skip=CKV_AZURE_144: Azure Machine Learning Workspace is publicly accessible - LOW
  name                    = "ml-${var.medline_default_location}-${var.environment}-${var.project-team-name}-demand-fc"
  location                = azurerm_resource_group.tst-rg.location
  resource_group_name     = azurerm_resource_group.tst-rg.name
  application_insights_id = azurerm_application_insights.mlapps.id
  key_vault_id            = module.key_vault_01.key_vault_id
  storage_account_id      = module.storage_01.storage_account_id
  container_registry_id   = azurerm_container_registry.mlapps.id
  high_business_impact    = false
  tags                    = local.tags

  identity {
    type = "SystemAssigned"
  }
}
