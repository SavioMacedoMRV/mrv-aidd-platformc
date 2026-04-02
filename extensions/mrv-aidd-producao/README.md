<div align="center">
	<img src="../../media/mrv-aidd-platform.svg" alt="MRV AIDD Producao" width="120" />

    <h1>MRV AIDD Producao</h1>

    <h3>Extension operacional da MRV para o Spec Kit com sincronizacao de US, preparo de branch e finalizacao orientada por MCP.</h3>

    <p>
    	<img src="https://img.shields.io/badge/type-extension-264D1F?style=for-the-badge" alt="Type extension" />
    	<img src="https://img.shields.io/badge/comandos-3-F7941D?style=for-the-badge" alt="3 comandos" />
    	<img src="https://img.shields.io/badge/hooks-3-7FB239?style=for-the-badge" alt="3 hooks" />
    	<img src="https://img.shields.io/badge/spec%20kit-%3E%3D0.4.4-0C1A0E?style=for-the-badge" alt="Spec Kit version" />
    </p>

</div>

Esta extension concentra o fluxo operacional de producao da MRV que nao existe no core do Spec Kit: sincronizar historias com Azure DevOps via MCP, preparar a branch da US certa e finalizar a entrega com commit e PR no padrao esperado.

Se o objetivo for apenas mudar templates, ownership ou linguagem dos artefatos, use um dos presets da plataforma. Se o objetivo for adicionar comportamento novo ao fluxo, esta e a peca base.

Navegacao rapida:

- [Voltar para a plataforma](../../README.md)
- [Ver preset backend](../../presets/mrv-aidd-producao-backend/README.md)
- [Ver preset frontend](../../presets/mrv-aidd-producao-frontend/README.md)
- [Guia de instalacao](../../docs/guia-instalacao.md)
- [Guia de contribuicao](../../docs/guia-contribuicao.md)

## Sumario

- O que esta extension adiciona
- Instalacao
- Comandos disponiveis
- Pre-requisitos
- Artefatos gerados
- Relacao com os presets
- Veja tambem

## O que esta extension adiciona

Ao instalar `mrv-aidd-producao`, o projeto consumidor passa a ter estes comandos:

- `/speckit.mrv-aidd-producao.sincronizar-us-devops`
- `/speckit.mrv-aidd-producao.configurar-us`
- `/speckit.mrv-aidd-producao.terminar-us`

Ela tambem registra hooks opcionais para sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.

## Instalacao

### Via catalogo MRV

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
```

### Via desenvolvimento local

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
```

Ao instalar, a extension registra automaticamente seus hooks em `.specify/extensions.yml` e provisiona o arquivo de configuracao do pacote para o repositorio consumidor.

## Comandos disponiveis

### `/speckit.mrv-aidd-producao.sincronizar-us-devops`

Use quando precisar sincronizar historias do spec com a Feature pai do Azure DevOps.

- suporta `--dry-run` para validar rastreabilidade, leitura, deduplicacao e acoes previstas sem gravar work items;
- cria ou atualiza historias de usuario filhas;
- escreve no `spec.md` o campo `**ID da US no Azure DevOps**` em cada historia sincronizada.

### `/speckit.mrv-aidd-producao.configurar-us`

Use quando for iniciar o trabalho operacional de uma historia especifica.

- cria ou reutiliza a branch `feature/<feature-branch>/usN`;
- oculta USs concluidas ao perguntar o escopo;
- resolve a US principalmente a partir do `spec.md`;
- move a US selecionada para `DEV` no Azure DevOps quando houver work item identificado.

### `/speckit.mrv-aidd-producao.terminar-us`

Use quando a US atual estiver pronta para sair da branch de trabalho e seguir para PR.

- executa validacoes finais;
- gera commit no padrao `feature AB#<workItemId>: ...`;
- faz push da branch;
- abre a PR para a branch base da feature usando os MCPs do GitHub.

## Pre-requisitos

- O spec ativo contem o link ou o ID da Feature pai na secao `Rastreabilidade Azure DevOps`.
- O usuario esta autenticado e o servidor MCP do Azure DevOps esta configurado no ambiente do agente.
- A Feature pai ja existe no Azure DevOps.
- Para a etapa de PR, os MCPs do GitHub precisam estar disponiveis no ambiente.

## Artefatos gerados

Durante a sincronizacao, a extension cria ou atualiza o mapa local em `.specify/extensions/mrv-aidd-producao/us-sync-map.json`.

Quando executado com `--dry-run`, o comando informa acoes como `criaria`, `atualizaria` e `vincularia` em vez de executar gravacoes reais.

## Relacao com os presets

Esta extension funciona sozinha, mas normalmente sera instalada junto com um dos presets da plataforma:

- [`mrv-aidd-producao-backend`](../../presets/mrv-aidd-producao-backend/README.md)
- [`mrv-aidd-producao-frontend`](../../presets/mrv-aidd-producao-frontend/README.md)

Os presets mudam como o Spec Kit escreve os artefatos. Esta extension muda o que o fluxo consegue fazer.

## Veja tambem

- [README da plataforma](../../README.md)
- [Preset backend](../../presets/mrv-aidd-producao-backend/README.md)
- [Preset frontend](../../presets/mrv-aidd-producao-frontend/README.md)
- [Guia de instalacao](../../docs/guia-instalacao.md)
- [Guia de contribuicao](../../docs/guia-contribuicao.md)
