<div align="center">
  <img src="./media/mrv-aidd-platform.svg" alt="MRV AIDD Platform" width="168" />

  <h1>MRV AIDD Platform</h1>

  <h3>Catalogo compartilhado da MRV para estender o Spec Kit com fluxo operacional, presets plug and play e distribuicao versionada.</h3>

  <p>
    <a href="https://github.com/SavioMacedoMRV/mrv-aidd-platformc/releases/latest"><img src="https://img.shields.io/github/v/release/SavioMacedoMRV/mrv-aidd-platformc?display_name=tag&style=for-the-badge&label=release" alt="Latest release" /></a>
    <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-7FB239?style=for-the-badge" alt="License MIT" /></a>
    <a href="https://github.com/github/spec-kit/releases"><img src="https://img.shields.io/badge/spec%20kit-%3E%3D0.4.4-F7941D?style=for-the-badge" alt="Spec Kit version" /></a>
    <img src="https://img.shields.io/badge/catalogo-1%20extension%20%2B%202%20presets-264D1F?style=for-the-badge" alt="Catalogo MRV" />
  </p>
</div>

O MRV AIDD Platform pega a base do Spec Kit e entrega um pacote mais pronto para o contexto operacional da MRV: sincronizacao com Azure DevOps via MCP, fluxo de branch por historia, encerramento de US com PR e presets em portugues do Brasil para backend e frontend.

Assim como o proprio Spec Kit, a ideia aqui nao e espalhar customizacao ad hoc por repositorio consumidor. A proposta e manter os componentes compartilhados em um catalogo versionado, com instalacao simples, comportamento previsivel e evolucao centralizada.

Navegacao rapida:

- [Extension MRV AIDD Producao](./extensions/mrv-aidd-producao/README.md)
- [Preset MRV AIDD Producao Backend](./presets/mrv-aidd-producao-backend/README.md)
- [Preset MRV AIDD Producao Frontend](./presets/mrv-aidd-producao-frontend/README.md)
- [Guia de Instalacao](./docs/guia-instalacao.md)
- [Guia de Contribuicao](./docs/guia-contribuicao.md)
- [Guia de Publicacao do Catalogo](./docs/publicacao-catalogo.md)

## Sumario

- O que e esta plataforma?
- Comece rapido
- Qual preset instalar
- O que acontece ao instalar
- O que existe no catalogo
- Como usar cada item do catalogo
- Como extension e preset se encaixam
- Quando usar cada pacote
- Cuidados operacionais
- Pre-requisitos
- Aprenda mais
- Licenca

## O que e esta plataforma?

Esta raiz e a base compartilhada da MRV para distribuir componentes reutilizaveis sobre o Spec Kit.

- Centraliza extensoes e presets que precisam ser mantidos de forma unificada.
- Publica assets zipados consumiveis por catalogo, sem depender de `--dev` para uso normal.
- Preserva ids publicos e portabilidade dos pacotes distribuidos para repositorios consumidores.
- Reduz duplicacao de instrucoes, templates e fluxos operacionais entre times.

Hoje o repositorio entrega uma extension operacional e dois presets plug and play:

- [`mrv-aidd-producao`](./extensions/mrv-aidd-producao/README.md): fluxo operacional MRV para Azure DevOps, branch e finalizacao de US.
- [`mrv-aidd-producao-backend`](./presets/mrv-aidd-producao-backend/README.md): preset com ownership backend e artefatos em pt-BR.
- [`mrv-aidd-producao-frontend`](./presets/mrv-aidd-producao-frontend/README.md): preset com ownership frontend e artefatos em pt-BR.

## Comece rapido

### 1. Garanta um repositorio consumidor com Spec Kit

Os componentes deste catalogo foram feitos para um projeto que ja usa o Spec Kit.

```powershell
specify check
```

Se o repositorio consumidor ainda nao estiver inicializado, prepare primeiro o projeto com o fluxo normal do Spec Kit.

### 2. Adicione os catalogos MRV

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
```

Depois disso, voce pode procurar e instalar os pacotes por nome.

```powershell
specify extension search mrv
specify preset search mrv
```

### 3. Instale a extension base e um preset

Backend:

```powershell
specify extension add mrv-aidd-producao
specify preset add mrv-aidd-producao-backend --priority 5
```

Frontend:

```powershell
specify extension add mrv-aidd-producao
specify preset add mrv-aidd-producao-frontend --priority 5
```

Use apenas um preset por repositorio consumidor. Os dois presets dependem da extension [`mrv-aidd-producao`](./extensions/mrv-aidd-producao/README.md).

### 4. Execute o fluxo recomendado

Depois da instalacao, o fluxo sugerido fica assim:

1. Execute `/speckit.specify` com o contexto da funcionalidade.
2. Execute `/speckit.clarify` para reduzir ambiguidade antes do plano.
3. Execute `/speckit.mrv-aidd-producao.sincronizar-us-devops` quando houver rastreabilidade com Azure DevOps.
4. Execute `/speckit.plan` quando o escopo estiver estabilizado.
5. Execute `/speckit.tasks` e `/speckit.implement` no fluxo normal do Spec Kit.
6. Use `/speckit.mrv-aidd-producao.configurar-us` e `/speckit.mrv-aidd-producao.terminar-us` para operar a US no fluxo MRV.

## Qual preset instalar

Instale apenas um preset por repositorio consumidor.

- Use [`mrv-aidd-producao-backend`](./presets/mrv-aidd-producao-backend/README.md) quando o repositorio for o owner principal das historias de backend.
- Use [`mrv-aidd-producao-frontend`](./presets/mrv-aidd-producao-frontend/README.md) quando o repositorio for o owner principal das historias de frontend.
- Se backend e frontend estiverem em repositorios diferentes, cada repositorio deve instalar apenas o preset correspondente ao proprio ownership.

## O que acontece ao instalar

Ao adicionar a extension [`mrv-aidd-producao`](./extensions/mrv-aidd-producao/README.md):

- os comandos `speckit.mrv-aidd-producao.sincronizar-us-devops`, `speckit.mrv-aidd-producao.configurar-us` e `speckit.mrv-aidd-producao.terminar-us` passam a ficar disponiveis;
- o arquivo de configuracao `mrv-aidd-producao-config.yml` passa a ser provisionado a partir do template do pacote;
- hooks opcionais podem sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.

Ao adicionar um preset:

- os templates `spec-template`, `plan-template`, `tasks-template` e `checklist-template` passam a ser substituidos;
- comandos nativos do fluxo `/speckit.*` passam a executar as versoes customizadas do preset;
- ownership, tags, idioma e handoff passam a seguir o contexto do preset instalado.

## O que existe no catalogo

### Extensions

| Pacote              | Papel                                                              | Categoria             | Efeito                                                    |
| ------------------- | ------------------------------------------------------------------ | --------------------- | --------------------------------------------------------- |
| `mrv-aidd-producao` | Fluxo operacional MRV para US, Azure DevOps, branch e encerramento | integration / process | Registra 3 comandos, 3 hooks e um arquivo de configuracao |

### Presets

| Pacote                       | Foco                        | O que customiza          | Dependencia         |
| ---------------------------- | --------------------------- | ------------------------ | ------------------- |
| `mrv-aidd-producao-backend`  | Ownership backend em pt-BR  | 4 templates e 7 comandos | `mrv-aidd-producao` |
| `mrv-aidd-producao-frontend` | Ownership frontend em pt-BR | 4 templates e 7 comandos | `mrv-aidd-producao` |

### URLs publicas do catalogo

- Extension catalog: `https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json`
- Preset catalog: `https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json`

Os downloads publicados hoje saem de uma release unica por versao da plataforma, com tres assets zipados separados.

## Como usar cada item do catalogo

### `mrv-aidd-producao`

Use esta extension quando voce precisa adicionar capacidade nova ao Spec Kit, e nao apenas mudar o formato dos artefatos.

Ela entrega:

- `/speckit.mrv-aidd-producao.sincronizar-us-devops`
- `/speckit.mrv-aidd-producao.configurar-us`
- `/speckit.mrv-aidd-producao.terminar-us`

Tambem registra hooks opcionais para sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.

Instalacao por catalogo:

```powershell
specify extension add mrv-aidd-producao
```

Instalacao local para desenvolvimento:

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
```

### `mrv-aidd-producao-backend`

Use este preset quando o repositorio consumidor tiver ownership principal de backend e precisar manter historias de frontend sem assumir todo o fluxo delas.

Ele:

- sobrescreve `spec-template`, `plan-template`, `tasks-template` e `checklist-template`;
- sobrescreve os comandos principais `/speckit.*` relevantes ao fluxo;
- aplica ownership backend com tags `[BACK]`;
- mantem os artefatos em portugues do Brasil.

Instalacao por catalogo:

```powershell
specify preset add mrv-aidd-producao-backend --priority 5
```

Instalacao local para desenvolvimento:

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-backend --priority 5
```

### `mrv-aidd-producao-frontend`

Use este preset quando o repositorio consumidor tiver ownership principal de frontend e precisar preservar o handoff para backend.

Ele:

- sobrescreve `spec-template`, `plan-template`, `tasks-template` e `checklist-template`;
- sobrescreve os comandos principais `/speckit.*` relevantes ao fluxo;
- aplica ownership frontend com tags `[FRONT]`;
- mantem os artefatos em portugues do Brasil.

Instalacao por catalogo:

```powershell
specify preset add mrv-aidd-producao-frontend --priority 5
```

Instalacao local para desenvolvimento:

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

## Como extension e preset se encaixam

O modelo segue a mesma ideia do Spec Kit: extensoes adicionam capacidades novas; presets mudam como essas capacidades se apresentam no dia a dia.

### Extensions adicionam capacidades novas

Use extension quando precisar de um comando novo, de uma integracao externa ou de hooks adicionais que nao existem no fluxo base.

Neste repositorio, `mrv-aidd-producao` encapsula o fluxo operacional da MRV para sincronizacao com Azure DevOps, preparacao de branch por US e encerramento de entrega.

### Presets customizam artefatos e instrucoes

Use preset quando quiser mudar como o Spec Kit produz specs, planos, tarefas e instrucoes, sem criar uma nova capacidade separada.

Os presets desta plataforma aplicam ownership, idioma pt-BR, handoff controlado e filtros de sincronizacao por contexto de backend ou frontend.

### Resolucao e registro

Seguindo o modelo do Spec Kit:

1. Templates locais em `.specify/templates/overrides/` tem prioridade maxima no projeto consumidor.
2. Presets instalados resolvem templates por prioridade.
3. Templates fornecidos por extensions entram abaixo dos presets.
4. Templates core do Spec Kit ficam como fallback.

Comandos e overrides sao aplicados no momento da instalacao. Ou seja, quando voce instala um preset ou extension, o Spec Kit escreve os comandos nos diretorios do agente detectado.

## Quando usar cada pacote

| Necessidade                                            | Pacote recomendado           |
| ------------------------------------------------------ | ---------------------------- |
| Adicionar um comando novo ou um fluxo novo             | `mrv-aidd-producao`          |
| Integrar Azure DevOps, GitHub ou outro sistema externo | `mrv-aidd-producao`          |
| Aplicar ownership backend em pt-BR                     | `mrv-aidd-producao-backend`  |
| Aplicar ownership frontend em pt-BR                    | `mrv-aidd-producao-frontend` |
| Mudar formato de spec, plan, tasks ou checklist        | Um dos presets               |
| Desenvolver ou validar os pacotes desta workspace      | Instalacao local com `--dev` |

## Cuidados operacionais

- O modo catalogo depende de releases zipadas publicadas com as URLs declaradas em `extensions/catalog.json` e `presets/catalog.json`.
- O comando de sincronizacao nao cria a Feature pai no Azure DevOps. Ela deve existir antes.
- O fluxo de Azure DevOps usa MCP exclusivamente. Nao substitua esse comportamento por Azure CLI, PAT ou REST bruto dentro dos comandos da plataforma.
- Se o ambiente nao tiver autenticacao ou MCP configurado, os comandos dependentes vao falhar cedo e o ajuste deve ser feito antes de insistir no fluxo.

## Pre-requisitos

- `specify` instalado e funcional no ambiente.
- Repositorio consumidor ja preparado para usar Spec Kit.
- Git disponivel no ambiente.
- Para sincronizacao com Azure DevOps: autenticacao e MCP do Azure DevOps configurados, com a Feature pai ja existente.
- Para encerramento automatizado de US com PR: MCPs do GitHub disponiveis no ambiente do agente.

## Aprenda mais

- [docs/guia-instalacao.md](./docs/guia-instalacao.md): referencia detalhada de instalacao, efeitos da configuracao e cuidados de uso.
- [docs/guia-contribuicao.md](./docs/guia-contribuicao.md): guia para evoluir extensions e presets sem quebrar compatibilidade.
- [docs/publicacao-catalogo.md](./docs/publicacao-catalogo.md): guia para publicar releases zipadas e operar este repositorio como catalogo MRV.
- [extensions/mrv-aidd-producao/README.md](./extensions/mrv-aidd-producao/README.md): detalhes operacionais da extension.
- [presets/mrv-aidd-producao-backend/README.md](./presets/mrv-aidd-producao-backend/README.md): detalhes do preset de backend.
- [presets/mrv-aidd-producao-frontend/README.md](./presets/mrv-aidd-producao-frontend/README.md): detalhes do preset de frontend.

## Licenca

Este projeto e distribuido sob a licenca MIT. Veja `LICENSE` para os termos completos.
