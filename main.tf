resource "port_blueprint" "skill" {
  identifier  = "skill"
  title       = "Skill"
  icon        = "Learn"
  description = "Reusable instructions synchronized from the GitHub Skills Registry."

  properties = {
    string_props = {
      description = {
        title       = "Description"
        description = "What the skill does and when to use it"
        required    = true
      }
      instructions = {
        title       = "Instructions"
        description = "Instructions from the source Markdown file"
        format      = "markdown"
        required    = true
      }
      location = {
        title       = "Location"
        description = "Target installation scope"
        enum        = ["global", "project"]
        required    = true
      }
      source_folder = {
        title       = "Source Folder"
        description = "Folder containing the source Markdown skill"
        required    = true
      }
    }
    array_props = {
      references = {
        title        = "References"
        description  = "Source registry location for this skill"
        object_items = {}
      }
      assets = {
        title        = "Assets"
        description  = "Reserved for skill assets"
        object_items = {}
      }
    }
  }
}

resource "port_entity" "skill" {
  for_each = local.skill_documents

  blueprint = port_blueprint.skill.identifier
  identifier = try(
    each.value.front_matter.name,
    lower(replace(basename(each.key), ".md", "")),
  )
  title = format(
    "[%s] %s",
    each.value.source_folder,
    try(
      each.value.front_matter.title,
      trimspace(try(regexall("(?m)^#\\s+(.+)$", each.value.instructions)[0][0], replace(title(replace(basename(each.key), ".md", "")), "_", " "))),
    ),
  )

  properties = {
    string_props = {
      description = try(
        each.value.front_matter.description,
        trimspace(try(regexall("(?m)^#\\s+(.+)$", each.value.instructions)[0][0], "Instructions synchronized from ${each.key}.")),
      )
      instructions = each.value.instructions
      location     = try(each.value.front_matter.location, var.default_skill_location)
      source_folder = each.value.source_folder
    }
    array_props = {
      object_items = {
        references = [jsonencode({
          path        = each.key
          content     = each.value.instructions
          description = each.value.source_url
        })]
        assets = []
      }
    }
  }
}

resource "port_workflow" "sync_skills_registry" {
  identifier                = "sync_port_skills_registry"
  title                     = "Sync Port Skills Registry"
  description               = "Synchronizes Markdown skill files from GitHub to the Port Skill Registry through Terraform."
  icon                      = "Github"
  category                  = "OSS Terraform"
  allow_anyone_to_view_runs = true

  node {
    identifier = "trigger"
    title      = "Sync Port Skills"

    self_serve_trigger {
      published                  = true
      action_card_button_text    = "Sync Skills"
      execute_action_button_text = "Sync"

      permissions {
        roles = var.sync_workflow_roles
      }
    }
  }

  node {
    identifier  = "run_terraform_sync"
    title       = "Run Terraform sync"
    icon        = "Github"
    description = "Dispatches the GitHub Actions job that applies the Port Skills registry configuration."

    integration_action {
      installation_id             = var.github_ocean_installation_id
      integration_provider        = "github-ocean"
      integration_invocation_type = "dispatch_workflow"
      on_failure                  = "terminate"
      execution_properties = jsonencode({
        org                  = var.github_sync_owner
        repo                 = var.github_sync_repository
        workflow             = var.github_sync_workflow
        reportWorkflowStatus = true
        workflowInputs = {
          environment               = "Development"
          port_workflow_node_run_id = "{{ .workflowNodeRun.identifier }}"
        }
      })
    }
  }

  connections {
    source_identifier = "trigger"
    target_identifier = "run_terraform_sync"
  }
}
