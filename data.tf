#!/usr/bin/env file .

# ###
# ========================================================================
# --> Terraform Data Reference
# ========================================================================
# ###

# ###
# Archive-File Provider
# ###

///
/// Argument Reference - https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file
///
/// Note - One of source, source_content_filename (with source_content), source_file, or source_dir must be specified.
///
/// type - (Required) The type of archive to generate. NOTE: zip is supported.
/// output_path - (Required) The output of the archive file.
/// output_file_mode (Optional) String that specifies the octal file mode for all archived files. For example: "0666".
///     Setting this will ensure that cross platform usage of this module will not vary the modes of archived files (and
///     ultimately checksums) resulting in more deterministic behavior.
/// source_content - (Optional) Add only this content to the archive with source_content_filename as the filename.
/// source_content_filename - (Optional) Set this as the filename when using source_content.
/// source_file - (Optional) Package this file into the archive.
/// source_dir - (Optional) Package entire contents of this directory into the archive.
/// source - (Optional) Specifies attributes of a single source file to include into the archive.
/// excludes - (Optional) Specify files to ignore when reading the source_dir.
//
/// The source block supports the following:
/// content - (Required) Add this content to the archive with filename as the filename.
/// filename - (Required) Set this as the filename when declaring a source.
///

locals { pwd = path.cwd /* ${PWD} - Process-Working-Directory */ }

data "archive_file" "dot-files" {
    depends_on = [null_resource.escape-hatch]

    /// @Experimental - the data representation of the configuration
    /// global dot-directory may *always* be required ... testing
    /// is in-progress ...

    /// count = /* (var.global) ? 0 : 1 */ (local.initialize) ? 1 : 1

    type = "zip"

    source_dir       = join("/", [ local.target ])
    output_path      = join("/", [ local.target, local.archive-target ])
    output_file_mode = local.permission.file

    /// @Experimental
    excludes = local.exclusions
}

/// The archive_file.dot-files resource is used for output hash calculation
/// and therefore is used to determine state of the global configuration
/// directory; whereas the following resource is simply a copy for the user
/// or system where the output path is set to the current-working directory

/// A .global.zip file be created if it doesn't exist in the user's current
/// working directory while not affecting the current state of the construct

data "archive_file" "artifact" {
    type = "zip"

    source_dir       = join("/", [ local.target ])
    output_path      = join("/", [ local.pwd, local.archive-target ])
    output_file_mode = local.permission.file

    /// @Experimental
    excludes = can(local.exclusions[*]) ? [data.archive_file.dot-files.output_path, local.exclusions[*]] : [data.archive_file.dot-files.output_path]

    depends_on = [local_file.lock]
}

/* (auto-generation) $ npx @cloud-vault/tf-template --type data */
