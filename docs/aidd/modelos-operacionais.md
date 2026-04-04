# Modelos Operacionais e Convenções Reutilizáveis do AIDD

Este guia funciona como referência rápida para quem já entendeu o fluxo e quer ver exemplos de como os artefatos devem ficar na prática. Ele não substitui os templates instalados pelos presets nem redefine o processo.

- As definições canônicas de fluxo, gates, artefatos e guardrails estão em [README.md](./README.md).
- Se você ainda está tentando entender a diferença entre Spec Kit, plataforma e AIDD, veja [../../README.md](../../README.md) e [README.md](./README.md) primeiro.

---

## Índice

- [Templates oficiais do framework](#templates-oficiais-do-framework)
- [Organização recomendada dos artefatos](#organização-recomendada-dos-artefatos)
- [Modelo de spec funcional](#modelo-de-spec-funcional)
- [Modelo de plan técnico](#modelo-de-plan-técnico)
- [Modelo de tasks macro da feature](#modelo-de-tasks-macro-da-feature)
- [Modelo de tasks por US assumida](#modelo-de-tasks-por-us-assumida)
- [Convenções rápidas de branch e PR](#convenções-rápidas-de-branch-e-pr)
- [Convenções rápidas para board e rastreabilidade](#convenções-rápidas-para-board-e-rastreabilidade)
- [Alinhamento com o diagrama oficial](#alinhamento-com-o-diagrama-oficial)
- [Exemplo de board coerente](#exemplo-de-board-coerente)
- [Sinais rápidos de aderência](#sinais-rápidos-de-aderência)

---

## Templates oficiais do framework

| Papel          | Backend                                                         | Frontend                                                         |
| -------------- | --------------------------------------------------------------- | ---------------------------------------------------------------- |
| Spec funcional | `presets/mrv-aidd-producao-backend/templates/spec-template.md`  | `presets/mrv-aidd-producao-frontend/templates/spec-template.md`  |
| Plan técnico   | `presets/mrv-aidd-producao-backend/templates/plan-template.md`  | `presets/mrv-aidd-producao-frontend/templates/plan-template.md`  |
| Tasks macro    | `presets/mrv-aidd-producao-backend/templates/tasks-template.md` | `presets/mrv-aidd-producao-frontend/templates/tasks-template.md` |

---

## Organização recomendada dos artefatos

```text
specs/001-minha-feature/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── contrato-principal.md
└── tasks.md
```

---

## Modelo de spec funcional

O spec deve afirmar claramente:

- A feature de upstream é a entrada principal, mas não a verdade final do fluxo.
- O downstream clarificou o que precisava e fechou gaps relevantes antes de validar o spec.
- Cada história é testável de forma independente.
- Ownership e rastreabilidade estão explícitos.

Trecho modelo:

```md
## Guardrails AIDD

- A feature de upstream é a entrada principal desta especificação, mas pode conter gaps funcionais.
- Este fluxo deve clarificar e fechar os gaps relevantes antes de validar o `spec.md`.
- Este `spec.md` é a fonte de verdade funcional consolidada da feature.
- O board deve espelhar as USs derivadas deste spec validado.

## Cenários de usuário e testes

### História de Usuário 1 - [BACK] Calcular simulação (Prioridade: P1)

**Ownership Scope**: backend
**Teste independente**: chamar a simulação com payload válido e receber parcelas coerentes.
```

---

## Modelo de plan técnico

O plan deve afirmar claramente:

- Qual fundação compartilhada desbloqueia o restante.
- Quais contratos, schemas e componentes são compartilhados.
- Onde o paralelismo é seguro ou inseguro.
- Qual é o commitment por US.
- Como o planning das USs publicadas afeta a ordem e a trilha de execução.

Trecho modelo:

```md
## Guardrails AIDD

- Este `plan.md` é a fonte de verdade técnica da feature.
- O plano detalha o recorte técnico a partir do `spec.md` validado.
- O plano não reescreve escopo funcional; ele especifica como executar com segurança.

## Commitment e recorte operacional

- **US1 desbloqueia**: contrato `ParcelSimulationResponse`.
- **US2 depende de**: endpoint criado em `US1`.
- **Paralelismo seguro**: US3 pode correr em paralelo depois da entrega do contrato.
```

---

## Modelo de tasks macro da feature

O `tasks.md` é o macroplanejamento da feature, organizado por US.

Trecho modelo:

```md
## Guardrails AIDD

- Este arquivo organiza a feature por US.
- `/tasks` e `/implement` operam por US assumida e com escopo explícito.
- Sem escopo explícito, o agente tende a decompor a feature inteira.

## Recorte operacional desta execução

- **USs em foco nesta execução**: US2
- **Branch recomendada**: `feature/001-minha-feature/us2`
- **Regra**: atualizar apenas as seções da US assumida e preservar as demais.
```

---

## Modelo de tasks por US assumida

Embora o `tasks.md` seja macro, a execução deve acontecer em recorte por US.

Exemplo de recorte correto:

```text
US em foco: US2
Objetivo: Implementar endpoint de simulação
Arquivos-alvo: src/api/simulacao.ts, tests/integration/simulacao.test.ts
Bloqueios compartilhados: contrato `ParcelSimulationResponse` já entregue em US1
```

---

## Convenções rápidas de branch e PR

| Item                          | Convenção                                    |
| ----------------------------- | -------------------------------------------- |
| Branch integradora da feature | `001-nome-da-feature`                        |
| Branch da US                  | `feature/<feature-branch>/usN`               |
| PR da US                      | branch da US → branch integradora da feature |
| PR final                      | branch integradora da feature → `main`       |

### Título recomendado de PR da US

```text
[US2] Expor endpoint de simulação de parcelas
```

### Título recomendado de commit da US

```text
feature AB#12345: expor endpoint de simulacao de parcelas
```

---

## Convenções rápidas para board e rastreabilidade

| Elemento                 | Regra                                                          |
| ------------------------ | -------------------------------------------------------------- |
| Feature no board         | Representa a feature do `spec.md` validado                     |
| US no board              | Deriva do `spec.md` e carrega ownership explícito              |
| Projeção FE/BE           | Pode existir no board desde que derive do mesmo spec funcional |
| Campo de rastreabilidade | ID do work item deve voltar para o `spec.md`                   |
| Ordem de publicação      | Primeiro spec validado, depois board, depois plan              |

---

## Alinhamento com o diagrama oficial

Para ficar coerente com o diagrama em [diagrama-aidd.png](./diagrama-aidd.png), os textos e exemplos devem preservar estes marcos:

- `Imersao no problema`
- `Mapeamento de features`
- `Prototipos UX`
- `Prototipo da feature validado`
- `Feature framing fechado`
- `Ready para tecnico`
- `Loop SDD de implementacao`

---

## Exemplo de board coerente

```text
Feature: Parametrização de descontos por campanha
US1 [BACK]: Criar contrato e regra de desconto
US2 [BACK]: Expor endpoint de simulação
US3 [FRONT]: Exibir simulação na tela de proposta
```

## Exemplo de board incoerente

```text
Feature no board criada diretamente a partir do texto bruto do upstream
USs sem referência ao spec validado
Stories técnicas inventadas fora do recorte funcional
```

---

## Sinais rápidos de aderência

- O spec é único e está claro.
- O plan não discute objetivo de negócio, apenas desenho técnico.
- O board bate com o spec.
- Cada dev sabe qual US assumiu.
- O agente recebe escopo explícito ao gerar tasks e implementar.
