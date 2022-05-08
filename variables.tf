#!/usr/bin/env file .

# ###
# ========================================================================
# --> Terraform Input Parameter(s)
# ========================================================================
# ###

/// The following input argument will create a local "~/." (dot)
/// directory in the given system's default (~) path expansion

variable "global" {
    description = "Global Configuration Directory"
    default     = ""
    type        = string

    /// The following validation(s), while seemingly excessive, are necessary in order to
    /// correctly debug where and which module the target error occurred in, as well as
    /// prevent all validation errors from occurring - limiting the stacktrace to simply
    /// one

    validation {
        condition = (var.global != "")
        error_message = "[Error] Variable (\"global\") cannot be nil (\"\")."
    }

    /// @Experimental

    /// Support for nested directories may be supported at a later time
    /// if it can be determined appropriate in production related
    /// environments and deployable(s)

    validation {
        condition     = (length(regexall("/", var.global)) == 0)
        error_message = "[Error] (Experimental) - Variable (\"global\") cannot contain forward-slash(es) (\"/\")."
    }

    validation {
        condition = (substr(var.global, -1, 0) != ".")
        error_message = "[Error] Variable (\"global\") cannot end with a period (\".\")."
    }

    validation {
        condition = (substr(var.global, 0, 1) != ".")
        error_message = "[Error] Variable (\"global\") assignment cannot start with a period (\".\")."
    }
}

/// While simplistic today, let us know think ahead
/// and provide an escape hatch

/// @Experimental

variable "force" {
    description = "(Escape-Hatch) Force a Clean-Slate Initialization"
    default = false
    type = bool
}

variable "archive" {
    description = "(Safety) Force a Configuration Archive"
    default = false
    type = bool
}

/* (auto-generation) $ npx @cloud-vault/tf-template --type variable */
