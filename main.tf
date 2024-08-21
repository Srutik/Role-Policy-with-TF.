terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_role_definition" "custom_role" {
  name        = "CustomRole"
  description = "Custom role with limited permissions"
  scope       = "/subscriptions/${var.subscription_id}"

  permissions {
    actions     = ["Microsoft.Storage/storageAccounts/read"]
    actions     = ["Microsoft.Storage/storageAccounts/write"]
    not_actions = []
  }

  assignable_scopes = ["/subscriptions/${var.subscription_id}"]
}

resource "azurerm_policy_definition" "custom_policy" {
  name         = "CustomPolicy3"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Custom Policy"

  policy_rule = <<POLICY
  {
    "if": {
      "field": "location",
      "notIn": ["eastus", "westus"]
    },
    "then": {
      "effect": "deny"
    }
  }
  POLICY
}

resource "azurerm_subscription_policy_assignment" "custom_policy_assignment" {
  name                 = "customPolicyAssignment3"
    policy_definition_id = azurerm_policy_definition.custom_policy.id
  subscription_id                = "/subscriptions/${var.subscription_id}"
}


resource "azurerm_role_assignment" "custom_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = azurerm_role_definition.custom_role.name
  principal_id         = var.principal_id
}
