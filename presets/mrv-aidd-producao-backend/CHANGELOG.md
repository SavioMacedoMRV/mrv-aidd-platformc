# Changelog

## 0.4.0

- Adicionada declaração explícita de `tools` no frontmatter de todos os comandos, incluindo aliases VS Code (`read`, `edit`, `execute`, `search`, `agent`, `web`, `askQuestions`), ferramentas específicas (`todo`, `memory` em `implement`) e `microsoft/azure-devops-mcp/*` nas etapas que interagem com Azure DevOps.
- Adicionada seção `## Skills` nos corpos dos comandos do fluxo SDD com instrução explícita de leitura dos SKILL.md correspondentes antes de cada etapa:
  - `speckit.specify`: `dotnet`, `dotnet-aspnet`
  - `speckit.clarify`: `dotnet`, `dotnet-aspnet`
  - `speckit.plan`: `dotnet`, `dotnet-aspnet`, `dotnet-data`
  - `speckit.tasks`: `dotnet`
  - `speckit.implement`: `dotnet`, `dotnet-aspnet`, `dotnet-data`, `dotnet-test`
  - `speckit.checklist`: `dotnet`
- ADO MCP declarado em: `specify`, `clarify`, `plan`, `sincronizar-us-devops`. Sem MCPs externos em `tasks`, `implement` e `checklist`.

## 0.3.0

- Bump de versão alinhado à release compartilhada `mrv-aidd-platform-v0.3.0`. Sem mudanças funcionais neste pacote.

## 0.2.0

- Adicionado preset plug and play de backend para AIDD na MRV com ownership de histórias de backend e rastreabilidade Azure DevOps.
- Templates de `spec`, `plan`, `tasks` e `checklist` em português do Brasil com ownership de backend e handoff para frontend.
- Overrides dos comandos core do Spec Kit: `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist`.
- Override do comando `speckit.mrv-aidd-producao.sincronizar-us-devops` com proteção de work items marcados como `[FRONT]`.
