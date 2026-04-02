# MRV AIDD Platform

### Componentes compartilhados da MRV para estender o Spec Kit com fluxo operacional de producao.

Este repositorio consolida a base compartilhada de componentes de AIDD da MRV.

Nesta fase inicial, a plataforma concentra extensoes e presets reaproveitaveis. A estrutura tambem foi preparada para evoluir, quando fizer sentido, com skills, diretivas, templates e outros padroes compartilhados do time.

## Sumario

- O que e esta plataforma?
- Comece rapido
- Extensoes disponiveis
- Presets disponiveis
- Como o toolkit funciona
- Quando usar extension ou preset
- Pre-requisitos
- Aprenda mais

## O que e esta plataforma?

Esta raiz e a base compartilhada da MRV para distribuir componentes reutilizaveis sobre o Spec Kit.

- Centraliza ativos de plataforma que precisam ser mantidos de forma unificada.
- Preserva compatibilidade e portabilidade dos pacotes distribuidos para repositorios consumidores.
- Reduz acoplamentos com repositorios antigos, caminhos locais e customizacoes pontuais de consumo.
- Serve como ponto de evolucao para extensoes, presets e futuros componentes compartilhados.

Estrutura atual:

```text
docs/
  guia-contribuicao.md
  guia-instalacao.md
extensions/
  mrv-aidd-producao/
presets/
  mrv-aidd-producao-backend/
  mrv-aidd-producao-frontend/
README.md
```

## Comece rapido

### 1. Garanta um repositorio consumidor com Spec Kit

Este repositorio publica componentes para serem instalados em um projeto que ja use o Spec Kit.

```powershell
specify check
```

Se o repositorio consumidor ainda nao estiver inicializado com o Spec Kit, inicialize antes de instalar extension e preset.

### 2. Escolha o modo de consumo

Existem dois modos validos.

#### Modo catalogo MRV

Este e o modo indicado para quem quer apenas usar os componentes publicados.

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
specify preset add mrv-aidd-producao-backend --priority 5
```

Para frontend, troque o preset por `mrv-aidd-producao-frontend`.

#### Modo desenvolvimento local

Este e o modo indicado para quem esta evoluindo ou validando os pacotes direto desta workspace.

Comandos validados com `specify extension add --help` e `specify preset add --help`:

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-backend --priority 5
```

Ou, para frontend:

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

Na extension, `--dev` funciona como flag e o caminho local entra como argumento posicional. No preset, `--dev` recebe explicitamente o caminho local. Instale apenas um preset por repositorio consumidor.

### 3. Execute o fluxo recomendado

1. Execute `/speckit.specify` com o contexto da funcionalidade.
2. Execute `/speckit.clarify` para reduzir ambiguidade.
3. Execute `/speckit.mrv-aidd-producao.sincronizar-us-devops` quando houver rastreabilidade com Azure DevOps.
4. Execute `/speckit.plan` depois que o escopo estiver estabilizado.
5. Execute `/speckit.tasks` e `/speckit.implement` no fluxo normal do Spec Kit.

## Extensoes disponiveis

As extensions adicionam capacidades novas ao Spec Kit.

| ID                  | Papel                                                              | Efeito                                                              |
| ------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------- |
| `mrv-aidd-producao` | Fluxo operacional MRV para US, Azure DevOps, branch e encerramento | Registra comandos adicionais, hooks e configuracao de sincronizacao |

### `mrv-aidd-producao`

- Adiciona os comandos `/speckit.mrv-aidd-producao.sincronizar-us-devops`, `/speckit.mrv-aidd-producao.configurar-us` e `/speckit.mrv-aidd-producao.terminar-us`.
- Registra hooks opcionais para sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.
- Provisiona `mrv-aidd-producao-config.yml` a partir do template do pacote.

## Presets disponiveis

Os presets customizam como o fluxo do Spec Kit se comporta sem adicionar uma nova capacidade independente.

| ID                           | Escopo                                          | O que sobrescreve                                       |
| ---------------------------- | ----------------------------------------------- | ------------------------------------------------------- |
| `mrv-aidd-producao-backend`  | Ownership backend, pt-BR, handoff para frontend | Templates principais e comandos `/speckit.*` relevantes |
| `mrv-aidd-producao-frontend` | Ownership frontend, pt-BR, handoff para backend | Templates principais e comandos `/speckit.*` relevantes |

### `mrv-aidd-producao-backend`

- Sobrescreve `spec-template`, `plan-template`, `tasks-template` e `checklist-template`.
- Sobrescreve `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist` e `speckit.mrv-aidd-producao.sincronizar-us-devops`.
- Define ownership backend com tags `[BACK]` e preserva historias de frontend.

### `mrv-aidd-producao-frontend`

- Sobrescreve `spec-template`, `plan-template`, `tasks-template` e `checklist-template`.
- Sobrescreve `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist` e `speckit.mrv-aidd-producao.sincronizar-us-devops`.
- Define ownership frontend com tags `[FRONT]` e preserva historias de backend.

## Como o toolkit funciona

O toolkit atual combina dois mecanismos complementares do Spec Kit.

### Extensions adicionam capacidades novas

Use extension quando precisar de um comando novo, de uma integracao externa ou de hooks adicionais que nao existem no fluxo base.

Neste repositorio, a extension `mrv-aidd-producao` encapsula o fluxo operacional da MRV para sincronizacao com Azure DevOps, preparacao de branch por US e encerramento de entrega.

### Presets customizam artefatos e instrucoes

Use preset quando quiser mudar como o Spec Kit produz specs, planos, tarefas e instrucoes, sem criar uma nova capacidade separada.

Os presets deste repositorio aplicam ownership, idioma pt-BR, handoff controlado e filtros de sincronizacao por contexto de backend ou frontend.

### Resolucao e registro

Seguindo o modelo do Spec Kit:

1. Templates locais em `.specify/templates/overrides/` tem prioridade maxima no projeto consumidor.
2. Presets instalados resolvem templates por prioridade.
3. Templates fornecidos por extensions entram abaixo dos presets.
4. Templates core do Spec Kit ficam como fallback.

Overrides de comando sao aplicados no momento da instalacao. Ou seja, quando voce instala um preset ou extension, os comandos sao registrados nos diretórios do agente detectado pelo Spec Kit.

## Quando usar extension ou preset

| Necessidade                                                  | Use       |
| ------------------------------------------------------------ | --------- |
| Adicionar um comando novo ou um fluxo novo                   | Extension |
| Integrar Azure DevOps, GitHub ou outro sistema externo       | Extension |
| Mudar formato de spec, plan, tasks ou checklist              | Preset    |
| Aplicar ownership backend/frontend ou regras organizacionais | Preset    |
| Localizar o fluxo para pt-BR sem criar nova capacidade       | Preset    |

## Pre-requisitos

- `specify` instalado e funcional no ambiente.
- Repositorio consumidor ja preparado para usar Spec Kit.
- Git disponivel no ambiente.
- Para sincronizacao com Azure DevOps: autenticacao e MCP do Azure DevOps configurados, com a Feature pai ja existente.
- Para encerramento automatizado de US com PR: MCPs do GitHub disponiveis no ambiente do agente.

## Aprenda mais

- `docs/guia-instalacao.md`: guia de consumo, instalacao e fluxo de uso.
- `docs/guia-contribuicao.md`: guia para evoluir extensions e presets sem quebrar compatibilidade.
- `docs/publicacao-catalogo.md`: guia para publicar releases zipadas e operar este repositorio como catalogo MRV.
- `extensions/mrv-aidd-producao/README.md`: detalhes operacionais da extension.
- `presets/mrv-aidd-producao-backend/README.md`: detalhes do preset de backend.
- `presets/mrv-aidd-producao-frontend/README.md`: detalhes do preset de frontend.

## Restricoes importantes

- O comando de sincronizacao usa apenas MCP. Ele nao deve usar Azure CLI, PATs nem chamadas REST brutas para criar ou atualizar work items.
- A Feature pai ja deve existir no Azure DevOps.
- O usuario deve estar autenticado e com o servidor MCP do Azure DevOps configurado no ambiente do agente.
- Os ids publicos atuais dos pacotes devem ser preservados, salvo necessidade tecnica clara e plano de migracao.
