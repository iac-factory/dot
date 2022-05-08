#!/usr/bin/env file .

# ###
# ========================================================================
# --> Terraform Provider(s) & General Configuration
# ========================================================================
# ###

terraform {
    experiments = []

    required_providers {
        local = "~> 2"
    }
}

provider "null" {}
provider "local" {}
provider "archive" {}

/* (auto-generation) $ npx @cloud-vault/tf-template --type provider */
