<div align="center">
<img src="../../media/mrv-aidd-platform.svg" alt="MRV AIDD Producao" width="120" />

    <h1>MRV AIDD Produção</h1>

    <h3>Extension operacional da MRV para o Spec Kit: sincronização com Azure DevOps, preparo de branch por US e encerramento com PR.</h3>

    <p>
    <img src="https://img.shields.io/badge/type-extension-264D1F?style=for-the-badge" alt="Type extension" />
    <img src="https://img.shields.io/badge/comandos-4-F7941D?style=for-the-badge" alt="4 comandos" />
    <img src="https://img.shields.io/badge/hooks-3-7FB239?style=for-the-badge" alt="3 hooks" />
    <img src="https://img.shields.io/badge/spec%20kit-%3E%3D0.5.0-0C1A0E?style=for-the-badge" alt="Spec Kit version" />
    </p>

</div>

---

## Índice

- [O que esta extension faz](#o-que-esta-extension-faz)
- [Quando usar](#quando-usar)
- [Instalação](#instalação)
- [Comandos disponíveis](#comandos-disponíveis)
- [Pré-requisitos](#pré-requisitos)
- [Artefatos e efeitos gerados](#artefatos-e-efeitos-gerados)
- [Relação com os presets](#relação-com-os-presets)
- [Veja também](#veja-também)

---

## O que esta extension faz

Esta extension adiciona capacidade nova ao fluxo do Spec Kit. Se você quer mudar templates, ownership ou linguagem, você quer um preset. Se você quer adicionar integração, hooks ou comportamento novo, você quer esta extension.

Ao instalar `mrv-aidd-producao`, o projeto consumidor passa a ter:

- `/speckit.mrv-aidd-producao.sincronizar-us-devops`
- `/speckit.mrv-aidd-producao.configurar-us`
- `/speckit.mrv-aidd-producao.terminar-us`
- `/speckit.mrv-aidd-producao.configurar-maestro`

Ela também registra hooks opcionais para sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.

---

## Quando usar

Use esta extension quando o fluxo precisar:

- Sincronizar histórias com Azure DevOps via MCP.
- Preparar a branch correta da US assumida.
- Encerrar a US com commit, push e PR no padrão esperado.
- Configurar o repositório como maestro para cenários multi-repo (front + back separados).

---

## Instalação

Antes de instalar esta extension, o repositório consumidor precisa estar inicializado com Spec Kit. Se isso ainda não aconteceu, veja [../../README.md](../../README.md) e [../../docs/guia-instalacao.md](../../docs/guia-instalacao.md).

### Via catálogo MRV

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
```

### Via desenvolvimento local

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
```

Ao instalar, a extension registra automaticamente seus hooks em `.specify/extensions.yml` e provisiona o arquivo de configuração do pacote para o repositório consumidor.

---

## Comandos disponíveis

### `/speckit.mrv-aidd-producao.sincronizar-us-devops`

Use quando precisar sincronizar histórias do spec com o Azure DevOps, criando a hierarquia Épico → Feature → USs.

- Suporta `--dry-run` para validar rastreabilidade, leitura, deduplicação e ações previstas sem gravar work items.
- Resolve o Épico pai no Azure DevOps.
- Cria a Feature como filha do Épico quando ela não existe; reutiliza quando já existe.
- Cria ou atualiza histórias de usuário como filhas da Feature.
- Escreve no `spec.md` o campo `ID da US no Azure DevOps` em cada história sincronizada.

### `/speckit.mrv-aidd-producao.configurar-us USn`

Use quando for iniciar o trabalho operacional de uma história específica.

- Cria ou reutiliza a branch `feature/<feature-branch>/usN`.
- Oculta USs concluídas ao perguntar o escopo.
- Resolve a US principalmente a partir do `spec.md`.
- Move a US selecionada para `DEV` no Azure DevOps quando houver work item identificado.

### `/speckit.mrv-aidd-producao.terminar-us USn`

Use quando a US atual estiver pronta para sair da branch de trabalho e seguir para PR.

- Executa validações finais.
- Gera commit no padrão `feature AB#<workItemId>: ...`.
- Faz push da branch.
- Abre a PR para a branch base da feature usando os MCPs do GitHub.

### `/speckit.mrv-aidd-producao.configurar-maestro`

Use quando o time operar com repositórios separados de frontend e backend para a mesma feature e quiser centralizar a especificação em um único repositório (maestro).

- Detecta o preset instalado para determinar o ownership do maestro.
- Pergunta via `vscode_askQuestions` qual é o repositório pareado.
- Valida que o repositório pareado possui `.specify/` inicializado.
- Persiste `maestro-config.json` em `.specify/extensions/mrv-aidd-producao/`.
- Após configuração, `/speckit.specify` passa a gerar USs de ambos os ownerships (dual-ownership).
- Após configuração, `/sincronizar-us-devops` passa a replicar automaticamente `spec.md` e `contracts/` para o repositório pareado.

---

## Pré-requisitos

- O spec ativo contém o link ou o ID do Épico pai na seção `Rastreabilidade Azure DevOps`.
- O usuário está autenticado e o servidor MCP do Azure DevOps está configurado no ambiente do agente.
- Para a etapa de PR, os MCPs do GitHub precisam estar disponíveis no ambiente.

---

## Artefatos e efeitos gerados

| Artefato / Efeito                       | Quando                       |
| --------------------------------------- | ---------------------------- |
| Feature criada no Azure DevOps          | Após `sincronizar-us-devops` |
| Work items filhos no Azure DevOps       | Após `sincronizar-us-devops` |
| IDs de work items escritos no `spec.md` | Após `sincronizar-us-devops` |
| Spec e contratos replicados (maestro)   | Após `sincronizar-us-devops` |
| Branch `feature/<feature>/usN`          | Após `configurar-us`         |
| US movida para `DEV` no board           | Após `configurar-us`         |
| `maestro-config.json` salvo             | Após `configurar-maestro`    |
| Commit no padrão `feature AB#...`       | Após `terminar-us`           |
| Push da branch                          | Após `terminar-us`           |
| PR aberta na branch base da feature     | Após `terminar-us`           |

---

## Relação com os presets

Esta extension entrega a capacidade operacional base. Os presets `mrv-aidd-producao-backend` e `mrv-aidd-producao-frontend` customizam como essa capacidade é vivida — sobrescrevendo templates, comandos e linguagem para o ownership de cada repositório consumidor.

Instale a extension sempre antes de instalar um preset.

---

## Veja também

- [../../README.md](../../README.md)
- [../../docs/guia-instalacao.md](../../docs/guia-instalacao.md)
- [../../presets/mrv-aidd-producao-backend/README.md](../../presets/mrv-aidd-producao-backend/README.md)
- [../../presets/mrv-aidd-producao-frontend/README.md](../../presets/mrv-aidd-producao-frontend/README.md)
