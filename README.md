# Port Skills Registry Child Module

Manages Port's shared `skill` blueprint, skill entities synchronized from a GitHub
Markdown registry, and the Port workflow that dispatches the remote Terraform sync.

This is a child module. It declares provider requirements in `terraform.tf` but does
not configure providers or a Terraform backend; those belong to the calling root
module.

## Inputs

Pass your own registry repository configuration through the root module:

- `skills_registry_owner` and `skills_registry_repository` are required. They identify
  the GitHub repository containing the Markdown skills to synchronize.
- `skills_registry_branch` selects the source branch.
- `skills_registry_path` scopes recursive Markdown discovery. Every discovered file
  becomes a Port skill entity.
- `skills_registry_token` is required only when that source repository is private. It
  needs read-only Contents access to the source repository.
- `default_skill_location` selects `global` or `project` when source front matter does
  not set `location`.
- `sync_workflow_roles`, `github_ocean_installation_id`, `github_sync_owner`,
  `github_sync_repository`, and `github_sync_workflow` configure the Port workflow
  that dispatches `sync-port-skills.yml`.

The module source is public; it does not need a GitHub token to download. A token is
only used for reading a private skills repository.

## State migration

When adopting this module from the root-module implementation, the root must include
temporary `moved` blocks for the blueprint, all skill entities, and the Port workflow
before applying the new child-module version.
