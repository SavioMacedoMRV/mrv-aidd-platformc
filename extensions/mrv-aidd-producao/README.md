# MRV AIDD Producao

Extensao local consolidada do Spec Kit para uso plug and play em projetos da MRV.

## Objetivo

Reunir em uma unica extensao os comandos operacionais do ecossistema de producao da MRV para AIDD, da sincronizacao ate o encerramento da US:

- `/speckit.mrv-aidd-producao.sincronizar-us-devops`
- `/speckit.mrv-aidd-producao.configurar-us`
- `/speckit.mrv-aidd-producao.terminar-us`

## Pre-requisitos

- O spec ativo contem o link ou o ID da Feature pai na secao `Rastreabilidade Azure DevOps`.
- O usuario esta autenticado e o servidor MCP do Azure DevOps esta configurado no ambiente do agente.
- A Feature pai ja existe no Azure DevOps.

## Instalacao local

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
```

Ao instalar, a extensao registra automaticamente os hooks opcionais em `.specify/extensions.yml` para sugerir `/speckit.mrv-aidd-producao.configurar-us` antes de `tasks` e `implement`, e `/speckit.mrv-aidd-producao.terminar-us` depois de `implement`.

## Comandos

- `/speckit.mrv-aidd-producao.sincronizar-us-devops`
	Suporta `--dry-run` para validar rastreabilidade, leitura das historias, deduplicacao e acoes previstas no Azure DevOps sem gravar work items nem o arquivo local de mapeamento.
- `/speckit.mrv-aidd-producao.configurar-us`
	Cria ou reutiliza a branch `feature/<feature-branch>/usN`, oculta USs concluidas ao perguntar o escopo, resolve a US principalmente a partir do `spec.md` e move a US selecionada para `DEV` no Azure DevOps quando houver work item identificado.
- `/speckit.mrv-aidd-producao.terminar-us`
	Executa a finalizacao da US atual, incluindo validacoes finais, commit no padrao `feature AB#<workItemId>: ...`, push da branch e abertura da PR para a branch base da feature usando os MCPs do GitHub.

Depois de sincronizar, a extensao tambem escreve no `spec.md` o campo `**ID da US no Azure DevOps**` dentro de cada historia sincronizada, para que os proximos comandos possam usar o proprio spec como fonte primaria de rastreabilidade.

## Saida

O comando de sincronizacao cria ou atualiza historias de usuario filhas e armazena um mapa local de sincronizacao em `.specify/extensions/mrv-aidd-producao/us-sync-map.json`.

Quando executado com `--dry-run`, o comando informa acoes `criaria`, `atualizaria` e `vincularia` em vez de executar gravacoes.