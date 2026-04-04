---
description: Gerar um tasks.md acionavel e ordenado por dependencias com saida em portugues do Brasil.
handoffs:
  - label: Analisar consistencia
    agent: speckit.analyze
    prompt: Execute uma analise do projeto para verificar consistencia
    send: true
  - label: Implementar projeto
    agent: speckit.implement
    prompt: Inicie a implementacao em fases
    send: true
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Pre-Execution Checks

**Check for extension hooks (before tasks generation)**:

- Check if `.specify/extensions.yml` exists in the project root.
- If it exists, read it and look for entries under the `hooks.before_tasks` key
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

1. **Setup**: Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot"). If the current git branch is a child branch like `feature/<feature-branch>/usN`, first set `SPECIFY_FEATURE=<feature-branch>` in the same terminal session before invoking the script so the native PowerShell flow resolves the base feature correctly.

2. **Load design documents**: Read from FEATURE_DIR:
   - **Required**: plan.md (tech stack, libraries, structure), spec.md (user stories with priorities)
   - **Optional**: data-model.md (entities), contracts/ (interface contracts), research.md (decisions), quickstart.md (test scenarios)
   - Note: Not all projects have all documents. Generate tasks based on what's available.

3. **Execute task generation workflow**:
   - Load plan.md and extract tech stack, libraries, project structure
   - Load spec.md and extract user stories with their priorities (P1, P2, P3, etc.)
   - If data-model.md exists: Extract entities and map to user stories
   - If contracts/ exists: Map interface contracts to user stories
   - If research.md exists: Extract decisions for setup tasks
   - Generate tasks organized by user story (see Task Generation Rules below)
   - Generate dependency graph showing user story completion order
   - Create parallel execution examples per user story
   - Validate task completeness (each user story has all needed tasks, independently testable)

4. **Generate tasks.md**: Use `.specify/templates/tasks-template.md` as structure, fill with:
   - Correct feature name from plan.md

- Phase 1: User Story 1 (P1/MVP), including any shared setup work and any foundational/blocking prerequisites required by the feature
- Phase 2+: One phase per remaining user story (in priority order from spec.md)
- Each phase includes: story goal, independent test criteria, tests (if requested), implementation tasks and, when applicable, shared prerequisites absorbed by US1
- Final Phase: Polish & cross-cutting concerns
- All tasks must follow the strict checklist format (see Task Generation Rules below)
- Clear file paths for each task
- Dependencies section showing US1 as the first delivery phase and unlock condition for remaining stories when there is shared groundwork
- Parallel execution examples per story
- Implementation strategy section (MVP first, incremental delivery)

5. **Report**: Output path to generated tasks.md and summary:
   - Total task count
   - Task count per user story
   - Parallel opportunities identified
   - Independent test criteria for each story
   - Suggested MVP scope (typically just User Story 1)
   - Format validation: Confirm ALL tasks follow the checklist format (checkbox, ID, labels, file paths)

6. **Check for extension hooks**: After tasks.md is generated, check if `.specify/extensions.yml` exists in the project root.
   - If it exists, read it and look for entries under the `hooks.after_tasks` key
   - If the YAML cannot be parsed or is invalid, skip hook checking silently and continue normally
   - Filter out hooks where `enabled` is explicitly `false`. Treat hooks without an `enabled` field as enabled by default.
   - For each remaining hook, do **not** attempt to interpret or evaluate hook `condition` expressions:
     - If the hook has no `condition` field, or it is null/empty, treat the hook as executable
     - If the hook defines a non-empty `condition`, skip the hook and leave condition evaluation to the HookExecutor implementation
   - For each executable hook, output the following based on its `optional` flag:
     - **Optional hook** (`optional: true`):

       ```
       ## Extension Hooks

       **Optional Hook**: {extension}
       Command: `/{command}`
       Description: {description}

       Prompt: {prompt}
       To execute: `/{command}`
       ```

     - **Mandatory hook** (`optional: false`):

       ```
       ## Extension Hooks

       **Automatic Hook**: {extension}
       Executing: `/{command}`
       EXECUTE_COMMAND: {command}
       ```

   - If no hooks are registered or `.specify/extensions.yml` does not exist, skip silently

Context for task generation: $ARGUMENTS

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by user story to enable independent implementation and testing.

**Tests are OPTIONAL**: Only generate test tasks if explicitly requested in the feature specification or if user requests TDD approach.

### Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies on incomplete tasks)
4. **[Story] label**: REQUIRED for every task that belongs to a user story phase
   - Format: [US1], [US2], [US3], etc. (maps to user stories from spec.md)

- Shared setup/foundation tasks absorbed by US1: MUST use `[US1]`
- User Story phases: MUST have story label
- Polish phase: NO story label

5. **Description**: Clear action with exact file path

**Examples**:

- ✅ CORRECT: `- [ ] T001 Create project structure per implementation plan`
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ✅ CORRECT: `- [ ] T012 [P] [US1] Create User model in src/models/user.py`
- ✅ CORRECT: `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- ❌ WRONG: `- [ ] Create User model` (missing ID and Story label)
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [US1] Create User model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [US1] Create model` (missing file path)

### Task Organization

1. **From User Stories (spec.md)** - PRIMARY ORGANIZATION:
   - Each user story (P1, P2, P3...) gets its own phase
   - Map all related components to their story:
     - Models needed for that story
     - Services needed for that story
     - Interfaces/UI needed for that story
     - If tests requested: Tests specific to that story
   - Mark story dependencies (most stories should be independent)

2. **From Contracts**:
   - Map each interface contract → to the user story it serves
   - If tests requested: Each interface contract → contract test task [P] before implementation in that story's phase

3. **From Data Model**:
   - Map each entity to the user story(ies) that need it
   - If entity serves multiple stories: Put in earliest story or Setup phase
   - Relationships → service layer tasks in appropriate story phase

4. **From Setup/Infrastructure**:
   - Shared setup or initialization work that unlocks the feature → earliest viable story, defaulting to `US1`
   - Foundational/blocking tasks that affect multiple stories → `US1`
   - Story-specific setup → within that story's phase
   - Do not create standalone Setup or Foundational phases before `US1`

### Phase Structure

- **Phase 1**: User Story 1 (P1/MVP), including shared setup and foundational/blocking prerequisites
- **Phase 2+**: Remaining user stories in priority order (P2, P3...)
  - Within each story: Tests (if requested) → Models → Services → Endpoints → Integration
  - Within `US1`, place shared setup/foundation work before the story-specific tests and implementation tasks
  - Each phase should be a complete, independently testable increment
- **Final Phase**: Polish & Cross-Cutting Concerns

## Regras adicionais do preset

- Sempre que este comando precisar pedir informacoes, confirmacoes ou desambiguacoes ao usuario, voce **DEVE** usar a ferramenta `vscode_askQuestions`.
- Trate `spec.md` como a fonte de verdade funcional e `plan.md` como a fonte de verdade tecnica ao decompor a US.
- Considere que o board deve refletir o `spec.md` validado; nao use a feature bruta do upstream como base para decomposicao.
- O texto informado em `$ARGUMENTS` e a fonte primaria do escopo da US nesta execucao. Se o usuario ja informar `US1`, `US2` ou equivalente no argumento, nao repita a pergunta de escopo.
- Antes de gerar, atualizar ou refinar o `tasks.md`, voce **DEVE** identificar explicitamente qual US ou quais USs o desenvolvedor vai trabalhar nesta execucao.
- Se o usuario nao informar com clareza qual US ou quais USs entram no escopo atual, voce **DEVE** perguntar isso usando `vscode_askQuestions` antes de continuar.
- Aceite uma ou mais USs por identificador, titulo ou outra referencia equivalente que permita reconhecer o escopo.
- Nunca decomponha a feature inteira por padrao quando o escopo de execucao nao estiver explicito; interrompa e desambiguar e obrigatorio.
- Nao gere, altere ou priorize tarefas para USs fora do escopo informado pelo usuario, exceto quando a funcionalidade exigir preservar `US1` como fase inicial por concentrar setup/fundacao compartilhados.
- Quando houver tarefas compartilhadas de setup ou fundacao, elas DEVEM ficar dentro de `US1` com rotulo `[US1]`, mesmo que beneficiem outras historias.
- `US1` DEVE ser a primeira fase do `tasks.md` sempre que existir na funcionalidade.
- Se a demanda for hotfix, nao use este fluxo como substituto do fluxo alternativo; registre a excecao e trate o caso fora da decomposicao normal da feature.
- Considere a branch principal nativa da feature criada pelo Speckit, como `001-feature-name`, como branch integradora da funcionalidade.
- Para cada US em escopo, recomende uma branch dedicada no formato `feature/<feature-branch>/usN` e, quando necessario, oriente o uso de `/speckit.mrv-aidd-producao.configurar-us USn` para cria-la.
- Nao oriente PRs de historias de usuario diretamente para `main`; o destino correto dessas branches e a branch base da feature, como `001-feature-name`.
- Todas as mensagens ao usuario e todo o conteudo gerado em `tasks.md` DEVEM estar em portugues do Brasil, preservando apenas caminhos, comandos, identificadores tecnicos, nomes de arquivos e termos oficiais que precisem permanecer no idioma original.
