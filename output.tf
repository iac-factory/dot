#!/usr/bin/env file .

# ###
# ========================================================================
# --> Terraform Output Assignment
# ========================================================================
# ###

/// Note - "global" output is intentionally not expanded. Doing so would
/// otherwise cause drift between local and remote systems given that
/// default directories ("~") have significant variance across operating
/// systems

output "global" {
    description = "Global Configuration Directory (Name-Only)"
    sensitive = false
    value = var.global
}

output "file-system-permissions" {
    description = "Directory + File Default File-System Permissions"
    sensitive = false
    value = local.permission
}

output "directory-file-system-permissions" {
    description = "Default File-System Directory Permissions"
    sensitive = false
    value = local.permission.directory
}

output "descriptor-file-system-permissions" {
    description = "Default File-System File Permissions"
    sensitive = false
    value = local.permission.file
}

/// The beauty of the package -- globally deterministic configuration directory
/// regardless of remote or local workstation setups; the greatest benefit
/// here is that the variable deprivation comes from the terraform team themselves

output "hash" {
    description = "Global Configuration Directory SHA-Hash"
    sensitive = false
    value = data.archive_file.dot-files.output_base64sha256
}

output "hash-archive" {
    description = "Global Configuration Directory SHA-Hash"
    sensitive = false
    value = data.archive_file.artifact.output_base64sha256
}

/* (auto-generation) $ npx @cloud-vault/tf-template --type output */
