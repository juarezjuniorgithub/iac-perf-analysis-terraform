locals {
  spring_cloud_service_name = "asc-${var.application_name}-${var.environment}"
  spring_cloud_app_name     = "app-${var.application_name}"
}

resource "azurerm_spring_cloud_service" "application" {
  name                = local.spring_cloud_service_name
  resource_group_name = var.resource_group
  location            = var.location
  sku_name            = "B0"

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
  trace {
    connection_string = var.azure_application_insights_connection_string
  }
}

resource "azurerm_spring_cloud_app" "application" {
  name                = local.spring_cloud_app_name
  resource_group_name = var.resource_group
  service_name        = azurerm_spring_cloud_service.application.name
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_spring_cloud_java_deployment" "application_deployment" {
  name                = "default"
  spring_cloud_app_id = azurerm_spring_cloud_app.application.id
  instance_count      = 1
  runtime_version     = "Java_17"

  quota {
    cpu    = "1"
    memory = "1Gi"
  }

  environment_variables = {
    "SPRING_PROFILES_ACTIVE" = "prod,azure"

    "SPRING_DATASOURCE_URL"      = "jdbc:mysql://${var.database_url}?useUnicode=true&characterEncoding=utf8&useSSL=true&useLegacyDatetimeCode=false&serverTimezone=UTC"
    "SPRING_DATASOURCE_USERNAME" = var.database_username
    "SPRING_DATASOURCE_PASSWORD" = var.database_password

    "AZURE_STORAGE_ACCOUNT_NAME"  = var.azure_storage_account_name
    "AZURE_STORAGE_ACCOUNT_KEY"   = var.azure_storage_account_key
    "AZURE_STORAGE_BLOB_ENDPOINT" = var.azure_storage_blob_endpoint
  }
}
