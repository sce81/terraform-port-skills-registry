variable "skills_registry_owner" {
  description = "GitHub organization or user that owns the source skills registry"
  type        = string
}

variable "skills_registry_repository" {
  description = "GitHub repository containing Markdown skill files"
  type        = string
}

variable "skills_registry_branch" {
  description = "Registry branch to synchronize"
  type        = string
}

variable "skills_registry_path" {
  description = "Directory under which Markdown skill files are discovered; empty searches the whole repository"
  type        = string
}

variable "skills_registry_token" {
  description = "Fine-grained GitHub token with read-only Contents access to the skills registry"
  type        = string
  sensitive   = true
}

variable "default_skill_location" {
  description = "Port skill installation scope when the source front matter omits location"
  type        = string

  validation {
    condition     = contains(["global", "project"], var.default_skill_location)
    error_message = "default_skill_location must be global or project."
  }
}

variable "sync_workflow_roles" {
  description = "Port roles allowed to trigger the skills registry sync"
  type        = list(string)
}

variable "github_ocean_installation_id" {
  description = "Installed GitHub Ocean integration identifier used by the Port workflow"
  type        = string
}

variable "github_sync_owner" {
  description = "GitHub organization or user that owns the repository containing the sync workflow"
  type        = string
}

variable "github_sync_repository" {
  description = "GitHub repository containing the root-module sync workflow"
  type        = string
}

variable "github_sync_workflow" {
  description = "GitHub Actions workflow filename dispatched by Port"
  type        = string
}
