---
description: Criar ou atualizar a spec com ownership de historias de frontend, rastreabilidade Azure DevOps e handoff para backend quando necessario.
handoffs:
  - label: Esclarecer requisitos da spec
    agent: speckit.clarify
    prompt: Clarify specification requirements
    send: true
  - label: Construir plano tecnico
    agent: speckit.plan
    prompt: Create a plan for the spec. I am building with...
scripts:
  sh: scripts/bash/create-new-feature.sh "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Pre-Execution Checks

**Check for extension hooks (before specification)**:

- Check if `.specify/extensions.yml` exists in the project root.
- If it exists, read it and look for entries under the `hooks.before_specify` key
- If the YAML cannot be parsed or is invalid, skip hook checking silently and continue normally
- Filter out hooks where `enabled` is explicitly `false`. Treat hooks without an `enabled` field as enabled by default.
- For each remaining hook, do **not** attempt to interpret or evaluate hook `condition` expressions:
  - If the hook has no `condition` field, or it is null/empty, treat the hook as executable
  - If the hook defines a non-empty `condition`, skip the hook and leave condition evaluation to the HookExecutor implementation
- For each executable hook, output the following based on its `optional` flag:
  - **Optional hook** (`optional: true`):

    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

  - **Mandatory hook** (`optional: false`):

    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Outline.
    ```

- If no hooks are registered or `.specify/extensions.yml` does not exist, skip silently

## Outline

The text the user typed after `/speckit.specify` is the feature description.

1. Generate a concise short name for the branch.
2. Create the feature branch/spec once using the native Spec Kit script with `-Json` and `-ShortName`, respecting `.specify/init-options.json` when present.
3. Load `.specify/templates/spec-template.md` and use it as the source of truth for section structure.
4. Follow the native Spec Kit specification workflow:
   - extract actors, actions, data, and constraints
   - make informed guesses when reasonable
   - use `[NEEDS CLARIFICATION]` only for high-impact unresolved decisions
   - generate user scenarios, functional requirements, success criteria, and entities
5. Write the spec to the resolved SPEC_FILE.
6. Run the native spec quality validation loop and update the requirements checklist as needed.
7. Report completion with branch, spec path, checklist status, and readiness for the next command.

## Quick Guidelines

- Focus on **WHAT** users need and **WHY**.
- Avoid HOW to implement.
- Write for business stakeholders, not developers.
- Do not embed checklist content inside the spec.

## Regras adicionais do preset

- Sempre que informacoes faltarem, estiverem ambiguas ou exigirem confirmacao, use `vscode_askQuestions`.
- Trate a feature do upstream como entrada principal, nao como verdade final; ela pode conter gaps funcionais relevantes.
- O papel deste comando e clarificar, aprofundar e fechar esses gaps antes de consolidar a especificacao.
- O `spec.md` gerado por este fluxo deve ser tratado como a fonte de verdade funcional consolidada da feature.
- Preserve `## Azure DevOps Traceability` quando houver contexto de Azure DevOps no input.
- Este preset so pode criar ou atualizar historias de ownership `frontend`.
- Se a demanda for puramente de backend, interrompa e direcione para o preset `mrv-aidd-producao-backend`.
- Se o fluxo de frontend nao trouxer Figma, colete o link via `vscode_askQuestions` antes de finalizar a spec.
- Para cada historia owned por este repositorio:
  - `**Ownership Scope**` deve permanecer `frontend`
  - o titulo deve comecar com `[FRONT] `
  - `**Azure DevOps Tags**` deve usar `[FRONT]`
- Preserve historias de escopo oposto verbatim quando estiverem marcadas por `**Ownership Scope**: backend`, `**Azure DevOps Tags**: [BACK]` ou titulo iniciado por `[BACK]`.
- Quando houver dependencia de backend, registre em `## Backend Follow-up` em vez de criar historia owned pelo backend neste spec.
- Ao concluir, recomende `/speckit.clarify` e depois `/speckit.plan`.

  **Optional Pre-Hook**: {extension}
  Command: `/{command}`
  Description: {description}

  Prompt: {prompt}
  To execute: `/{command}`

  ```
  - **Mandatory hook** (`optional: false`):
  ```

  ## Extension Hooks

  **Automatic Pre-Hook**: {extension}
  Executing: `/{command}`
  EXECUTE_COMMAND: {command}

  Wait for the result of the hook command before proceeding to the Outline.

  ```

  ```

- If no hooks are registered or `.specify/extensions.yml` does not exist, skip silently

## Outline

The text the user typed after `/speckit.specify` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `$ARGUMENTS` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. **Generate a concise short name** (2-4 words) for the branch.
2. **Create the feature branch** by running the feature creation script once, with `-Json` and `-ShortName`, respecting `.specify/init-options.json` when present.
3. Load `.specify/templates/spec-template.md` to understand required sections.
4. Follow the native Spec Kit specification workflow:
   - Parse the user description
   - Extract actors, actions, data, and constraints
   - Use informed guesses where reasonable
   - Limit `[NEEDS CLARIFICATION]` markers to the most critical cases
   - Fill user scenarios and testing
   - Generate testable functional requirements
   - Define measurable, technology-agnostic success criteria
   - Identify key entities when data is involved
5. Write the specification to SPEC_FILE using the resolved template structure.
6. Run specification quality validation, maintain the requirements checklist, and resolve validation failures before reporting completion.
7. Report completion with branch name, spec file path, checklist results, and readiness for `/speckit.clarify` or `/speckit.plan`.
8. After reporting, process any `hooks.after_specify` entries from `.specify/extensions.yml` using the native Spec Kit rules.

## Quick Guidelines

- Focus on **WHAT** users need and **WHY**.
- Avoid HOW to implement (no tech stack, APIs, code structure).
- Written for business stakeholders, not developers.
- Do NOT create any checklists embedded in the spec.

## Regras adicionais do preset

- Sempre que informacoes faltarem, estiverem ambiguas ou exigirem confirmacao, voce **DEVE** usar `vscode_askQuestions`.
- Preserve a secao `## Azure DevOps Traceability` sempre que o input trouxer URL de Feature, ID, organizacao ou projeto do Azure DevOps.
- Este preset so pode criar ou atualizar historias de ownership `frontend`.
- Se a demanda for puramente de backend, interrompa e oriente o uso do preset `mrv-aidd-producao-backend` no repositorio correto.
- Se o input nao trouxer Figma para fluxo de frontend, colete o link via `vscode_askQuestions` antes de finalizar a spec.
- Para cada historia owned por este repositorio:
  - `**Ownership Scope**` deve permanecer `frontend`
  - o titulo deve comecar com `[FRONT] `
  - `**Azure DevOps Tags**` deve usar `[FRONT]`
- Preserve historias de escopo oposto verbatim quando estiverem marcadas por `**Ownership Scope**: backend`, `**Azure DevOps Tags**: [BACK]` ou titulo iniciado por `[BACK]`.
- Quando houver dependencia de backend, registre em `## Backend Follow-up` em vez de criar historia owned pelo backend neste spec.
- Ao concluir, recomende `/speckit.clarify` como proximo comando e `/speckit.plan` na sequencia natural do fluxo.
