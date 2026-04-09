# AIDD: Modelo Operacional de Desenvolvimento

Este documento é a fonte de verdade textual do fluxo AIDD dentro do MRV AIDD Platform. Use-o para entender como o desenvolvimento realmente acontece quando a plataforma é usada em repositórios consumidores.

- Para a visão geral da plataforma, veja [../../README.md](../../README.md).
- Para instalar, veja [../guia-instalacao.md](../guia-instalacao.md).
- Para cenários de paralelismo, veja [colaboracao-e-paralelismo.md](./colaboracao-e-paralelismo.md).
- Para prompts operacionais, veja [prompt-pack.md](./prompt-pack.md).
- Para modelos e convenções de artefatos, veja [modelos-operacionais.md](./modelos-operacionais.md).

---

## Índice

- [Camadas do modelo](#camadas-do-modelo)
- [Referências do AIDD](#referências-do-aidd)
- [Core Philosophy](#core-philosophy)
- [O que o AIDD afirma](#o-que-o-aidd-afirma)
- [Personas e responsabilidades](#personas-e-responsabilidades)
- [Workflow ponta a ponta](#workflow-ponta-a-ponta)
- [Diagrama do fluxo](#diagrama-do-fluxo)
- [Gates oficiais](#gates-oficiais)
- [Artefatos oficiais](#artefatos-oficiais)
- [Critérios de passagem](#critérios-de-passagem)
- [Convenções operacionais](#convenções-operacionais)
- [Paralelismo real](#paralelismo-real)
- [Hotfix como exceção](#hotfix-como-exceção)
- [Anti-patterns](#anti-patterns)
- [Referências conceituais](#referências-conceituais)
- [Alinhamento com referências externas](#alinhamento-com-referências-externas)
- [Como usar este acervo](#como-usar-este-acervo)

---

## Camadas do modelo

Para evitar confusão conceitual, esta é a hierarquia oficial:

| Camada                | O que é                                                                                  |
| --------------------- | ---------------------------------------------------------------------------------------- |
| **AIDD**              | Estratégia maior de AI Driven Development da MRV                                         |
| **BDD + SDD**         | Jornada operacional que transforma a estratégia em entrega                               |
| **Spec Kit**          | Toolkit usado dentro da camada SDD                                                       |
| **MRV AIDD Platform** | Camada da MRV que instala documentação, convenções, extensions e presets sobre essa base |

Em termos práticos:

- a entrada de negócio chega como feature;
- a clarificação funcional consolida o `spec.md`;
- o desenho técnico consolida o `plan.md`;
- o board espelha o spec validado;
- a execução ocorre por US assumida, com escopo explícito.

---

## Referências do AIDD

Quando esta plataforma fala de AIDD, as referências conceituais são estas:

- **MRV AIDD Platform** — a camada operacional compartilhada mantida neste repositório.
- **BDD** — ajuda a amadurecer comportamentos, bordas de escopo e validação de negócio.
- **SDD** — organiza os artefatos que sustentam execução e rastreabilidade.
- **Spec Kit** — fornece CLI, comandos core e o mecanismo de extensions e presets.

Referências externas:

- Spec Kit repositório: [github.com/github/spec-kit](https://github.com/github/spec-kit)
- Spec Kit documentação: [github.github.io/spec-kit](https://github.github.io/spec-kit/)

---

## Core Philosophy

O AIDD desta plataforma se apoia em cinco princípios.

### Humans in the loop

Pessoas continuam definindo objetivo, restrições, ownership, qualidade e gates. Agentes operam o _how loop_ com guardrails.

### Spec before code

O fluxo não parte de implementação solta. Ele fecha o entendimento funcional antes de aprofundar o desenho técnico e antes de decompor o trabalho.

### Source of truth explícita

- A feature do upstream é entrada, não verdade final.
- `spec.md` vira a fonte de verdade funcional somente depois de clarificação e validação.
- `plan.md` vira a fonte de verdade técnica.
- O board deve espelhar o spec validado.

### Execução por recorte

`/tasks` e `/implement` operam por US assumida e com escopo explícito. Sem isso, o agente tende a decompor ou implementar a feature inteira, o que é um risco operacional.

### Melhoria contínua

O fluxo não termina em merge. Ele volta para o flywheel de melhoria, ajustando guardrails, harness, aprendizado operacional e backlog.

---

## O que o AIDD afirma

- A feature de upstream é a entrada principal do trabalho, mas pode chegar com gaps, ambiguidades ou omissões.
- O downstream não deve transcrever a feature cegamente. Ele deve clarificar o suficiente para tornar a feature testável e publicável.
- O board nunca deve ser a fonte funcional primária. Ele reflete o `spec.md` validado.
- O planejamento técnico não substitui a clarificação funcional. `plan.md` depende de um spec suficientemente fechado.
- Ownership backend e frontend vivem nas histórias, não como duplicação arbitrária da feature.
- Hotfix é exceção ao fluxo SDD normal, não o caminho principal.

---

## Personas e responsabilidades

### Visão por persona

| Persona    | Entrada principal                    | Responsabilidade                                                                                    | Saída esperada                               |
| ---------- | ------------------------------------ | --------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| **UX**     | Problema, dores, hipóteses           | Conduzir M1-M5, construir protótipos, mapear jornadas e entregar os 4 artefatos do Gate Handover   | Artefatos M5 validados                       |
| **Stakeholder** | Metas da diretoria, restrições  | Participar de M1-M2, validar jornada e protótipos, aceitar handover                                | Alinhamento estratégico                      |
| **Arquiteto** | Contexto Geral (M5)              | Desenhar diagrama C4 e definir `constitution.md`                                                    | C4 + constitution.md                         |
| **PO**     | Feature de upstream                  | Confirmar objetivo de negócio, gaps funcionais, bordas de escopo, prioridades e readiness funcional | Spec claro, validado e publicável            |
| **TL**     | Spec suficientemente clarificado     | Fechar o recorte técnico, contratos, fundação compartilhada, riscos e readiness de execução         | `plan.md`, estratégia e commitment           |
| **Dev**    | US assumida com ownership claro      | Executar o recorte certo, preservar rastreabilidade e validar a entrega                             | Branch da US, PR da US, checks verdes        |
| **Agente** | Spec, plan, tasks e escopo explícito | Operar o _how loop_ sem redefinir o problema nem expandir escopo indevidamente                      | Artefatos e alterações aderentes ao contexto |

### Participação por fase

| Persona | UX Upstream (M1-M5) | Gate Handover + Arquitetura | Ciclo Features SDD | Entrega SDD |
| --- | --- | --- | --- | --- |
| **UX** | Conduz M1-M5, constrói protótipos, mapeia jornadas | Entrega artefatos, valida checklist | — | — |
| **Stakeholder** | Participa de M1-M2, valida jornada e protótipos | Aceita handover | — | — |
| **Arquiteto** | Observa restrições técnicas (M4) | Desenha C4 + constitution.md | Referência técnica | — |
| **PO** | Participa de M2-M5, valida prioridades | Valida completude do handover | Escreve features (/specify), valida (/clarify), publica (/sincronizar) | Valida spec |
| **TL** | Observa viabilidade (M4-M5) | — | Valida features (/clarify) | Fecha plan, contratos |
| **Dev** | — | — | — | Assume US, executa /tasks + /implement |
| **Agente** | Input IA nos módulos M1-M5 | — | Gera USs no /specify, executa /sincronizar | Opera /tasks + /implement + checks |

**Regra invariante**: O agente nunca decide. Ele gera, executa e valida dentro do harness. Decisões são das pessoas. Isso preserva o princípio **humans in the loop** do AIDD.

### Modelo de assistência de IA

| Etapa | Papel humano | Papel do agente | Modelo |
| --- | --- | --- | --- |
| M1-M5 (UX) | UX conduz workshops e prototipa | IA recebe transcrições, atas, resumos e gera inputs | **Assistente** |
| Gate Handover | PO valida completude | — | — |
| Arquitetura | Arquiteto desenha C4 + constitution | IA pode auxiliar na geração de rascunhos | **Assistente** |
| /specify | PO escreve a feature | Agente gera USs a partir da feature escrita | **Gerador** |
| /clarify | PO + TL validam e refinam | Agente identifica gaps e edge cases | **Provocador** |
| /sincronizar | PO decide publicar | Agente grava no Azure DevOps | **Executor** |
| /plan | TL fecha recorte técnico | Agente estrutura contratos e riscos | **Estruturador** |
| /tasks | Dev assume US | Agente decompõe em tarefas acionáveis | **Decompositor** |
| /implement | Dev valida resultado | Agente implementa a US assumida | **Implementador** |
| Flywheel | Time analisa feedback | Agente identifica padrões de retrabalho | **Analista** |

**Harness**: Templates, checklists, gates, C4 e constitution.md são o harness. O agente opera exclusivamente dentro dele. As pessoas projetam o _why loop_.

---

## Workflow ponta a ponta

### UX Upstream (M1-M5) — equipe de UX conduz

A equipe de UX conduz os módulos de upstream usando frameworks consolidados de Design Thinking, Lean UX e Design Sprint.

#### M1 · O Mergulho (Discovery)

| Item | Conteúdo |
| --- | --- |
| **Atividades** | Reunião com Sponsors, Download do Problema, Levantamento de Dores |
| **Framework** | Design Thinking (Empatia) |
| **Discussão central** | "Quanto conhecemos o problema?" |
| **Input IA** | Transcrições + Atas + Premissas |
| **Output** | Matriz CSD + Diagnóstico de Dores |
| **Gate** | Contexto de Dores — equipe tem entendimento compartilhado do problema |

#### M2 · O Propósito (Estratégia)

| Item | Conteúdo |
| --- | --- |
| **Atividades** | Missão + OKRs, Alinhamento de Valor |
| **Framework** | Golden Circle + Lean UX |
| **Discussão central** | "Por que existimos?" |
| **Input IA** | Resumo M1 + Metas da Diretoria |
| **Output** | Visão do Produto + 3 OKRs + Hipóteses |
| **Gate** | Estratégia Validada — visão e métricas alinhadas com sponsors |

#### M3 · Olhar Usuário (Modelagem)

| Item | Conteúdo |
| --- | --- |
| **Atividades** | Personas + Mapa de Empatia, Jornada As-Is / To-Be |
| **Framework** | User Centered Design |
| **Discussão central** | "Quem é e qual seu medo?" |
| **Input IA** | Insights M2 + Pesquisas |
| **Output** | Protopersona + Jornada To-Be Visual |
| **Gate** | Jornada Humanizada — jornada do usuário está mapeada e validada |

#### M4 · Mãos à Obra (Design Sprint)

| Item | Conteúdo |
| --- | --- |
| **Atividades** | Brainstorming + User Story Mapping, Priorização MVP |
| **Framework** | Lean Inception + Design Sprint |
| **Discussão central** | "O que é essencial para o MVP?" |
| **Input IA** | Jornada M3 + Restrições Técnicas |
| **Output** | USM (Épicos / Features / Stories) + Fibonacci |
| **Gate** | Backlog Priorizado — épicos e features fatiados e priorizados |

#### M5 · Do Mapa à Tela (Prototipação)

| Item | Conteúdo |
| --- | --- |
| **Atividades** | Fluxos de Tela, Hierarquia de Informação, Happy Path |
| **Framework** | Agile Prototyping |
| **Discussão central** | "Como reduzir carga cognitiva?" |
| **Input IA** | USM M4 + Design System + APIs |
| **Output** | **4 artefatos formais** (ver tabela abaixo) |
| **Gate** | Protótipo Validado — protótipo HiFi aprovado pelos stakeholders |

**Os 4 artefatos de saída do M5:**

| Artefato | Descrição | Quem consome |
| --- | --- | --- |
| **Contexto Geral** | Visão consolidada do produto, problema, OKRs e decisões estratégicas de M1 a M5 | Time de Arquitetura (para C4 + constitution.md) |
| **Contexto do Épico** | Detalhamento do épico: objetivo, atores, regras de negócio, fronteiras, dependências | PO (referência no /specify) |
| **Protótipo HiFi (Figma)** | Protótipo de alta fidelidade no Figma, acessível via link | PO (referência no /specify via MCP) |
| **Feature Framing (lista)** | Lista das features candidatas do épico, com objetivo, atores e prioridade | PO (escolhe 1 feature por vez para /specify) |

> **Nota sobre Feature Framing**: Feature Framing é uma convenção de board (lista cadastrada no Épico do Azure DevOps), não um template do Spec Kit. Cada item deve conter no mínimo: nome da feature, objetivo, atores envolvidos e prioridade (definida no M4/M5 com Fibonacci). O PO consome essa lista sequencialmente ao iniciar cada ciclo de `/specify`.

### Gate Handover: UX → SDD

O Gate Handover é o ponto formal de transição entre o upstream (UX) e o downstream (SDD). Ele é **gravado no Épico do Azure DevOps** como checklist.

**Checklist:**

- ✓ Contexto Geral — disponível e referenciado no épico do board
- ✓ Contexto do Épico — cadastrado no épico do board
- ✓ Protótipo HiFi (Figma) — link funcional compartilhado
- ✓ Feature Framing (lista) — cadastrada no épico do board

**Regras:**

- O Gate Handover só é considerado completo quando os 4 artefatos estão disponíveis.
- O PO valida a completude antes de iniciar o ciclo de features.
- Se algum artefato estiver incompleto, o PO devolve à equipe de UX com indicação clara do gap.

**Convenções de board (Azure DevOps):**

- **Contexto Geral**: cadastrado como campo ou anexo no épico.
- **Contexto do Épico**: cadastrado no corpo ou campo dedicado do épico.
- **Protótipo HiFi (Figma)**: link funcional registrado no épico.
- **Feature Framing (lista)**: cadastrada no épico junto com o Contexto do Épico.

O PO verifica a presença dos 4 itens no épico antes de iniciar `/specify`. Não há automação — é validação humana.

### Arquitetura

Após o Gate Handover e **antes** do PO iniciar a escrita de features, o time de Arquitetura atua usando o Contexto Geral como input.

| Item | Conteúdo |
| --- | --- |
| **Input** | Contexto Geral (saída de M5, via Gate Handover) |
| **Quem** | Time de Arquitetura |
| **Atividade** | Desenhar diagrama C4 e definir a constitution.md |
| **Output** | Diagrama C4 + `constitution.md` |
| **Consumidor** | /plan (referência técnica), /specify (restrições arquiteturais), devs (guardrails) |

**Diagrama C4** — posiciona o sistema no ecossistema (Container level): containers envolvidos (APIs, frontend, bancos, filas, integrações), relacionamentos entre containers e sistemas externos com boundaries.

**constitution.md** — artefato nativo do Spec Kit, gerenciado pelo comando `/speckit.constitution`. Define princípios e restrições técnicas: stack e versões, padrões de API, autenticação/autorização, convenções de código e testes, limites de performance/SLA, dependências externas e guardrails para o agente. O Spec Kit gerencia com versionamento semântico — não é necessário criar template customizado.

**Relação entre C4 e constitution.md:**

| Aspecto | constitution.md | Diagrama C4 |
| --- | --- | --- |
| **Natureza** | Princípios abstratos e estáveis | Estrutura concreta do sistema |
| **Escopo** | Repositório inteiro | Épico ou produto |
| **Evolução** | Muda quando princípios mudam | Muda quando topologia muda |
| **Gerência** | `/speckit.constitution` (nativo) | Time de Arquitetura (manual) |

A constitution pode ter um princípio que **aponta** para o C4 (ex: "A topologia de containers segue o diagrama C4 em `.specify/memory/`"), mas o C4 **não deve ser incorporado** dentro da constitution. Ambos ficam em `.specify/memory/` e evoluem de forma independente.

**Como executar:**

1. O Arquiteto desenha o diagrama C4 (Container level) e salva em `.specify/memory/` do repositório consumidor.
2. O Arquiteto executa `/speckit.constitution` usando o Contexto Geral como input.
3. Se necessário, adiciona um princípio na constitution referenciando o C4.

**Regra**: O passo de Arquitetura **não bloqueia** a escrita de features — mas features escritas antes da conclusão podem precisar de revisão se houver restrições arquiteturais não previstas. Na prática, o ideal é concluir Arquitetura antes do primeiro `/specify`.

### Downstream Negócio — Ciclo de Features (repete 5-8x por épico)

1. **PO escolhe 1 feature** — do Feature Framing cadastrado no épico do board.
2. `/speckit.specify` — PO indica a feature do Feature Framing e conduz entrevista progressiva com o agente (objetivo, atores, regras de negócio, fronteiras, dependências, prioridade). O agente pergunta apenas o que falta, uma rodada por vez, e encerra assim que houver informação suficiente. Gera `spec.md` com USs. Referências obrigatórias: Contexto do Épico + link Figma via MCP.
3. `/speckit.clarify` — PO + Tech Lead validam e refinam feature + USs. Edge cases, critérios.
4. `/speckit.mrv-aidd-producao.sincronizar-us-devops` — resolve o Épico pai no Azure DevOps, cria a Feature como filha do Épico (se não existir) e grava USs como filhas da Feature.
5. **Ready para técnico** — spec validado, publicado e rastreável no board.

### SDD + Entrega

1. `/speckit.plan` — TL fecha o recorte técnico. Referencia C4 + constitution.md.
2. **Refinamento técnico** — devs e TL alinham riscos, dependências e estratégia.
3. **US assumida** — um dev ou par assume ownership explícito de uma US.
4. `/speckit.mrv-aidd-producao.configurar-us USn` — a branch da US e o contexto operacional são preparados.
5. `/speckit.tasks USn` — a US é detalhada em tarefas acionáveis.
6. `/speckit.implement USn` — o agente implementa somente a US assumida.
7. `/speckit.mrv-aidd-producao.terminar-us USn` — a entrega é validada, commitada e enviada para PR.
8. **Validação e merge** — a branch da US retorna para a branch integradora da feature.

### Flywheel

1. **Flywheel** — feedback do delivery retroalimenta o harness SDD e os módulos UX upstream.

---

## Diagrama do fluxo

O diagrama abaixo representa visualmente as macro-áreas do fluxo AIDD integrado:

- **UX Upstream (M1-M5)** — módulos 1 a 5, conduzidos pela equipe de UX
- **Gate Handover** — transição formal UX → SDD com 4 artefatos
- **Arquitetura** — C4 + constitution.md
- **Downstream Negócio** — ciclo de features (/specify → /clarify → /sincronizar)
- **SDD + Entrega** — /plan → /tasks → /implement → terminar-us
- **Flywheel de melhoria** — retroalimenta upstream e harness

O diagrama integrado está em [diagrama-aidd-integrado.drawio](./diagrama-aidd-integrado.drawio).

A definição textual oficial do processo é esta página. O diagrama apoia a leitura, não substitui.

---

## Gates oficiais

| Gate | Transição | O que garante |
| --- | --- | --- |
| **Contexto de Dores** | M1 → M2 | Equipe tem entendimento compartilhado do problema |
| **Estratégia Validada** | M2 → M3 | Visão e métricas alinhadas com sponsors |
| **Jornada Humanizada** | M3 → M4 | Jornada do usuário mapeada e validada |
| **Backlog Priorizado** | M4 → M5 | Épicos e features fatiados com prioridade |
| **Protótipo Validado** | M5 → Gate Handover | Protótipo HiFi aprovado, 4 artefatos prontos |
| **Gate Handover** | UX → Arquitetura + SDD | 4 artefatos entregues e verificados no épico do board |
| **Arquitetura pronta** | Arquitetura → Features | C4 + constitution.md disponíveis |
| **Ready para técnico** | Features → SDD Entrega | Spec validado, publicado e rastreável no board |
| **Escopo explícito da US** | SDD → /tasks + /implement | O _how loop_ não opera com escopo solto |

---

## Artefatos oficiais

| Artefato | Papel no fluxo | Fonte de verdade |
| --- | --- | --- |
| Contexto Geral (M5) | Visão consolidada do produto | UX Upstream |
| Contexto do Épico (M5) | Detalhamento do épico | UX Upstream (cadastrado no board) |
| Protótipo HiFi (M5) | Referência visual (Figma link) | UX Upstream |
| Feature Framing (M5) | Lista de features candidatas | UX Upstream (cadastrado no board) |
| Diagrama C4 | Visão de containers e integrações | Arquitetura |
| `constitution.md` | Princípios e restrições técnicas | Arquitetura |
| `spec.md` | Verdade funcional consolidada | Downstream (após /specify + /clarify) |
| Board | Épico → Feature → USs na hierarquia Azure DevOps | Derivado do spec (/sincronizar) |
| `plan.md` | Verdade técnica consolidada | Planejamento técnico (/plan) |
| `tasks.md` | Detalhamento operacional da US | Derivado do plan e do spec (/tasks) |
| Branch `feature/<feature>/usN` | Isolamento operacional da US | Execução |
| PR da US | Integração na branch da feature | Execução |
| Aprendizados de retro e ajuste | Feed do flywheel | Melhoria contínua |

### Cadeia de dependência

| Artefato | Depende de | Alimenta |
| --- | --- | --- |
| Matriz CSD (M1) | Reunião sponsors | Visão Produto (M2) |
| Visão Produto + OKRs (M2) | M1 | Personas + Jornada (M3) |
| Protopersona + Jornada (M3) | M2 | USM (M4) |
| USM + Fibonacci (M4) | M3 | Protótipo + Feature Framing (M5) |
| Contexto Geral (M5) | M1-M4 acumulados | Diagrama C4 + constitution.md |
| Contexto do Épico (M5) | M4 + M5 | /specify (referência) |
| Protótipo HiFi (M5) | M4 | /specify (link Figma via MCP) |
| Feature Framing (M5) | M4 | PO escolhe features para /specify |
| Diagrama C4 + constitution.md | Contexto Geral | /plan, /specify (restrições), devs |
| `spec.md` | Feature Framing + Contexto Épico + Figma + C4 | `plan.md`, Board |
| Board | `spec.md` validado (/sincronizar: Épico → Feature → USs) | Rastreabilidade |
| `plan.md` | `spec.md` validado + C4 + constitution.md | `tasks.md` |
| `tasks.md` | `plan.md` + `spec.md` | `/implement` |

---

## Critérios de passagem

### De feature para spec

- Os gaps funcionais relevantes foram fechados.
- Cada US pode ser testada de forma independente.
- Bordas de escopo e ownership estão explícitos.

### De spec para board

- O `spec.md` está validado.
- As histórias do board derivam do spec, não do upstream bruto.
- A rastreabilidade com Azure DevOps ou outro board está definida quando aplicável.

### De board para plan

- O board já espelha a feature e as USs publicadas.
- Não existe divergência funcional entre board e spec.
- A ordem de execução está coerente com o spec validado.

### De plan para execução

- `plan.md` identifica stack, contratos, fundação compartilhada, riscos e estratégia.
- Dependências entre USs estão visíveis.
- Ficou claro o que pode e o que não pode paralelizar.

### Para permitir `/tasks`

- Existe US assumida por um dev ou par.
- Existe escopo explícito da execução atual.
- O agente sabe qual US está em foco.

### Para permitir `/implement`

- A US em foco tem tarefas acionáveis.
- A branch da US existe ou será criada pelo fluxo da extension.
- O recorte técnico já está refletido no `plan.md`.
- Os checks mínimos foram combinados.

---

## Convenções operacionais

### Branches e PRs

- Branch integradora da feature: `001-nome-da-feature` ou equivalente do Spec Kit.
- Branch por US: `feature/<feature-branch>/usN`.
- PR de US mira a branch integradora da feature.
- PR final para `main` sai da branch integradora, não de uma branch de US.

### Board e rastreabilidade

- A feature do board representa a feature consolidada do `spec.md`.
- As USs do board derivam do spec validado.
- Quando necessário, o board projeta ownership FE e BE a partir do mesmo spec funcional.
- O ID do work item sincronizado volta para o próprio `spec.md`.

### Ownership

- Backend e frontend vivem como ownership de histórias.
- O repositório consumidor instala apenas o preset do próprio ownership.
- Handoff não significa duplicar a feature nem quebrar a fonte de verdade funcional.

---

## Paralelismo real

O AIDD suporta múltiplos devs em USs diferentes, desde que estas regras sejam respeitadas:

- `spec.md` continua único por feature.
- `plan.md` registra fundação compartilhada, riscos e contratos.
- Cada dev executa `/tasks` apenas para a US assumida.
- Cada dev executa `/implement` apenas para a US assumida.
- Se duas USs disputam a mesma fundação estrutural, o paralelismo não é seguro até o bloqueio ser removido.

Para detalhamento operacional de cenários complexos, veja [colaboracao-e-paralelismo.md](./colaboracao-e-paralelismo.md).

---

## Hotfix como exceção

Hotfix fica fora do fluxo SDD normal.

- Não depende de decompor a feature inteira em spec, plan e tasks por US.
- Deve ser tratado como exceção controlada, não como caminho padrão.
- Precisa registrar contexto, impacto, validação mínima e aprendizado para o flywheel.
- Quando expuser lacuna estrutural, a correção do processo deve voltar ao fluxo normal depois da urgência.

---

## Anti-patterns

### No upstream (UX M1-M5)

| Anti-pattern | Por que é perigoso |
| --- | --- |
| Pular módulos (M1 direto para M4) | Fatiamento sem entendimento do problema gera features desconectadas |
| Protótipo sem validação com stakeholder | Fluxos bonitos que ninguém testou; jornada não validada |
| Feature Framing sem priorização | PO recebe lista sem critério; dificulta escolha no /specify |
| Contexto Geral superficial | Arquitetura e constitution ficam genéricos; restrições não previstas |

### No Gate Handover

| Anti-pattern | Por que é perigoso |
| --- | --- |
| Handover sem checklist formal | Artefatos faltantes descobertos no meio do /specify |
| Protótipo sem link acessível | PO não consegue referenciar Figma no /specify |
| Feature Framing não cadastrado no board | Perda de rastreabilidade entre features e épico |

### No ciclo de features

| Anti-pattern | Por que é perigoso |
| --- | --- |
| /specify sem referenciar Contexto do Épico | Features nascem desconectadas do épico |
| /specify sem link do Figma | USs geradas sem base visual; gaps de interface |
| /clarify sem TL presente | Edge cases técnicos não identificados |
| Features escritas antes da Arquitetura | Restrições arquiteturais não previstas geram retrabalho |

### Na entrega SDD

| Anti-pattern | Por que é perigoso |
| --- | --- |
| Reescrever a feature do upstream em vez de clarificar | Perde o trabalho de discovery do UX |
| Usar o board como fonte funcional primária | Board deve espelhar o spec, não substituí-lo |
| Rodar `/tasks` sem US assumida e sem escopo explícito | Agente decompõe a feature inteira |
| Deixar o agente decompor a feature inteira por falta de recorte | Risco operacional de escopo solto |
| Misturar fundação compartilhada com várias USs sem registrar o desbloqueio | Paralelismo inseguro |
| Abrir PR de uma US direto para `main` | Quebra isolamento da branch integradora |
| Tratar hotfix como se fosse o caminho padrão | Hotfix é exceção, não fluxo normal |

---

## Referências conceituais

| Técnica / Referência | Autor | Onde aparece no fluxo |
| --- | --- | --- |
| **Design Thinking** | Design Council / IDEO | M1 (Empatia, divergir-convergir) |
| **Golden Circle** | Simon Sinek | M2 (Why → How → What) |
| **Lean UX** | Jeff Gothelf | M2 (Hipóteses, OKRs orientados a outcome) |
| **User Centered Design** | Don Norman / ISO 9241 | M3 (Personas, jornada) |
| **Lean Inception** | Paulo Caroli | M4 (Visão, personas, features, sequenciador) |
| **Design Sprint** | Jake Knapp (Google Ventures) | M4 (Prototipação rápida, validação) |
| **User Story Mapping** | Jeff Patton | M4 (Backbone de atividades + stories) |
| **Agile Prototyping** | — | M5 (HiFi, happy path, fluxos) |
| **Spec-Driven Development** | GitHub / Spec Kit | Ciclo Features + Entrega SDD |
| **BDD** | Dan North / Matt Wynne | /clarify (exemplos, critérios de aceite) |
| **C4 Model** | Simon Brown | Passo de Arquitetura |
| **Harness Engineering** | Kief Morris / Martin Fowler | Modelo geral — templates, gates, guardrails |
| **Humans in the loop** | AIDD / Fowler-Morris | Princípio invariante em todo o fluxo |

---

## Alinhamento com referências externas

| Princípio | Como aparece no fluxo integrado |
| --- | --- |
| **Double Diamond** (Design Council) | M1-M3 são o primeiro diamante (divergir → convergir no problema). M4-M5 são o segundo diamante (divergir em soluções → convergir em protótipos validados). |
| **4 Riscos** (Cagan/SVPG) | Valor e usabilidade validados no upstream (M1-M5). Viabilidade e negócio validados no passo de Arquitetura e /clarify. |
| **Opportunity Solution Tree** (Teresa Torres) | M2 define outcomes, M3 mapeia oportunidades, M4 gera soluções, M5 valida. |
| **User Story Mapping** (Jeff Patton) | M4 usa USM como backbone. Feature Framing é o slice priorizado. |
| **Harness Engineering** (Morris/Fowler) | Templates + checklists + gates + C4 + constitution são o harness. O agente opera dentro dele. As pessoas projetam o _why loop_. |
| **Flywheel de melhoria** | Feedback do delivery retroalimenta tanto o harness SDD quanto os módulos UX upstream. |
| **Humans in the loop** (AIDD) | Nenhuma decisão de fluxo é delegada ao agente. UX conduz upstream, PO+TL conduzem features, devs conduzem entrega. O agente opera com guardrails. |

---

## Como usar este acervo

| Para... | Abra |
| --- | --- |
| Visão geral da plataforma | [../../README.md](../../README.md) |
| Instalar em repositório consumidor | [../guia-instalacao.md](../guia-instalacao.md) |
| Exemplos e convenções reutilizáveis de artefatos | [modelos-operacionais.md](./modelos-operacionais.md) |
| Cenários com múltiplos devs e trilhas separadas | [colaboracao-e-paralelismo.md](./colaboracao-e-paralelismo.md) |
| Prompts operacionais por etapa | [prompt-pack.md](./prompt-pack.md) |
| Diagrama visual do fluxo integrado | [diagrama-aidd-integrado.drawio](./diagrama-aidd-integrado.drawio) |
