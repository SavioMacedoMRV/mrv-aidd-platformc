<div align="center">
<img src="../../media/mrv-aidd-platform.svg" alt="MRV AIDD Producao Frontend" width="120" />

    <h1>MRV AIDD Produção Frontend</h1>

    <h3>Preset para repositórios frontend da MRV com ownership em pt-BR, handoff controlado e rastreabilidade Azure DevOps.</h3>

    <p>
    <img src="https://img.shields.io/badge/type-preset-264D1F?style=for-the-badge" alt="Type preset" />
    <img src="https://img.shields.io/badge/foco-frontend-F7941D?style=for-the-badge" alt="Foco frontend" />
    <img src="https://img.shields.io/badge/templates-4-7FB239?style=for-the-badge" alt="4 templates" />
    <img src="https://img.shields.io/badge/comandos-7-0C1A0E?style=for-the-badge" alt="7 comandos" />
    </p>

</div>

---

## Índice

- [O que este preset faz](#o-que-este-preset-faz)
- [Quando usar](#quando-usar)
- [Instalação](#instalação)
- [Escopo de customização](#escopo-de-customização)
- [Comportamento aplicado](#comportamento-aplicado)
- [Dependência](#dependência)
- [Veja também](#veja-também)

---

## O que este preset faz

Este preset adapta a experiência do Spec Kit para o contexto de frontend da MRV. Ele não cria capacidades novas. Ele muda templates, comandos e linguagem operacional para que o ownership frontend seja o centro do fluxo naquele repositório consumidor.

O preset `mrv-aidd-producao-frontend` concentra em um único pacote:

- Artefatos em português do Brasil.
- Ownership principal de frontend.
- Rastreabilidade Azure DevOps no fluxo de especificação.
- Handoff controlado para backend.
- Orientação de branch por US em conjunto com a extension da plataforma.

---

## Quando usar

Use este preset quando o repositório consumidor for majoritariamente frontend e precisar:

- Conduzir o fluxo principal do spec sob responsabilidade de frontend.
- Manter rastreabilidade com Azure DevOps sem perder o contexto da outra ponta.
- Gerar artefatos padronizados para o time em pt-BR.

---

## Instalação

Antes de instalar este preset, o repositório consumidor precisa ter a extension `mrv-aidd-producao` e uma base funcional de Spec Kit.

### Via catálogo MRV

```powershell
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
specify extension add mrv-aidd-producao
specify preset add mrv-aidd-producao-frontend --priority 5
```

### Via desenvolvimento local

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

Instale apenas um preset por repositório consumidor.

---

## Escopo de customização

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

---

## Comportamento aplicado

- Define ownership frontend com tags `[FRONT]`.
- Preserva histórias owned pelo backend.
- Gera handoff quando necessário.
- Mantém mensagens e artefatos em pt-BR.

---

## Dependência

Este preset depende da extension `mrv-aidd-producao` para sincronização, configuração de US e encerramento. Instale a extension antes de instalar este preset.

---

## Veja também

- [../../README.md](../../README.md)
- [../../docs/guia-instalacao.md](../../docs/guia-instalacao.md)
- [../../extensions/mrv-aidd-producao/README.md](../../extensions/mrv-aidd-producao/README.md)
- [../mrv-aidd-producao-backend/README.md](../mrv-aidd-producao-backend/README.md)
