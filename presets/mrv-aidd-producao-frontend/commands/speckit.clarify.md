---
description: Esclarecer a spec preservando historias de backend e gerando handoff para o repositorio de back-end quando necessario.
handoffs:
  - label: Construir plano tecnico
    agent: speckit.plan
    prompt: Crie um plano para a spec atual usando o fluxo do projeto.
    send: true
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --paths-only
  ps: scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly
tools: [read, edit, execute, search, web, agent, vscode, "com.figma.mcp/mcp/get_design_context", "com.figma.mcp/mcp/get_metadata", "com.figma.mcp/mcp/get_screenshot", "com.figma.mcp/mcp/get_variable_defs", "com.figma.mcp/mcp/search_design_system", "microsoft/azure-devops-mcp/wit_get_work_item", "microsoft/azure-devops-mcp/wit_get_work_items_batch_by_ids", "microsoft/azure-devops-mcp/wit_list_backlog_work_items", "microsoft/azure-devops-mcp/search_workitem", "microsoft/azure-devops-mcp/core_list_projects"]
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Skills

Before proceeding, load the following skills by reading their SKILL.md files:

- **portal360-framework-frontend**: `.github/skills/portal360-framework-frontend/SKILL.md`

## MCP Prerequisites

Before proceeding, verify that the required MCP servers are active:
- **Azure DevOps MCP**: call `microsoft/azure-devops-mcp/core_list_projects` to confirm the server is reachable.
- **Figma MCP**: call `com.figma.mcp/mcp/whoami` to confirm the server is reachable and the user is authenticated.
- If any call fails or the tool is unavailable, **stop immediately** and tell the user to enable the corresponding MCP server in VS Code before retrying.

## Outline

Goal: Detect and reduce ambiguity or missing decision points in the active feature specification and record the clarifications directly in the spec file.

Note: This clarification workflow is expected to run (and be completed) BEFORE invoking `/speckit.plan`. If the user explicitly states they are skipping clarification (for example, an exploratory spike), you may proceed, but must warn that downstream rework risk increases.

Execution steps:

1. Run `.specify/scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly` from the repo root **once** and parse the minimal JSON payload:
   - `FEATURE_DIR`
   - `FEATURE_SPEC`
   - Optionally capture `IMPL_PLAN` and `TASKS` for later guidance.
   - If JSON parsing fails, abort and instruct the user to rerun `/speckit.specify` or verify the feature branch context.

2. Load the current spec file. Perform a structured ambiguity and coverage scan using this taxonomy. For each category, classify it as Clear, Partial, or Missing. Use the scan only for prioritization unless no questions will be asked.

   Functional Scope and Behavior:
   - Core user goals and success criteria
   - Explicit out-of-scope declarations
   - User roles and persona differentiation

   Domain and Data Model:
   - Entities, attributes, relationships
   - Identity and uniqueness rules
   - Lifecycle or state transitions
   - Data volume and scale assumptions

   Interaction and UX Flow:
   - Critical user journeys and sequences
   - Error, empty, and loading states
   - Accessibility or localization notes

   Non-Functional Quality Attributes:
   - Performance targets
   - Scalability expectations
   - Reliability and availability expectations
   - Observability needs
   - Security and privacy assumptions
   - Compliance constraints

   Integration and External Dependencies:
   - External services and failure modes
   - Data import and export formats
   - Protocol and versioning assumptions

   Edge Cases and Failure Handling:
   - Negative scenarios
   - Rate limiting or throttling
   - Conflict resolution

   Constraints and Tradeoffs:
   - Technical constraints
   - Explicit tradeoffs or rejected alternatives

   Terminology and Consistency:
   - Canonical glossary terms
   - Avoided synonyms or deprecated terms

   Completion Signals:
   - Acceptance criteria testability
   - Measurable definition-of-done style indicators

   Misc and Placeholders:
   - TODO markers or unresolved decisions
   - Ambiguous adjectives lacking quantification

   For each Partial or Missing category, add a candidate clarification question unless the answer would not materially change implementation or validation strategy, or the information is clearly better deferred to planning.

3. Generate an internal prioritized queue of candidate clarification questions with a maximum of 5 questions across the whole session.
   - Every question must be answerable by either:
     - a short multiple-choice selection with 2 to 5 distinct, mutually exclusive options, or
     - a short answer explicitly constrained to 5 words or fewer.
   - Only include questions whose answers materially affect architecture, data modeling, task decomposition, test design, behavior, operational readiness, or compliance validation.
   - Favor clarifications that reduce downstream rework risk or prevent misaligned acceptance tests.
   - If more than 5 categories remain unresolved, pick the top 5 by impact and uncertainty.

4. Sequential questioning loop:
   - Present EXACTLY ONE question at a time.
   - All questions, confirmations, and disambiguations **MUST** use `vscode_askQuestions`.
   - For multiple-choice questions:
     - Analyze all options and determine the most suitable option based on best practices, common patterns, risk reduction, and alignment with explicit constraints in the spec.
     - Mark one option as recommended.
     - Offer 2 to 5 mutually exclusive options.
     - Allow freeform input only when a different short answer is genuinely useful, and constrain it to 5 words or fewer.
   - For short-answer questions without meaningful discrete options:
     - Provide a suggested answer grounded in best practices and context.
     - Require the answer to be 5 words or fewer.
   - After the user answers:
     - If the user accepts the recommendation or suggestion, use it as the final answer.
     - Otherwise, validate that the answer maps to one option or respects the 5-word constraint.
     - If ambiguous, ask a quick disambiguation using `vscode_askQuestions`; this still belongs to the same question.
   - Stop asking further questions when all critical ambiguities are resolved, the user signals completion, or you reach 5 accepted questions.
   - Never reveal future queued questions in advance.
   - If no valid questions exist at the start, immediately report that no critical ambiguities were found.

5. Integrate every accepted answer incrementally:
   - Maintain an in-memory representation of the spec plus the raw file contents.
   - On the first accepted answer in the session:
     - Ensure a `## Clarifications` section exists.
     - Ensure a `### Session YYYY-MM-DD` subsection exists for today.
   - Append `- Q: <question> -> A: <final answer>` immediately after acceptance.
   - Apply each clarification to the most appropriate section:
     - Functional ambiguity: Functional Requirements.
     - User interaction or actor distinction: User Stories or Actors.
     - Data shape or entities: Data Model.
     - Non-functional constraint: measurable Success Criteria.
     - Edge case or negative flow: Edge Cases or Error Handling.
     - Terminology conflict: normalize wording across the spec.
   - Replace obsolete contradictory text instead of duplicating it.
   - Save the spec after each accepted clarification.
   - Preserve formatting and heading hierarchy.
   - Keep inserted clarifications minimal and testable.

6. Validation after each write and at the end:
   - Exactly one clarification bullet per accepted answer.
   - Total accepted questions is at most 5.
   - No lingering vague placeholders that the new answer should have resolved.
   - No contradictory earlier statement remains.
   - Markdown structure stays valid, with only `## Clarifications` and `### Session YYYY-MM-DD` added when needed.
   - Terminology remains consistent.

7. Write the updated spec back to `FEATURE_SPEC`.

8. Report completion with:
   - Number of questions asked and answered.
   - Path to the updated spec.
   - Sections touched.
   - Coverage summary across the taxonomy using Resolved, Deferred, Clear, or Outstanding.
   - A recommendation on whether to proceed to `/speckit.plan` or revisit `/speckit.clarify` later.
   - Suggested next command.

## Regras adicionais do preset

- Considere historias de frontend as marcadas por `**Ownership Scope**: frontend`, `**Azure DevOps Tags**: [FRONT]` ou titulo iniciado por `[FRONT]`.
- Considere historias de backend as marcadas por `**Ownership Scope**: backend`, `**Azure DevOps Tags**: [BACK]` ou titulo iniciado por `[BACK]`.
- Preserve historias owned pelo backend verbatim.
- Se alguma historia de frontend estiver sem `**Link do Figma**`, colete o link via `vscode_askQuestions` antes de finalizar a clarificacao.
- Ao atualizar historias owned pelo frontend, preserve a estrutura `Como um`, `Eu quero`, `Para que`, `Link do Figma`, `Descricao`, `Valor para o Negocio`.
- Garanta que cada historia de frontend continue com titulo iniciado por `[FRONT] ` e `**Azure DevOps Tags**: [FRONT]`.
- Se surgir trabalho de backend, atualize `## Backend Follow-up` em vez de cruzar ownership.
- Quando houver Feature pai concreta, recomende `/speckit.mrv-aidd-producao.sincronizar-us-devops` antes de `/speckit.plan`.

Behavior rules:

- If no meaningful ambiguities are found, respond with "No critical ambiguities detected worth formal clarification." and suggest proceeding.
- If the spec is missing, instruct the user to run `/speckit.specify` first.
- Never exceed 5 total accepted questions.
- Avoid speculative tech-stack questions unless the absence blocks functional clarity.
- Respect early-stop signals from the user.
- If no questions are asked due to full coverage, output a compact coverage summary and suggest advancing.
- If quota is reached with unresolved high-impact categories remaining, flag them as Deferred with rationale.

Context for prioritization: {ARGS}
