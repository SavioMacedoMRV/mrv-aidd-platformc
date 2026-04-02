# Preset MRV AIDD Producao Frontend

Preset plug and play para repositorios de frontend da MRV que usam AIDD com Spec Kit.

## Objetivo

Reunir em um unico preset de frontend:

- artefatos em portugues do Brasil
- ownership de frontend
- rastreabilidade Azure DevOps
- handoff controlado para backend
- orientacao de branch por US usando a extensao `mrv-aidd-producao`

## Instalacao local

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

## Escopo

- Sobrescreve `spec-template`, `plan-template`, `tasks-template` e `checklist-template`.
- Sobrescreve `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist` e `speckit.mrv-aidd-producao.sincronizar-us-devops`.
- Define ownership frontend com tags `[FRONT]`.
- Preserva historias owned pelo backend e gera handoff quando necessario.
- Mantem todas as mensagens e artefatos em portugues do Brasil.

## Dependencia

Use este preset em conjunto com a extensao `mrv-aidd-producao`.
