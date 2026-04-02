# Preset MRV AIDD Producao Backend

Preset plug and play para repositorios de backend da MRV que usam AIDD com Spec Kit.

## Objetivo

Reunir em um unico preset de backend:

- artefatos em portugues do Brasil
- ownership de backend
- rastreabilidade Azure DevOps
- handoff controlado para frontend
- orientacao de branch por US usando a extensao `mrv-aidd-producao`

## Instalacao local

```powershell
specify preset add --dev .\presets\mrv-aidd-producao-backend --priority 5
```

## Escopo

- Sobrescreve `spec-template`, `plan-template`, `tasks-template` e `checklist-template`.
- Sobrescreve `speckit.specify`, `speckit.clarify`, `speckit.plan`, `speckit.tasks`, `speckit.implement`, `speckit.checklist` e `speckit.mrv-aidd-producao.sincronizar-us-devops`.
- Define ownership backend com tags `[BACK]`.
- Preserva historias owned pelo frontend e gera handoff quando necessario.
- Mantem todas as mensagens e artefatos em portugues do Brasil.

## Dependencia

Use este preset em conjunto com a extensao `mrv-aidd-producao`.
