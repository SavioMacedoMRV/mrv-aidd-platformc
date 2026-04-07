---
description: "Sync clarified user stories from the active spec to Azure DevOps under the parent Feature stored in the spec"
tools: [read, edit, execute, vscode, "microsoft/azure-devops-mcp/wit_get_work_item", "microsoft/azure-devops-mcp/wit_create_work_item", "microsoft/azure-devops-mcp/wit_update_work_item", "microsoft/azure-devops-mcp/wit_get_work_items_batch_by_ids", "microsoft/azure-devops-mcp/wit_add_child_work_items", "microsoft/azure-devops-mcp/wit_add_artifact_link", "microsoft/azure-devops-mcp/wit_work_items_link", "microsoft/azure-devops-mcp/wit_add_work_item_comment", "microsoft/azure-devops-mcp/wit_list_backlog_work_items", "microsoft/azure-devops-mcp/search_workitem", "microsoft/azure-devops-mcp/core_list_projects", "microsoft/azure-devops-mcp/core_get_identity_ids", "microsoft/azure-devops-mcp/work_list_iterations", "microsoft/azure-devops-mcp/work_get_team_settings"]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** use Azure DevOps MCP tools for every Azure DevOps read or write in this workflow. Do **NOT** use Azure CLI, PATs, raw REST calls, browser automation, or shell scripts to create or update Azure DevOps work items.

If MCP access fails, authentication is missing, or the Azure DevOps MCP server is not configured, stop immediately and tell the user to authenticate and configure the Azure DevOps MCP integration before retrying.

If `$ARGUMENTS` contains `--dry-run` or `dry-run`, execute the full validation and reconciliation workflow but do **NOT** create, update, or link any Azure DevOps work items and do **NOT** persist the sync map. Report the actions that would have been taken.

## MCP Prerequisites

Before proceeding, verify that the **Azure DevOps MCP** server is active:
- Call `microsoft/azure-devops-mcp/core_list_projects` to confirm the server is reachable.
- If the call fails or the tool is unavailable, **stop immediately** and tell the user to enable the `microsoft/azure-devops-mcp` server in VS Code before retrying.

## Goal

Publish the clarified user stories from the active `spec.md` into Azure DevOps as child work items of the existing parent Feature referenced by the specification.

## Execution Steps

1. Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly` from the repository root and parse the JSON payload. Capture at least:
   - `FEATURE_DIR`
   - `FEATURE_SPEC`
   - If the script fails or `FEATURE_SPEC` is missing, stop and tell the user to run `/speckit.specify` first.

2. Read the active specification file and locate the `## Azure DevOps Traceability` section.
   - Extract, when present:
     - Parent Feature URL
     - Parent Feature ID
     - Organization
     - Project
   - If the user supplied a URL or work item reference in `$ARGUMENTS`, treat it as an explicit override.
    - Parse overrides deterministically. Accept only these override shapes:
       - Full Azure DevOps Feature URL
       - Numeric work item ID together with an explicit project name
       - Explicit `organization=<value>` and `project=<value>` pairs
    - If both the spec and `$ARGUMENTS` provide a parent reference and they disagree, stop and ask the user which parent Feature should win before any write.
    - If the Feature URL is present, derive organization, project, and work item ID from it whenever possible instead of relying on free-form text.
   - If neither the spec nor `$ARGUMENTS` provides enough information to identify the parent Feature and project, stop and tell the user to update the spec with the Azure DevOps Feature link by rerunning `/speckit.specify` or by editing the traceability section.

3. Read `.specify/extensions/mrv-aidd-producao/mrv-aidd-producao-config.yml` if it exists.
   - Use these values only as defaults.
   - Prefer values explicitly present in the spec traceability section.
   - If config and spec disagree on `project`, `area_path`, `iteration_path`, or work item types, prefer the spec or explicit override and report that config defaults were ignored for this run.

4. Ensure Azure DevOps project and work item MCP tools are available.
   - If they are not active yet, activate the Azure DevOps project-management and work-item tool groups before continuing.

5. Resolve and validate the parent Feature.
   - Use `mcp_microsoft_azu_wit_get_work_item` to fetch the parent Feature by ID and project.
   - Request relations when useful so you can inspect existing child items.
   - Verify that the resolved work item is a Feature, or matches the configured parent type when the extension config defines an allowed alternative.
   - If the lookup fails because of authentication, permissions, missing project, or missing work item, stop with a precise error message and do not attempt any write.

6. Parse the user stories from `spec.md`.
   - Collect each `### User Story N - Title (Priority: Px)` block.
   - For each story capture:
     - Stable spec key, such as `US1`
     - Story title
     - Narrative body
     - Priority label from the spec
     - Acceptance scenarios
     - Independent test description
   - Ignore empty placeholder stories and placeholder text.
   - If stable keys are missing, duplicated, or reordered ambiguously, stop and ask the user to normalize the spec before syncing.
   - If two actionable stories resolve to the same normalized title, stop and ask the user to disambiguate them before syncing.
   - If no actionable user stories are found, stop and tell the user to complete `/speckit.clarify` before syncing.

7. Load the existing sync map from `.specify/extensions/mrv-aidd-producao/us-sync-map.json` when it exists.
   - Use it as the first source of truth for already-synced stories.
   - Treat the file as valid only if each entry contains at least `project`, `parentFeatureId`, `specKey`, and `workItemId`.
   - If the file is malformed, missing required fields, or points to a different parent Feature than the current run, report the issue and continue only after you can safely rebuild the mapping from Azure DevOps child relations.

8. Build a de-duplication index before creating anything new.
   - Inspect the parent Feature relations to identify existing child work items.
   - Fetch child work item details as needed and index them by title.
   - Prefer this resolution order for each story:
     1. Existing mapping entry in `us-sync-map.json`
     2. Existing child work item under the parent Feature with the same title
     3. Create a new child work item
   - If a mapping entry points to a work item that no longer exists, treat it as stale, log it in the summary, and fall back to relation/title matching.
   - If title matching finds multiple candidate child work items, stop and ask the user to resolve the ambiguity before any write.

9. For each user story, sync it with Azure DevOps.
   - When an existing work item is found:
     - Update `System.Title` if needed.
     - Update `System.Description` with a concise Markdown summary built from the story narrative, acceptance scenarios, independent test, and priority.
     - Preserve manual board fields that are not explicitly owned by this workflow.
   - When no existing work item is found:
     - Create a work item using `mcp_microsoft_azu_wit_create_work_item`.
     - Default work item type comes from config field `story_work_item_type`, falling back to `User Story`.
     - Set at minimum:
       - `System.Title`
       - `System.Description` in Markdown
       - `System.AreaPath` when configured
       - `System.IterationPath` when configured
       - `System.Tags` when configured
     - Immediately link it to the parent Feature using `mcp_microsoft_azu_wit_work_items_link` with a parent-child relationship.
    - Build descriptions in a stable format with these sections only:
       - `## Narrative`
       - `## Acceptance Scenarios`
       - `## Independent Test`
       - `## Priority`
    - Normalize whitespace and remove placeholder text before writing.
    - In `--dry-run` mode, replace every create, update, and link action with a would-create, would-update, or would-link summary entry.
    - If a write fails for one story after earlier stories succeeded, stop further writes, report partial progress clearly, and persist only the successfully confirmed mapping entries for the current run.

10. Persist the sync map back to `.specify/extensions/mrv-aidd-producao/us-sync-map.json`.
    - Store:
      - Parent Feature ID and project
      - Story spec key
      - Story title
      - Azure DevOps work item ID
      - Azure DevOps URL when available
      - Last sync timestamp
    - Update existing entries instead of duplicating them.
   - Do not persist the file during `--dry-run`.
   - Remove stale duplicate entries for the same `project + parentFeatureId + specKey` tuple before saving.

   11. Atualize o `spec.md` com os IDs das USs no Azure DevOps.
      - Para cada historia sincronizada com sucesso, registre no bloco da historia a linha `**ID da US no Azure DevOps**: <workItemId>`.
      - Se a linha ja existir, atualize o valor em vez de duplicar.
      - Se a linha ainda nao existir, insira-a logo abaixo de `**Azure DevOps Tags**`.
      - Preserve o restante do texto do `spec.md` sem reformatar blocos nao relacionados.
      - Nao atualize o `spec.md` durante `--dry-run`.

   12. Report a concise result summary.
    - Include parent Feature reference.
    - List created, updated, reused, and skipped stories.
   - When applicable, include would-create, would-update, would-link, stale-map, and conflict items.
    - Mention the mapping file path.
      - Mention that the Azure DevOps IDs were written back to the `spec.md` when applicable.
    - Suggest `/speckit.plan` as the next command after a successful sync.

## Behavior Rules

- Azure DevOps writes MUST happen only through MCP tools.
- Do not create tasks in this command. This command syncs only user stories.
- Do not create a new parent Feature here. The parent Feature must already exist.
- If the spec traceability context points to a different project or parent than the user's override, ask for confirmation before writing.
- If authentication or permissions are insufficient, fail fast with the exact prerequisite to fix.
- Keep the sync idempotent by preferring the mapping file and existing child work items before creating anything.
- In `--dry-run` mode, perform zero Azure DevOps writes and zero local mapping writes.
