# Changelog

## 0.7.0

- Comando `speckit.specify` agora exige seleção da feature do Feature Framing e conduz entrevista progressiva com o PO (uma rodada por vez, adaptativa, encerra quando há informação suficiente).
- Comando `speckit.specify` agora referencia obrigatoriamente Contexto do Épico e link do Figma via MCP.
- Comando `speckit.plan` agora referencia o diagrama C4 de `.specify/memory/` quando disponível.
- Comando `sincronizar-us-devops` agora resolve o Épico pai e cria a Feature como filha do Épico antes de criar as USs (hierarquia Épico → Feature → USs).

## 0.6.0

- Corrigido formato da declaração `tools` no frontmatter de todos os comandos: migração de bloco YAML com nomes individuais de ferramentas para array inline com grupos built-in (`read`, `edit`, `execute`, `search`, `web`, `agent`, `vscode`, `todo`) e ferramentas MCP com separador `/` (ex: `"com.figma.mcp/mcp/get_design_context"`, `"microsoft/playwright-mcp/browser_navigate"`).
- Adicionada seção `## MCP Prerequisites` em todos os comandos que dependem de MCP (`specify`, `clarify`, `plan`, `implement`, `checklist`, `sincronizar-us-devops`): o agente verifica a disponibilidade dos servidores MCP necessários (Azure DevOps, Figma, Playwright, MicrosoftDocs) antes de iniciar o fluxo e interrompe com orientação clara ao usuário caso algum servidor não esteja acessível.

## 0.5.0

- Adicionado step 13 (Backend Handoff) ao comando `speckit.mrv-aidd-producao.sincronizar-us-devops`: ao final da sincronizacao, o agente pergunta se o projeto tem backend e, se sim, gera um bloco copiavel com o prompt `/speckit.specify` completo para o repositorio backend, contendo a rastreabilidade da Feature pai no Azure DevOps e o conteudo de `## Backend Follow-up` da spec do frontend.
- Adicionada salvaguarda: quando `## Backend Follow-up` estiver ausente ou vazio, o prompt gerado instrui o agente backend a executar `/speckit.clarify` antes de prosseguir para o plan.
- Adicionada Behavior Rule: em dry-run mode, o step 13 e suprimido inteiramente.

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
