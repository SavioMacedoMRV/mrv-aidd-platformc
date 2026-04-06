# Changelog

## 0.4.0

- Bump de versão alinhado à release compartilhada `mrv-aidd-platform-v0.4.0`. Sem mudanças funcionais neste pacote.

## 0.3.0

- Adicionada declaração explícita de `tools` no frontmatter de todos os comandos, incluindo aliases VS Code (`read`, `edit`, `execute`, `search`, `agent`, `web`, `askQuestions`), ferramentas específicas (`todo`, `memory` em `implement`) e MCPs por etapa.
- Adicionada seção `## Skills` nos corpos dos comandos do fluxo SDD com instrução explícita de leitura dos SKILL.md correspondentes antes de cada etapa:
  - `speckit.specify`: `portal360-framework-frontend`, `figma-implement-react-styled-components`
  - `speckit.clarify`: `portal360-framework-frontend`
  - `speckit.plan`: `portal360-framework-frontend`, `figma-implement-react-styled-components`
  - `speckit.tasks`: `portal360-framework-frontend`
  - `speckit.implement`: `portal360-framework-frontend`, `figma-implement-react-styled-components`, `playwright-cli`
  - `speckit.checklist`: `portal360-framework-frontend`
- MCPs declarados por etapa: Figma MCP (`specify`, `clarify`, `plan`, `implement`, `checklist`), Azure DevOps MCP (`specify`, `clarify`, `plan`, `sincronizar-us-devops`), Playwright MCP (`implement`).

## 0.2.0

- Adicionado preset plug and play de frontend para AIDD na MRV com ownership de histórias de frontend e rastreabilidade Azure DevOps.
- Templates de `spec`, `plan`, `tasks` e `checklist` em português do Brasil com ownership de frontend e handoff para backend.
- Overrides dos comandos core do Spec Kit: `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist`.
- Override do comando `speckit.mrv-aidd-producao.sincronizar-us-devops` com proteção de work items marcados como `[BACK]`.
