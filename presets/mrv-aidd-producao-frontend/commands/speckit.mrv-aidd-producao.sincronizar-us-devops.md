---
description: Sincronizar apenas historias de frontend com o Azure DevOps, protegendo work items marcados como [BACK].
---

## User Input

```text
$ARGUMENTS
```

You **MUST** use Azure DevOps MCP tools for every Azure DevOps read or write in this workflow. Do **NOT** use Azure CLI, PATs, raw REST calls, browser automation, or shell scripts.

If `$ARGUMENTS` contains `--dry-run` or `dry-run`, execute the full reconciliation workflow but do not persist local or remote writes.

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

## Behavior Rules

- This command synchronizes only frontend-owned stories.
- Stories tagged `[BACK]` or titled com `[BACK]` must never be modified by this preset.
- If a story is untagged in the spec, default it to frontend ownership instead of leaving ownership ambiguous.
- In dry-run mode, do not perform Azure DevOps writes and do not update the local mapping file.
