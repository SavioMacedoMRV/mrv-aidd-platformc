# Changelog

## 0.3.0

- Bump de versão alinhado à release compartilhada `mrv-aidd-platform-v0.3.0`. Sem mudanças funcionais neste pacote.

## 0.2.0

- Adicionado preset plug and play de backend para AIDD na MRV com ownership de histórias de backend e rastreabilidade Azure DevOps.
- Templates de `spec`, `plan`, `tasks` e `checklist` em português do Brasil com ownership de backend e handoff para frontend.
- Overrides dos comandos core do Spec Kit: `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist`.
- Override do comando `speckit.mrv-aidd-producao.sincronizar-us-devops` com proteção de work items marcados como `[FRONT]`.
