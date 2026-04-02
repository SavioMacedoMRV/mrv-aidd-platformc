<div align="center">
	<img src="../../media/mrv-aidd-platform.svg" alt="MRV AIDD Producao Frontend" width="120" />

    <h1>MRV AIDD Producao Frontend</h1>

    <h3>Preset plug and play para repositorios frontend da MRV com ownership em pt-BR, handoff controlado e rastreabilidade Azure DevOps.</h3>

    <p>
    	<img src="https://img.shields.io/badge/type-preset-264D1F?style=for-the-badge" alt="Type preset" />
    	<img src="https://img.shields.io/badge/foco-frontend-F7941D?style=for-the-badge" alt="Foco frontend" />
    	<img src="https://img.shields.io/badge/templates-4-7FB239?style=for-the-badge" alt="4 templates" />
    	<img src="https://img.shields.io/badge/comandos-7-0C1A0E?style=for-the-badge" alt="7 comandos" />
    </p>

</div>

Este preset adapta o fluxo do Spec Kit para o contexto de frontend da MRV sem criar novas capacidades. Ele reescreve templates e comandos para refletir ownership frontend, manter os artefatos em portugues do Brasil e preservar o handoff para backend quando necessario.

Use este preset junto com a extension [`mrv-aidd-producao`](../../extensions/mrv-aidd-producao/README.md). O preset customiza a experiencia; a extension executa o fluxo operacional novo.

Navegacao rapida:

- [Voltar para a plataforma](../../README.md)
- [Ver extension base](../../extensions/mrv-aidd-producao/README.md)
- [Ver preset backend](../../presets/mrv-aidd-producao-backend/README.md)
- [Guia de instalacao](../../docs/guia-instalacao.md)
- [Guia de contribuicao](../../docs/guia-contribuicao.md)

## Sumario

- O que este preset faz
- Instalacao
- Escopo de customizacao
- Quando usar
- Dependencia
- Veja tambem

## O que este preset faz

O preset `mrv-aidd-producao-frontend` concentra em um unico pacote:

- artefatos em portugues do Brasil;
- ownership principal de frontend;
- rastreabilidade Azure DevOps no fluxo de especificacao;
- handoff controlado para backend;
- orientacao de branch por US em conjunto com a extension da plataforma.

## Instalacao

### Via catalogo MRV

```powershell
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
specify preset add mrv-aidd-producao-frontend --priority 5
```

### Via desenvolvimento local

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

Instale apenas um preset por repositorio consumidor. Neste caso, o preset frontend deve ser o unico ativo para evitar conflito de ownership.

## Escopo de customizacao

### Templates sobrescritos

- `spec-template`
- `plan-template`
- `tasks-template`
- `checklist-template`

### Comandos sobrescritos

- `speckit.specify`
- `speckit.clarify`
- `speckit.plan`
- `speckit.tasks`
- `speckit.implement`
- `speckit.checklist`
- `speckit.mrv-aidd-producao.sincronizar-us-devops`

### Comportamento aplicado

- define ownership frontend com tags `[FRONT]`;
- preserva historias owned pelo backend;
- gera handoff quando necessario;
- mantem mensagens e artefatos em portugues do Brasil.

## Quando usar

Use este preset quando o repositorio consumidor for majoritariamente frontend e precisar:

- conduzir o fluxo principal do spec sob responsabilidade de frontend;
- manter rastreabilidade com Azure DevOps sem perder o contexto da outra ponta;
- gerar artefatos padronizados para o time em pt-BR.

## Dependencia

Este preset depende da extension [`mrv-aidd-producao`](../../extensions/mrv-aidd-producao/README.md) para o fluxo operacional de sincronizacao, configuracao de US e encerramento.

## Veja tambem

- [README da plataforma](../../README.md)
- [Extension base](../../extensions/mrv-aidd-producao/README.md)
- [Preset backend](../../presets/mrv-aidd-producao-backend/README.md)
- [Guia de instalacao](../../docs/guia-instalacao.md)
- [Guia de contribuicao](../../docs/guia-contribuicao.md)
