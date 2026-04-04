# Guia de Instalação e Uso em Repositório Consumidor

Este guia é para a jornada mais prática da plataforma: instalar os pacotes certos em um repositório consumidor e entender o que fica disponível depois disso.

- Para entender a plataforma antes de instalar, veja [../README.md](../README.md).
- Para entender o fluxo operacional, veja [./aidd/README.md](./aidd/README.md).

---

## Índice

- [Pré-requisitos](#pré-requisitos)
- [O que será instalado](#o-que-será-instalado)
- [Instalação via catálogo MRV](#instalação-via-catálogo-mrv)
- [Instalação local para desenvolvimento da plataforma](#instalação-local-para-desenvolvimento-da-plataforma)
- [Como escolher o preset certo](#como-escolher-o-preset-certo)
- [O que muda depois da instalação](#o-que-muda-depois-da-instalação)
- [Fluxo operacional disponível](#fluxo-operacional-disponível)
- [Pré-requisitos de integração](#pré-requisitos-de-integração)
- [Armadilhas comuns](#armadilhas-comuns)
- [Próximo passo recomendado](#próximo-passo-recomendado)
- [Veja também](#veja-também)

---

## Pré-requisitos

O MRV AIDD Platform depende de uma base já inicializada com Spec Kit. Em um repositório consumidor, o mínimo esperado é:

- CLI `specify` funcional
- Projeto já inicializado com Spec Kit
- Git funcional no ambiente
- Agente compatível com os comandos instalados pelo Spec Kit

Validação mínima:

```powershell
specify check
```

Se o projeto ainda não foi inicializado, o caminho em Windows com GitHub Copilot é:

```powershell
specify init . --ai copilot --script ps
specify check
```

---

## O que será instalado

Para operar o fluxo MRV AIDD em um repositório consumidor, instale:

1. A extension `mrv-aidd-producao`
2. Exatamente um preset: backend **ou** frontend

Pense assim:

- A extension adiciona capacidade nova ao fluxo (comandos, hooks, integração com Azure DevOps).
- O preset customiza como esse fluxo é vivido pelo ownership daquele repositório (templates, linguagem, ownership).

---

## Instalação via catálogo MRV

Este é o caminho normal de consumo.

### 1. Adicione os catálogos

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
```

### 2. Instale a extension base

```powershell
specify extension add mrv-aidd-producao
```

### 3. Instale um único preset

**Backend:**

```powershell
specify preset add mrv-aidd-producao-backend --priority 5
```

**Frontend:**

```powershell
specify preset add mrv-aidd-producao-frontend --priority 5
```

Não instale os dois presets no mesmo repositório consumidor.

---

## Instalação local para desenvolvimento da plataforma

Use `--dev` apenas quando estiver evoluindo esta própria raiz, não quando estiver apenas consumindo a plataforma.

**Backend:**

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-backend --priority 5
```

**Frontend:**

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

---

## Como escolher o preset certo

### Use `mrv-aidd-producao-backend` quando

- O repositório for owner principal das histórias de backend.
- O spec, o plan e as tarefas precisarem ser governados pela trilha backend.
- Frontend existir como handoff, não como ownership principal desse repositório.

### Use `mrv-aidd-producao-frontend` quando

- O repositório for owner principal das histórias de frontend.
- O spec, o plan e as tarefas precisarem ser governados pela trilha frontend.
- Backend existir como handoff, não como ownership principal desse repositório.

---

## O que muda depois da instalação

### Ao instalar a extension `mrv-aidd-producao`

O repositório consumidor passa a ter:

- `/speckit.mrv-aidd-producao.sincronizar-us-devops`
- `/speckit.mrv-aidd-producao.configurar-us`
- `/speckit.mrv-aidd-producao.terminar-us`
- O arquivo de configuração `mrv-aidd-producao-config.yml`
- Hooks opcionais sugerindo configuração da US antes de `tasks` e `implement`, e encerramento depois de `implement`

### Ao instalar um preset

O repositório consumidor passa a usar:

- Templates customizados de `spec`, `plan`, `tasks` e `checklist`
- Overrides dos comandos core `/speckit.*`
- Linguagem operacional em pt-BR
- Ownership e handoff alinhados ao contexto backend ou frontend

---

## Fluxo operacional disponível

Depois da instalação, o fluxo recomendado é:

```text
/speckit.specify
/speckit.clarify
/speckit.mrv-aidd-producao.sincronizar-us-devops
/speckit.plan
/speckit.mrv-aidd-producao.configurar-us USn
/speckit.tasks USn
/speckit.implement USn
/speckit.mrv-aidd-producao.terminar-us USn
```

O racional desse fluxo está em [./aidd/README.md](./aidd/README.md).

---

## Pré-requisitos de integração

### Azure DevOps

Para a sincronização funcionar:

- O ambiente precisa ter MCP do Azure DevOps configurado.
- O usuário precisa estar autenticado.
- A Feature pai precisa existir antes da sincronização.
- O `spec.md` precisa carregar a rastreabilidade adequada.

### GitHub

Para `terminar-us` abrir PR automaticamente:

- Os MCPs do GitHub precisam estar disponíveis no ambiente.
- A branch da US precisa poder ser publicada no remoto.
- O fluxo do repositório consumidor precisa usar a branch base da feature como alvo da PR da US.

---

## Armadilhas comuns

- Instalar os dois presets no mesmo repositório consumidor.
- Tentar usar a plataforma sem um projeto já inicializado com Spec Kit.
- Instalar os pacotes nesta raiz achando que este repositório é o consumidor final.
- Rodar sincronização com Azure DevOps sem MCP autenticado.
- Esperar que a extension crie a Feature pai no Azure DevOps (ela não cria, só sincroniza).

---

## Próximo passo recomendado

Depois de instalar:

1. Leia [./aidd/README.md](./aidd/README.md) para entender o fluxo oficial.
2. Abra o README do pacote que você instalou.
3. Valide se o repositório consumidor vai operar como ownership backend ou frontend.
4. Rode o fluxo pela primeira vez com uma feature real e uma US assumida.

---

## Veja também

- [../README.md](../README.md)
- [./aidd/README.md](./aidd/README.md)
- [../extensions/mrv-aidd-producao/README.md](../extensions/mrv-aidd-producao/README.md)
- [../presets/mrv-aidd-producao-backend/README.md](../presets/mrv-aidd-producao-backend/README.md)
- [../presets/mrv-aidd-producao-frontend/README.md](../presets/mrv-aidd-producao-frontend/README.md)
