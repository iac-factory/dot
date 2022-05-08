#!/usr/bin/env file .

# ###
# ========================================================================
# --> Terraform Resource(s)
# ========================================================================
# ###

# ###
# Local-File Provider
# ###

///
/// Argument Reference - https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
///
/// filename - (Required) The path to the file that will be created. Missing parent directories will be created. If the
///     file already exists, it will be overridden with the given content.
/// content - (Optional) Content to store in the file, expected to be an UTF-8 encoded string. Conflicts with
///     sensitive_content, content_base64 and source.
/// sensitive_content - (Optional - Deprecated) Sensitive content to store in the file, expected to be an UTF-8 encoded
///     string. Will not be displayed in diffs. Conflicts with content, content_base64 and source. If in need to use
////    sensitive content, please use the local_sensitive_file resource instead.
/// content_base64 - (Optional) Content to store in the file, expected to be binary encoded as base64 string. Conflicts
///     with content, sensitive_content and source.
/// source - (Optional) Path to file to use as source for the one we are creating. Conflicts with content,
///     sensitive_content and content_base64.
/// file_permission - (Optional) Permissions to set for the output file, expressed as string in numeric notation. Default
///     value is "0777".
/// directory_permission - (Optional) Permissions to set for directories created, expressed as string in numeric
///     notation. Default value is "0777".
///

resource "local_file" "lock" {
    filename = local.lock /* Constant := LOCK */

    depends_on = [null_resource.escape-hatch]

    directory_permission = local.permission.directory
    file_permission = local.permission.file

    /// @Experimental
    content = local.content

    lifecycle {
        /// It's an undesirable side-effect for
        /// state to change according to the full-system
        /// path location of the lockfile -- therefore
        /// it's ignored

        ignore_changes = [
            id, filename
        ]
    }
}

/// @Experimental - Escape Hatch

/// Warning -- This can be incredibly destructive to a
/// system's already established dot-directory

resource "null_resource" "escape-hatch" {
    triggers = { force = (var.force == true) ? sha1(uuid()) : false }

    /// Regardless of first time setup, the following command is
    /// triggered - therefore, the command itself needs to be validated
    /// against user-input (false is technically a trigger given
    /// the terraform state hash gets calculated as key-value
    /// variable assignment [in the context of null_resource.triggers])

    provisioner "local-exec" {
        command = (var.force == true) ? "rm -rf ${local.target}" : "true"
    }
}
