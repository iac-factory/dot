#!/usr/bin/env file .

# ###
# ========================================================================
# --> Terraform Local Runtime Assignment
# ========================================================================
# ###

locals {
    symbol                = "~"
    file-name             = "LOCK"
    archive-target        = ".global.zip"
    archive-backup-target = ".archive.global.zip"

    permission = {
        file      = "0664" /* ( rw-rw-r-- ) */
        directory = "0775" /* ( rwxrwxr-x ) */
    }

    expansion = pathexpand(local.symbol)

    /// The "global" dot-directory name

    dot = join(".", [ "", var.global ])

    /// @Experimental - LOCK contents are subject to change

    /// @todo - Update inline documentation

    content = trim(templatefile(abspath(join("/", [ path.module, "VERSION" ])), {}), "\n")

    /// On both Windows + Linux/Unix systems, Terraform enforces "/" directory-related
    /// usage only. The following string constructor can be safely assumed to represent
    /// system-agnostic, appropriate pathing

    target = join("/", [ local.expansion, local.dot ])

    /// @Experimental

    /// @todo - Update inline documentation
    /// @todo - Create optional variable

    exclusions = [ ]

    /// Terraform doesn't provide means for determining if a given directory exists; however,
    /// via `fileexists`, a simple boolean can be determined if the configuration folder for
    /// "global" exists, if, and only if, an arbitrary file (LOCK) can be found

    /// All assumptions of state, therefore, are contingent on ~/.[global]/LOCK

    /// Lastly, the LOCK file becomes the most simplistic, deterministic means of creating the
    /// the dot-directory

    lock = join("/", [ local.target, local.file-name ])

    /// Deterministic initialization of the Global configuration module

    initialize = !fileexists(local.lock)
}

/* (auto-generation) $ npx @cloud-vault/tf-template --type local */
