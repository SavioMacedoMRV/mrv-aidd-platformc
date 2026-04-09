---
description: Sincronizar apenas historias de backend com o Azure DevOps, protegendo work items marcados como [FRONT].
tools: [read, edit, execute, vscode, "microsoft/azure-devops-mcp/wit_get_work_item", "microsoft/azure-devops-mcp/wit_create_work_item", "microsoft/azure-devops-mcp/wit_update_work_item", "microsoft/azure-devops-mcp/wit_get_work_items_batch_by_ids", "microsoft/azure-devops-mcp/wit_add_child_work_items", "microsoft/azure-devops-mcp/wit_add_artifact_link", "microsoft/azure-devops-mcp/wit_work_items_link", "microsoft/azure-devops-mcp/wit_add_work_item_comment", "microsoft/azure-devops-mcp/wit_list_backlog_work_items", "microsoft/azure-devops-mcp/search_workitem", "microsoft/azure-devops-mcp/core_list_projects", "microsoft/azure-devops-mcp/core_get_identity_ids", "microsoft/azure-devops-mcp/work_list_iterations", "microsoft/azure-devops-mcp/work_get_team_settings"]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** use Azure DevOps MCP tools for every Azure DevOps read or write in this workflow. Do **NOT** use Azure CLI, PATs, raw REST calls, browser automation, or shell scripts.

If `$ARGUMENTS` contains `--dry-run` or `dry-run`, execute the full reconciliation workflow but do not persist local or remote writes.

## MCP Prerequisites

Before proceeding, verify that the **Azure DevOps MCP** server is active:

- Call `microsoft/azure-devops-mcp/core_list_projects` to confirm the server is reachable.
- If the call fails or the tool is unavailable, **stop immediately** and tell the user to enable the `microsoft/azure-devops-mcp` server in VS Code before retrying.

## Question Rules

Whenever user confirmation, disambiguation, or missing data is needed, you **MUST** use the `vscode_askQuestions` tool.
Do **NOT** ask plain-text conversational questions.

## Goal

Publish the feature and its backend-owned user stories from the active `spec.md` into Azure DevOps. Create or resolve the Feature work item as child of the parent Epic, then create or update backend User Stories as children of that Feature.

## Execution Steps

1. Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly` and capture `FEATURE_SPEC`.
   - Stop if the active spec cannot be resolved.

2. Read the active spec and the `## Azure DevOps Traceability` section.
   - Resolve parent Epic URL, ID, organization, and project.
   - If the traceability section also contains a Feature ID, note it for reuse in step 6.
   - If the parent Epic cannot be identified, stop and tell the user to update the spec traceability with the Epic link first.

3. Read `.specify/extensions/mrv-aidd-producao/mrv-aidd-producao-config.yml` when it exists and use it only as default values.

4. Parse all actionable user stories from the spec.
   - For each story, capture at least: spec key, title, `Como um`, `Eu quero`, `Para que`, `Descricao`, `Valor para o Negocio`, acceptance scenarios, independent test, priority, ownership scope, and Azure DevOps tags.
   - Derive ownership from these rules, in order:
     1. `**Ownership Scope**`
     2. `**Azure DevOps Tags**`
   1. Story title prefix like `[BACK]` or `[FRONT]`
   2. Default to `backend` when metadata is absent in this backend repo

5. Build the sync candidate set.
   - Eligible stories: ownership `backend`, tags containing `[BACK]`, or titles starting with `[BACK]`
   - Protected stories: ownership `frontend`, tags containing `[FRONT]`, or titles starting with `[FRONT]`
   - Protected stories must be skipped and listed in the result summary.

6. Create or resolve the Feature work item under the parent Epic.
   - If `## Azure DevOps Traceability` already contains a Feature ID, fetch and validate it as a child of the Epic. Reuse it.
   - If no Feature ID exists:
     - Create a new Feature work item using the spec title as `System.Title`.
     - Build `System.Description` from the feature summary in the spec.
     - Set `System.AreaPath`, `System.IterationPath`, and `System.Tags` from config when available.
     - Link it as child of the parent Epic.
   - Persist the Feature URL and ID back to `## Azure DevOps Traceability` in `spec.md`.
   - In `--dry-run` mode, report the Feature that would be created but do not write.
   - Then resolve existing child User Stories under the Feature.
   - Load the local sync map when it exists.
   - Prefer existing mapping entry, then existing child by title, then creation of a new child.

7. Before updating or linking any candidate story, inspect the target work item title and tags.
   - If the mapped or matched work item title starts with `[FRONT]` or already contains `[FRONT]` in tags, treat it as protected opposite scope.
   - Do not update, relink, or retag protected opposite-scope work items.
   - Report the story as `protected-scope-conflict`.

8. For each eligible backend story:
   - Create or update the Azure DevOps child work item.
   - Ensure the effective Azure DevOps title starts with `[BACK]`.
    - Build `System.Description` in an Azure DevOps user story format based on the reference work item:
       - First line in natural language: `Como um ... eu quero ... para que ...`
       - `## Descricao`
       - `## Valor para o Negocio`
       - `## Teste Independente`
       - `## Prioridade`
    - Write acceptance scenarios to `Microsoft.VSTS.Common.AcceptanceCriteria`, preserving the `DADO/QUANDO/ENTAO` writing style.
   - Set `System.Tags` to the de-duplicated union of:
     - config default tags
     - story tags parsed from the spec
       - `[BACK]`
    - Never remove a pre-existing `[BACK]` tag.

9. Persist the local sync map for successfully synced backend stories only.
   - Do not write the map during `--dry-run`.
   - Do not add protected or skipped frontend stories to the mapping file for this backend run.

10. Persist the Azure DevOps User Story IDs back into the active `spec.md` for successfully synced backend stories only.

- For each synced backend story, write `**ID da US no Azure DevOps**: <workItemId>` inside the corresponding story block.
- If the line already exists, update the value instead of duplicating it.
- If the line is missing, insert it immediately below `**Azure DevOps Tags**`.
- Preserve protected frontend stories without modification.
- Do not write the `spec.md` during `--dry-run`.

1. Report the result.

- Include created, updated, reused, skipped-protected, and protected-scope-conflict stories.
- Mention the mapping file path.
- Mention that the Azure DevOps IDs were written back to the `spec.md` when applicable.
- Recommend `/speckit.plan` after a successful sync.

## Behavior Rules

- This command synchronizes the Feature and its backend-owned stories.
- The Feature is created as child of the Epic when it does not exist yet. If it already exists, reuse it.
- Stories tagged `[FRONT]` or titled with `[FRONT]` must never be modified by this preset.
- If a story is untagged in the spec, default it to backend ownership instead of leaving ownership ambiguous.
- In dry-run mode, do not perform Azure DevOps writes and do not update the local mapping file.
