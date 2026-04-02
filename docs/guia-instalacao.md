# Guia de Instalacao e Uso

Este guia e para quem quer consumir o toolkit atual da plataforma MRV AIDD sem precisar estudar a estrutura interna dos pacotes.

## O que o repositorio entrega hoje

O repositorio publica tres componentes reutilizaveis sobre o Spec Kit:

| Tipo      | ID                           | Quando usar                                                            | O que instala                                                    |
| --------- | ---------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------- |
| Extension | `mrv-aidd-producao`          | Sempre que o repositorio precisar do fluxo operacional MRV de producao | Comandos adicionais, hooks e arquivo de configuracao da extensao |
| Preset    | `mrv-aidd-producao-backend`  | Repositorios com ownership principal de backend                        | Overrides de comandos `/speckit.*` e templates de artefatos      |
| Preset    | `mrv-aidd-producao-frontend` | Repositorios com ownership principal de frontend                       | Overrides de comandos `/speckit.*` e templates de artefatos      |

## Como extension e preset se complementam

- A extension adiciona capacidades novas ao toolkit base.
- O preset adapta o fluxo nativo do Spec Kit para um contexto de time ou stack.
- Neste repositorio, o desenho esperado e instalar a extension `mrv-aidd-producao` junto com exatamente um preset.

## Pre-requisitos

- Ter o Spec Kit disponivel no ambiente onde o repositorio consumidor sera configurado.
- Ter acesso ao workspace local com este repositorio clonado quando for instalar em modo `--dev`.
- Para usar a sincronizacao com Azure DevOps, estar autenticado e com o MCP do Azure DevOps configurado.
- Para usar o encerramento automatizado de US, ter os MCPs necessarios para GitHub disponiveis no ambiente do agente.

## Modos de instalacao

### Modo catalogo MRV

Use este modo quando o objetivo for apenas consumir os componentes publicados, sem depender desta workspace.

#### Backend

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
specify preset add mrv-aidd-producao-backend --priority 5
```

#### Frontend

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
specify preset add mrv-aidd-producao-frontend --priority 5
```

### Modo desenvolvimento local

Use este modo quando estiver criando, ajustando ou validando os pacotes a partir desta raiz.

## Ordem recomendada de instalacao

### Backend

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-backend --priority 5
```

### Frontend

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

## O que acontece ao instalar

Ao adicionar a extension `mrv-aidd-producao`:

- os comandos `speckit.mrv-aidd-producao.sincronizar-us-devops`, `speckit.mrv-aidd-producao.configurar-us` e `speckit.mrv-aidd-producao.terminar-us` passam a ficar disponiveis;
- o arquivo de configuracao `mrv-aidd-producao-config.yml` passa a ser provisionado a partir do template do pacote;
- hooks opcionais sao registrados para sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.

Ao adicionar um preset:

- os templates `spec-template`, `plan-template`, `tasks-template` e `checklist-template` passam a ser substituidos;
- comandos nativos do fluxo `/speckit.*` passam a executar as versoes customizadas do preset;
- ownership, tags, idioma e handoff passam a seguir o contexto do preset instalado.

## Qual preset instalar

Instale apenas um preset por repositorio consumidor.

- Use `mrv-aidd-producao-backend` quando o repositorio for o owner principal das historias de backend.
- Use `mrv-aidd-producao-frontend` quando o repositorio for o owner principal das historias de frontend.

Se houver backend e frontend em repositorios diferentes, cada repositorio deve instalar o preset correspondente ao proprio ownership.

## Fluxo recomendado depois da instalacao

1. Execute `/speckit.specify` para abrir a especificacao da funcionalidade no formato do preset.
2. Execute `/speckit.clarify` para eliminar ambiguidades importantes.
3. Execute `/speckit.mrv-aidd-producao.sincronizar-us-devops` quando houver rastreabilidade com Azure DevOps.
4. Execute `/speckit.plan` depois que o escopo estiver estabilizado.
5. Execute `/speckit.tasks` e `/speckit.implement` no fluxo normal do Spec Kit.

Durante esse fluxo:

- `configurar-us` pode ser sugerido antes de `tasks` e `implement` para preparar a branch `feature/<feature-branch>/usN`;
- `terminar-us` pode ser sugerido apos `implement` para validar, commitar, fazer push e abrir PR.

## O que cada componente faz

### Extension `mrv-aidd-producao`

- Sincroniza historias esclarecidas do `spec.md` com Azure DevOps como filhas de uma Feature existente.
- Grava ou atualiza o mapeamento local em `.specify/extensions/mrv-aidd-producao/us-sync-map.json`.
- Escreve de volta no `spec.md` o `ID da US no Azure DevOps` para cada historia sincronizada.
- Ajuda a preparar a branch de trabalho da US e a finalizar a entrega com commit e PR.

### Preset `mrv-aidd-producao-backend`

- Obriga ownership `backend`.
- Usa titulos e tags `[BACK]`.
- Preserva historias de frontend e registra dependencias em `Frontend Follow-up` quando necessario.
- Mantem os artefatos e prompts em portugues do Brasil.

### Preset `mrv-aidd-producao-frontend`

- Obriga ownership `frontend`.
- Usa titulos e tags `[FRONT]`.
- Preserva historias de backend e registra handoff para o repositorio correto.
- Mantem os artefatos e prompts em portugues do Brasil.

## Limitacoes e cuidados

- O modo catalogo depende de releases zipadas publicadas com as URLs declaradas em `extensions/catalog.json` e `presets/catalog.json`.
- O comando de sincronizacao nao cria a Feature pai. Ela deve existir antes.
- O fluxo de Azure DevOps usa MCP exclusivamente. Nao use Azure CLI, PAT ou REST bruto para substituir esse comportamento dentro do comando.
- Se o ambiente nao tiver autenticacao ou MCP configurado, os comandos dependentes devem falhar cedo e o ajuste deve ser feito antes de insistir no fluxo.

## Onde olhar se precisar de detalhe

- `docs/publicacao-catalogo.md`
- `extensions/mrv-aidd-producao/README.md`
- `extensions/mrv-aidd-producao/extension.yml`
- `presets/mrv-aidd-producao-backend/README.md`
- `presets/mrv-aidd-producao-backend/preset.yml`
- `presets/mrv-aidd-producao-frontend/README.md`
- `presets/mrv-aidd-producao-frontend/preset.yml`
