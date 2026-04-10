# Changelog

## 0.8.0

- Bump de versao alinhado a release compartilhada `mrv-aidd-platform-v0.8.0`. Sem mudancas funcionais neste pacote.

## 0.7.0

- Comando `sincronizar-us-devops` agora resolve o Épico pai e cria a Feature como filha do Épico quando ela não existe, antes de criar as USs. A hierarquia no Azure DevOps passa a ser Épico → Feature → USs.
- Removido pré-requisito de que a Feature já deveria existir no Azure DevOps antes da sincronização.

## 0.6.0

- Bump de versão alinhado à release compartilhada `mrv-aidd-platform-v0.6.0`. Sem mudanças funcionais neste pacote.

## 0.5.0

- Corrigido formato da declaração `tools` no frontmatter de todos os comandos: migração de bloco YAML com nomes individuais de ferramentas para array inline com grupos built-in e ferramentas MCP com separador `/`.
- Adicionada seção `## MCP Prerequisites` em todos os comandos que dependem de MCP (`configurar-us`, `terminar-us`, `sincronizar-us-devops`): o agente verifica a disponibilidade do servidor MCP (Azure DevOps ou GitHub) antes de iniciar o fluxo e interrompe com orientação clara ao usuário caso o servidor não esteja acessível.

## 0.4.0

- Bump de versão alinhado à release compartilhada `mrv-aidd-platform-v0.4.0`. Sem mudanças funcionais neste pacote.

## 0.3.0

- Bump de versão alinhado à release compartilhada `mrv-aidd-platform-v0.3.0`. Sem mudanças funcionais neste pacote.

## 0.1.0

- Initial local scaffold for Azure DevOps MCP user story sync.
