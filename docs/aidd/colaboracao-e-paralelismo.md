# Colaboração, Paralelismo e Trilhas Separadas no AIDD

Este guia cobre os cenários em que o fluxo precisa sair do caso simples de um dev, uma US e um único repositório. As regras canônicas do AIDD continuam em [README.md](./README.md). Aqui o foco é explicar como aplicar essas regras em cenários de paralelismo real, trilhas separadas e dependências cruzadas.

---

## Índice

- [Princípios invariantes](#princípios-invariantes)
- [Cenário 1: dois devs no mesmo repositório](#cenário-1-dois-devs-no-mesmo-repositório)
- [Quando o paralelismo é seguro](#quando-o-paralelismo-é-seguro)
- [Quando o paralelismo não é seguro](#quando-o-paralelismo-não-é-seguro)
- [Caso de foundation compartilhada](#caso-de-foundation-compartilhada)
- [Caso de colisão de arquivos compartilhados](#caso-de-colisão-de-arquivos-compartilhados)
- [Quando extrair foundation](#quando-extrair-foundation)
- [Exemplo de `/tasks` correto vs. errado](#exemplo-de-tasks-correto-vs-errado)
- [Cenário 2: FE e BE em repositórios ou trilhas separadas](#cenário-2-fe-e-be-em-repositórios-ou-trilhas-separadas)
- [Board e rastreabilidade com FE/BE separados](#board-e-rastreabilidade-com-febe-separados)
- [Foundation compartilhada entre FE e BE](#foundation-compartilhada-entre-fe-e-be)
- [Hotfix fora do fluxo normal](#hotfix-fora-do-fluxo-normal)
- [Checklist rápido de decisão](#checklist-rápido-de-decisão)

---

## Princípios invariantes

- `spec.md` continua único como verdade funcional da feature.
- `plan.md` continua técnico; ele não substitui o spec.
- O board espelha o spec validado.
- `/tasks` e `/implement` só podem operar por US assumida e com escopo explícito.
- Fundação compartilhada deve ser tratada antes do paralelismo real.

---

## Cenário 1: dois devs no mesmo repositório

### Como o framework trata

1. Existe uma branch integradora da feature, como `001-pagamento-recorrente`.
2. Existe um único `spec.md` para a feature inteira.
3. Existe um único `plan.md` descrevendo o recorte técnico, incluindo riscos de colisão e fundação compartilhada.
4. Cada dev assume explicitamente uma US distinta.
5. Cada dev trabalha em uma branch dedicada, como `feature/001-pagamento-recorrente/us1` e `feature/001-pagamento-recorrente/us2`.
6. Cada execução de `/speckit.tasks` informa a US em foco.
7. Cada execução de `/speckit.implement` informa a mesma US em foco.

### Exemplo concreto

- Dev A assume `US1 - [BACK] Criar contrato do motor de parcelamento`.
- Dev B assume `US2 - [BACK] Expor endpoint de simulação`.
- O `spec.md` continua único; ninguém cria um spec por dev.
- O `plan.md` continua único; ele registra que `US1` cria a fundação compartilhada do contrato.
- Dev A executa `/speckit.tasks US1` e depois `/speckit.implement US1`.
- Dev B executa `/speckit.tasks US2` e depois `/speckit.implement US2` somente depois de confirmar que a fundação de `US1` não bloqueia mais `US2`.

### Como o agente sabe qual US deve operar

O framework usa uma combinação de guardrails:

- O argumento do comando deve informar `US1`, `US2` ou referência equivalente.
- Se o usuário não informar, o prompt do preset manda perguntar explicitamente o escopo.
- `configurar-us` cria ou reutiliza a branch `feature/<feature-branch>/usN`.
- Os prompts de `/tasks` e `/implement` instruem o agente a não atuar fora da US informada.

---

## Quando o paralelismo é seguro

O paralelismo é seguro quando:

- As USs alteram arquivos diferentes ou fronteiras estáveis.
- Os contratos compartilhados já foram definidos.
- A fundação técnica bloqueante já foi entregue ou isolada.
- O `plan.md` deixou explícito o que depende de quem.

---

## Quando o paralelismo não é seguro

O paralelismo não é seguro quando:

- Duas USs precisam mexer na mesma base de schema, contrato, roteador central ou componente compartilhado ainda indefinido.
- Uma US depende da estrutura que ainda será criada por outra.
- A equipe ainda não extraiu a fundação compartilhada.
- O board aparenta independência, mas o `plan.md` mostra acoplamento técnico real.

---

## Caso de foundation compartilhada

### Exemplo

Feature: onboarding com análise antifraude.

- `US1`: criar contrato de risco e adaptador de antifraude.
- `US2`: expor endpoint de cadastro.
- `US3`: registrar status de risco no painel operacional.

Embora `US2` e `US3` pareçam independentes no board, ambas dependem do contrato e do modelo de risco. No AIDD, essa fundação entra em `US1` dentro do `tasks.md` e precisa estar desbloqueada antes do paralelismo real.

---

## Caso de colisão de arquivos compartilhados

### Exemplo

- Dev A quer alterar `src/domain/customer/customer.service.ts` para incluir validação nova.
- Dev B quer alterar o mesmo arquivo para incluir orquestração de notificação.

Mesmo com USs diferentes, o paralelismo não é seguro nesse arquivo. As opções corretas são:

1. Sequenciar as mudanças.
2. Extrair a responsabilidade compartilhada para um módulo novo antes.
3. Replanejar o recorte técnico no `plan.md`.

Anti-pattern: deixar cada dev alterar o mesmo arquivo central sem combinar ownership técnico.

---

## Quando extrair foundation

Extraia foundation compartilhada quando:

- O mesmo contrato, schema, evento ou componente será usado por duas ou mais USs.
- A mudança afeta observabilidade, auth, roteamento ou configuração base.
- A ausência desse bloco gera conflitos repetidos ou dependências ocultas.
- O custo de merge manual passa a competir com o custo de explicitar a base compartilhada.

---

## Exemplo de `/tasks` correto vs. errado

### Correto

```text
/speckit.tasks US2
```

Resultado esperado:

- O agente confirma `US2` como escopo.
- Preserva `US1` como fase inicial se ela carregar fundação compartilhada.
- Detalha apenas a US em foco e os pré-requisitos que realmente a afetam.
- Não inventa tarefas para a feature inteira fora do escopo informado.

### Errado — sem escopo explícito

```text
/speckit.tasks
```

Risco:

- O agente tende a decompor a feature inteira.
- Tarefas de várias USs ficam misturadas.
- Ownership por dev se perde.
- O board deixa de espelhar o recorte real de execução.

Comportamento esperado do framework: interromper e pedir a US em foco antes de continuar.

---

## Cenário 2: FE e BE em repositórios ou trilhas separadas

### Regra principal

Mesmo quando FE e BE vivem em repositórios diferentes, o modelo funcional continua sendo único. O ideal é que exista um `spec.md` funcional compartilhado como referência de negócio da feature.

### Como projetar nesse cenário

- O `spec.md` descreve a feature do ponto de vista funcional completo.
- As histórias podem ter ownership `frontend` ou `backend`.
- O board nasce do spec funcional validado e registra as USs separadas por ownership.
- Cada trilha pode ter seu próprio `plan.md` técnico se a separação de repositórios justificar.
- Contratos de integração devem ficar explícitos no plan das trilhas e, quando aplicável, em `contracts/`.

### Exemplo concreto

Feature: acompanhamento de entrega em tempo real.

- `US1 [BACK]`: publicar endpoint de tracking e evento de atualização.
- `US2 [FRONT]`: renderizar timeline e estados de entrega.

Fluxo:

1. PO + TL validam um spec funcional único.
2. O board publica ambas as USs a partir do mesmo spec.
3. O repositório de backend consome o preset backend e fecha seu `plan.md` técnico.
4. O repositório de frontend consome o preset frontend e fecha seu `plan.md` técnico.
5. O contrato de payload de tracking fica registrado e governado entre as duas trilhas.

---

## Board e rastreabilidade com FE/BE separados

- A Feature pai continua única.
- As USs podem ser separadas em FE e BE, mas continuam derivadas do mesmo spec funcional.
- O board não deve ter uma feature FE e outra BE descrevendo o mesmo problema de negócio.
- A rastreabilidade deve permitir ligar cada US ao mesmo spec funcional e, quando necessário, aos planos técnicos por trilha.

---

## Foundation compartilhada entre FE e BE

Foundation compartilhada entre repositórios diferentes geralmente aparece como contrato, schema, evento, combinação de erros, feature flag ou estratégia de rollout. Ela deve ser resolvida antes do paralelismo pleno entre as trilhas.

---

## Hotfix fora do fluxo normal

### Exemplo

Uma regressão crítica quebra o login em produção.

Nesse caso:

- Não se espera uma decomposição completa em spec, plan e tasks por várias USs.
- O time registra contexto mínimo, impacto, rollback e validação mínima.
- A correção usa um fluxo alternativo e controlado.
- O aprendizado volta para o AIDD depois da estabilização para melhorar prompts, harness e guardrails.

---

## Checklist rápido de decisão

- Existe um único `spec.md` para a feature? Se não, o modelo já está quebrado.
- O `plan.md` registrou fundação, colisão e contratos? Se não, o paralelismo está subgovernado.
- Cada dev sabe qual US assumiu? Se não, `/tasks` e `/implement` vão degradar.
- O board espelha o spec? Se não, a rastreabilidade está invertida.
