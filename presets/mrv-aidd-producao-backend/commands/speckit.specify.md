---
description: Criar ou atualizar a spec com ownership de historias de backend e rastreabilidade Azure DevOps.
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
tools: [read, edit, execute, search, web, agent, vscode, "microsoft/azure-devops-mcp/wit_get_work_item", "microsoft/azure-devops-mcp/wit_create_work_item", "microsoft/azure-devops-mcp/wit_update_work_item", "microsoft/azure-devops-mcp/wit_get_work_items_batch_by_ids", "microsoft/azure-devops-mcp/core_list_projects", "microsoft/azure-devops-mcp/repo_get_repo_by_name_or_id", "microsoft/azure-devops-mcp/repo_list_branches_by_repo"]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Skills

Before proceeding, load the following skills by reading their SKILL.md files:

- **dotnet**: `.github/skills/dotnet/SKILL.md`
- **dotnet-aspnet**: `.github/skills/dotnet-aspnet/SKILL.md`

## MCP Prerequisites

Before proceeding, verify that the **Azure DevOps MCP** server is active:

- Call `microsoft/azure-devops-mcp/core_list_projects` to confirm the server is reachable.
- If the call fails or the tool is unavailable, **stop immediately** and tell the user to enable the `microsoft/azure-devops-mcp` server in VS Code before retrying.

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

The text the user typed after `/speckit.specify` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `$ARGUMENTS` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. **Resolve `SPECIFY_FEATURE_DIRECTORY`** following this priority: `.specify/init-options.json` → config → default `.specify/features/`.
2. **Generate a concise short name** (2-4 words, kebab-case) for the branch.
3. **Create the feature branch** by running the feature creation script once, with `-Json` and `-ShortName`, respecting `.specify/init-options.json` when present. Persist `feature.json` with `{name, directory, branch, specFile, createdAt}` in the resolved feature directory.
4. Load `.specify/templates/spec-template.md` to understand required sections.
5. Follow the native Spec Kit specification workflow:
   - Parse the user description
   - Extract actors, actions, data, and constraints
   - Use informed guesses where reasonable
   - Limit `[NEEDS CLARIFICATION]` markers to **at most 3** — only for high-impact unresolved decisions
   - Fill user scenarios and testing
   - Generate testable functional requirements
   - Define measurable, technology-agnostic success criteria
   - Identify key entities when data is involved
6. Write the specification to SPEC_FILE using the resolved template structure.
7. Run specification quality validation and generate/update `checklists/requirements.md`. Resolve validation failures before reporting completion.
8. Report completion with branch name, spec file path, checklist results, and readiness for `/speckit.clarify` or `/speckit.plan`.
9. After reporting, process any `hooks.after_specify` entries from `.specify/extensions.yml` using the native Spec Kit rules.

## Quick Guidelines

- Focus on **WHAT** users need and **WHY**.
- Avoid HOW to implement (no tech stack, APIs, code structure).
- Written for business stakeholders, not developers.
- Do NOT create any checklists embedded in the spec.

## Regras adicionais do preset

- Sempre que informacoes faltarem, estiverem ambiguas ou exigirem confirmacao, voce **DEVE** usar `vscode_askQuestions`.
- Trate a feature do upstream como entrada principal, nao como verdade final; ela pode conter gaps funcionais relevantes.
- O papel deste comando e clarificar, aprofundar e fechar esses gaps antes de consolidar a especificacao.
- O `spec.md` gerado por este fluxo deve ser tratado como a fonte de verdade funcional consolidada da feature.
- **Feature do Feature Framing**: o PO deve indicar qual feature da lista de Feature Framing (cadastrada no epico do board) ele quer especificar. Se o input nao mencionar a feature escolhida, use `vscode_askQuestions` para perguntar qual feature do Feature Framing sera trabalhada neste ciclo.
- **Contexto do Epico**: o PO deve referenciar o Contexto do Epico disponivel no epico do Azure DevOps. Se o input nao mencionar o Contexto do Epico, use `vscode_askQuestions` para solicitar a URL ou ID do epico no board antes de prosseguir.
- **Prototipo Figma**: o PO deve fornecer o link do prototipo de alta fidelidade no Figma. Registre o link no spec como referencia visual. Se o link nao for fornecido no input, solicite via `vscode_askQuestions`. O acesso direto ao Figma via MCP e responsabilidade do preset de frontend.
- Use o Contexto do Epico e o prototipo Figma como referencias primarias ao gerar user stories, cenarios e criterios de aceite.

### Entrevista de complemento com o PO

Se o prompt inicial do PO nao cobrir todos os aspectos funcionais necessarios, conduza uma entrevista progressiva via `vscode_askQuestions` **antes** de gerar o spec. Foque apenas no escopo funcional — aspectos tecnicos, edge cases e ambiguidades sao responsabilidade do `/clarify`.

**Abordagem progressiva**: pergunte apenas o que falta, uma rodada por vez. Avalie cada resposta antes de decidir se a proxima pergunta ainda e necessaria. Nao faca todas as perguntas de uma vez.

**Roteiro de referencia** (use apenas os itens ainda nao cobertos pelo input, Contexto do Epico ou prototipo Figma):

1. **Objetivo da feature**: qual problema de negocio esta sendo resolvido? qual o resultado esperado para o usuario?
2. **Atores envolvidos**: quem sao os usuarios ou sistemas que interagem com essa feature? ha perfis distintos?
3. **Regras de negocio principais**: restricoes, limites, condicoes obrigatorias que o PO ja conhece.
4. **Fronteiras explicitas**: o que esta fora do escopo desta feature? ha funcionalidades que nao devem ser incluidas?
5. **Dependencias conhecidas**: ha features anteriores, APIs existentes ou fluxos de outras equipes dos quais esta feature depende?
6. **Prioridade e urgencia**: qual a prioridade relativa dentro do epico? ha prazo externo?

A cada resposta, reavalie: se a informacao recebida ja cobre itens seguintes do roteiro, pule-os. Encerre a entrevista assim que houver informacao suficiente para gerar o spec com qualidade.

- Preserve a secao `## Azure DevOps Traceability` sempre que o input trouxer URL de Feature, ID, organizacao ou projeto do Azure DevOps.
- Este preset so pode criar ou atualizar historias de ownership `backend`.
- Se a demanda for puramente de frontend, interrompa e oriente o uso do preset `mrv-aidd-producao-frontend` no repositorio correto.
- Para cada historia owned por este repositorio:
  - `**Ownership Scope**` deve permanecer `backend`
  - o titulo deve comecar com `[BACK]`
  - `**Azure DevOps Tags**` deve usar `[BACK]`
- Preserve historias de escopo oposto verbatim quando estiverem marcadas por `**Ownership Scope**: frontend`, `**Azure DevOps Tags**: [FRONT]` ou titulo iniciado por `[FRONT]`.
- Quando houver dependencia de frontend, registre em `## Frontend Follow-up` em vez de criar historia owned pelo frontend neste spec.
- Ao concluir, recomende `/speckit.clarify` como proximo comando e `/speckit.plan` na sequencia natural do fluxo.
