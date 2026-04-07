---
description: Sincronizar apenas historias de frontend com o Azure DevOps, protegendo work items marcados como [BACK].
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

Publish only frontend-owned user stories from the active `spec.md` into Azure DevOps as child work items of the existing parent Feature referenced by the specification.

## Execution Steps

1. Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly` and capture `FEATURE_SPEC`.
   - Stop if the active spec cannot be resolved.

2. Read the active spec and the `## Azure DevOps Traceability` section.
   - Resolve parent Feature URL, ID, organization, and project.
   - If the parent cannot be identified, stop and tell the user to update the spec traceability first.

3. Read `.specify/extensions/mrv-aidd-producao/mrv-aidd-producao-config.yml` when it exists and use it only as default values.

4. Parse all actionable user stories from the spec.
   - For each story, capture at least: spec key, title, `Como um`, `Eu quero`, `Para que`, `Link do Figma`, `Descricao`, `Valor para o Negocio`, acceptance scenarios, independent test, priority, ownership scope, and Azure DevOps tags.
   - Derive ownership from these rules, in order:
     1. `**Ownership Scope**`
     2. `**Azure DevOps Tags**`
   3. Story title prefix like `[FRONT]` or `[BACK]`
   4. Default to `frontend` when metadata is absent in this frontend repo

5. Build the sync candidate set.
   - Eligible stories: ownership `frontend`, tags containing `[FRONT]`, or titles starting with `[FRONT]`
   - Protected stories: ownership `backend`, tags containing `[BACK]`, or titles starting with `[BACK]`
   - Protected stories must be skipped and listed in the result summary.

6. Resolve the parent Feature and existing child items through Azure DevOps MCP tools.
   - Load the local sync map when it exists.
   - Prefer existing mapping entry, then existing child by title, then creation of a new child.

7. Before updating or linking any candidate story, inspect the target work item title and tags.
   - If the mapped or matched work item title starts with `[BACK]` or already contains `[BACK]` in tags, treat it as protected opposite scope.
   - Do not update, relink, or retag protected opposite-scope work items.
   - Report the story as `protected-scope-conflict`.

8. If any eligible frontend story is missing `Link do Figma`, collect it before writing.
   - Ask through `vscode_askQuestions`.
   - Do not sync frontend stories without Figma reference.

9. For each eligible frontend story:
   - Create or update the Azure DevOps child work item.
   - Ensure the effective Azure DevOps title starts with `[FRONT] `.
   - Build `System.Description` in an Azure DevOps user story format based on the reference work item:
     - First line in natural language: `Como um ... eu quero ... para que ...`
     - Figma link immediately after the narrative when available
     - `## Descricao`
     - `## Valor para o Negocio`
     - `## Teste Independente`
     - `## Prioridade`
   - Write acceptance scenarios to `Microsoft.VSTS.Common.AcceptanceCriteria`, preserving the `DADO/QUANDO/ENTAO` writing style.
   - Set `System.Tags` to the de-duplicated union of:
     - config default tags
     - story tags parsed from the spec
       - `[FRONT]`
    - Never remove a pre-existing `[FRONT]` tag.

10. Persist the local sync map for successfully synced frontend stories only.
   - Do not write the map during `--dry-run`.
   - Do not add protected or skipped backend stories to the mapping file for this frontend run.

11. Persist the Azure DevOps User Story IDs back into the active `spec.md` for successfully synced frontend stories only.
   - For each synced frontend story, write `**ID da US no Azure DevOps**: <workItemId>` inside the corresponding story block.
   - If the line already exists, update the value instead of duplicating it.
   - If the line is missing, insert it immediately below `**Azure DevOps Tags**`.
   - Preserve protected backend stories without modification.
   - Do not write the `spec.md` during `--dry-run`.

12. Report the result.
   - Include created, updated, reused, skipped-protected, and protected-scope-conflict stories.
   - Mention the mapping file path.
   - Mention that the Azure DevOps IDs were written back to the `spec.md` when applicable.
   - Recommend `/speckit.plan` after a successful sync.

13. Backend Handoff _(skip entirely if `--dry-run` is active)_.
   - Use `vscode_askQuestions` to ask: "Este projeto tem um repositório de backend?"
     - Options: **Sim** _(recommended)_ / **Não**
   - If **Não**: end the workflow silently.
   - If **Sim**:
     - Use the Feature name, URL, ID, organization, and project already resolved in step 2.
     - Read the `## Backend Follow-up` section from the active `spec.md`.
     - If `## Backend Follow-up` is absent or its content is empty, replace it in the generated prompt with:
       ```
       > Nenhum Backend Follow-up foi registrado na spec do frontend.
       > Execute /speckit.clarify logo após o /speckit.specify para mapear
       > dependências e contratos com o frontend antes de prosseguir para o plan.
       ```
     - Build and display the following copyable code block:

       ````text
       /speckit.specify Feature: [NOME_FEATURE] ([URL_FEATURE])

       ## Contexto derivado do Frontend
       **Feature pai no Azure DevOps**
       - ID: [FEATURE_ID]
       - URL: [FEATURE_URL]
       - Organização: [ORG]
       - Projeto: [PROJETO]

       ## Backend Follow-up (extraído do spec.md do frontend)
       [CONTEÚDO DO ## Backend Follow-up — ou aviso de ausência conforme regra acima]

       > Preserve a rastreabilidade com o mesmo ID/URL de Feature pai.
       > Use o preset mrv-aidd-producao-backend.
       ````

     - After displaying the block, tell the user to open the backend repository and paste the prompt into the agent chat.

## Behavior Rules

- This command synchronizes only frontend-owned stories.
- Stories tagged `[BACK]` or titled com `[BACK]` must never be modified by this preset.
- If a story is untagged in the spec, default it to frontend ownership instead of leaving ownership ambiguous.
- In dry-run mode, do not perform Azure DevOps writes and do not update the local mapping file.
- In dry-run mode, suppress step 13 (Backend Handoff) entirely — do not ask the backend question and do not generate the handoff prompt.
