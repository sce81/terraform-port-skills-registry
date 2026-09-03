# Port Skills Registry Child Module

Manages Port's shared `skill` blueprint, skill entities synchronized from a GitHub
Markdown registry, and the Port workflow that dispatches the remote Terraform sync.

This is a child module. It declares provider requirements in `terraform.tf` but does
not configure providers or a Terraform backend; those belong to the calling root
module.

## Inputs

Pass the registry repository, branch, path, and read-only token through the root
module. `skills_registry_path` scopes recursive Markdown discovery. Every discovered
file becomes a Port skill entity.

The module also needs the GitHub Ocean installation and the root repository details
used to dispatch the `sync-port-skills.yml` workflow.

## State migration

When adopting this module from the root-module implementation, the root must include
temporary `moved` blocks for the blueprint, all skill entities, and the Port workflow
before applying the new child-module version.
