# Fluxo Integrado AIDD: UX Upstream + Arquitetura + SDD

> **Status**: Modelo integrado validado.
> **Escopo**: Documentar o fluxo completo de ponta a ponta — desde a descoberta conduzida pela equipe de UX (M1-M5) ate a entrega tecnica via SDD, incluindo o Gate Handover, o passo de Arquitetura e o ciclo de features.
> **Referencia canonica do fluxo SDD**: [README.md](./README.md)
> **Diagrama oficial**: [diagrama-aidd-integrado.drawio](./diagrama-aidd-integrado.drawio)

---

## Indice

- [Contexto e motivacao](#contexto-e-motivacao)
- [Visao macro do fluxo integrado](#visao-macro-do-fluxo-integrado)
- [UX Upstream — Modulos M1 a M5](#ux-upstream--modulos-m1-a-m5)
  - [M1 - O Mergulho (Discovery)](#m1--o-mergulho-discovery)
  - [M2 - O Proposito (Estrategia)](#m2--o-proposito-estrategia)
  - [M3 - Olhar Usuario (Modelagem)](#m3--olhar-usuario-modelagem)
  - [M4 - Maos a Obra (Design Sprint)](#m4--maos-a-obra-design-sprint)
  - [M5 - Do Mapa a Tela (Prototipacao)](#m5--do-mapa-a-tela-prototipacao)
- [Gate Handover: UX → SDD](#gate-handover-ux--sdd)
- [Passo de Arquitetura](#passo-de-arquitetura)
- [Downstream Negocio — Ciclo de Features SDD](#downstream-negocio--ciclo-de-features-sdd)
- [SDD + Entrega](#sdd--entrega)
- [Flywheel de melhoria](#flywheel-de-melhoria)
- [Cadeia completa de artefatos](#cadeia-completa-de-artefatos)
- [Gates consolidados](#gates-consolidados)
- [Personas e responsabilidades](#personas-e-responsabilidades)
- [Modelo de assistencia de IA](#modelo-de-assistencia-de-ia)
- [Anti-patterns](#anti-patterns)
- [Referencias conceituais](#referencias-conceituais)
- [Alinhamento com referencias externas](#alinhamento-com-referencias-externas)
- [Proximos passos](#proximos-passos)

---

## Contexto e motivacao

O fluxo MRV AIDD opera com duas grandes camadas complementares:

1. **UX Upstream (M1-M5)** — conduzido pela equipe de UX, cobre desde a imersao no problema ate a prototipacao de alta fidelidade. Esse fluxo ja existia como pratica do time, utilizado em reunioes no Miro, e agora e integrado formalmente ao AIDD.

2. **SDD Downstream** — conduzido por PO, Tech Lead e devs, transforma os artefatos de saida do UX em features especificadas, planejadas, implementadas e entregues.

O ponto de integracao e o **Gate Handover**, onde a equipe de UX entrega 4 artefatos formais e o time tecnico assume a partir da escrita de features.

### O que mudou

Anteriormente, as etapas 1-5 do workflow AIDD estavam descritas superficialmente como "Upstream / Descoberta". Na pratica, a equipe de UX ja conduzia esse trabalho de forma estruturada. A integracao formaliza essa realidade:

- O SDD **nao replica** o upstream — ele **integra** na saida do M5.
- A equipe de UX e dona dos modulos M1-M5.
- O time tecnico entra apos o Gate Handover, com um passo de Arquitetura antes da escrita de features.

---

## Visao macro do fluxo integrado

```
UX UPSTREAM (M1 → M5)
   M1: O Mergulho (Discovery)          → Matriz CSD + Diagnostico Dores
   M2: O Proposito (Estrategia)        → Visao Produto + 3 OKRs + Hipoteses
   M3: Olhar Usuario (Modelagem)       → Protopersona + Jornada To-Be Visual
   M4: Maos a Obra (Design Sprint)     → USM (Epicos/Features/Stories) + Fibonacci
   M5: Do Mapa a Tela (Prototipacao)   → Contexto Geral, Contexto do Epico,
                                           Prototipo HiFi (Figma), Feature Framing
      |
      v
+------------------------------------------------------+
|  GATE HANDOVER: UX → SDD                            |
|  Gravado no Epico do Azure DevOps                    |
|  ✓ Contexto Geral                                    |
|  ✓ Contexto do Epico                                 |
|  ✓ Prototipo HiFi (Figma link)                       |
|  ✓ Feature Framing (lista)                           |
+----------------------+-------------------------------+
                       |
                       v
ARQUITETURA
   Time de Arquitetura → Diagrama C4 + constitution.md
   Input: Contexto Geral
                       |
                       v
DOWNSTREAM NEGOCIO — CICLO DE FEATURES (repete 5-8x por epico)
   PO escolhe 1 feature do Feature Framing
   → /specify (PO escreve, refs: Contexto Epico + Figma link via MCP → gera USs)
   → /clarify (PO + TL validam, edge cases, criterios)
   → /sincronizar (Azure DevOps: cria Feature filha do Epico, USs filhas da Feature)
                       |
                       v
SDD + ENTREGA
   /plan → Refinamento tecnico → US assumida → configurar-us
   → Loop: /tasks → /implement → checks → terminar-us
   → Validacao + staging
                       |
                       v
FLYWHEEL
   Feedback → melhoria harness → retroalimenta upstream
```

---

## UX Upstream — Modulos M1 a M5

A equipe de UX conduz os modulos de upstream usando frameworks consolidados de Design Thinking, Lean UX e Design Sprint. Cada modulo tem atividades, framework de referencia, discussao central, inputs de IA e outputs formais com gate de passagem.

### M1 - O Mergulho (Discovery)

| Item | Conteudo |
|---|---|
| **Atividades** | Reuniao com Sponsors, Download do Problema, Levantamento de Dores |
| **Framework** | Design Thinking (Empatia) |
| **Discussao central** | "Quanto conhecemos o problema?" |
| **Input IA** | Transcricoes + Atas + Premissas |
| **Output** | Matriz CSD + Diagnostico de Dores |
| **Gate** | Contexto de Dores — equipe tem entendimento compartilhado do problema |

### M2 - O Proposito (Estrategia)

| Item | Conteudo |
|---|---|
| **Atividades** | Missao + OKRs, Alinhamento de Valor |
| **Framework** | Golden Circle + Lean UX |
| **Discussao central** | "Por que existimos?" |
| **Input IA** | Resumo M1 + Metas da Diretoria |
| **Output** | Visao do Produto + 3 OKRs + Hipoteses |
| **Gate** | Estrategia Validada — visao e metricas alinhadas com sponsors |

### M3 - Olhar Usuario (Modelagem)

| Item | Conteudo |
|---|---|
| **Atividades** | Personas + Mapa de Empatia, Jornada As-Is / To-Be |
| **Framework** | User Centered Design |
| **Discussao central** | "Quem e e qual seu medo?" |
| **Input IA** | Insights M2 + Pesquisas |
| **Output** | Protopersona + Jornada To-Be Visual |
| **Gate** | Jornada Humanizada — jornada do usuario esta mapeada e validada |

### M4 - Maos a Obra (Design Sprint)

| Item | Conteudo |
|---|---|
| **Atividades** | Brainstorming + User Story Mapping, Priorizacao MVP |
| **Framework** | Lean Inception + Design Sprint |
| **Discussao central** | "O que e essencial para o MVP?" |
| **Input IA** | Jornada M3 + Restricoes Tecnicas |
| **Output** | USM (Epicos / Features / Stories) + Fibonacci |
| **Gate** | Backlog Priorizado — epicos e features fatiados e priorizados |

### M5 - Do Mapa a Tela (Prototipacao)

| Item | Conteudo |
|---|---|
| **Atividades** | Fluxos de Tela, Hierarquia de Informacao, Happy Path |
| **Framework** | Agile Prototyping |
| **Discussao central** | "Como reduzir carga cognitiva?" |
| **Input IA** | USM M4 + Design System + APIs |
| **Output** | **4 artefatos formais** (ver abaixo) |
| **Gate** | Prototipo Validado — prototipo de alta fidelidade aprovado pelos stakeholders |

#### Os 4 artefatos de saida do M5

Esses artefatos sao a ponte formal entre UX e SDD:

| Artefato | Descricao | Quem consome |
|---|---|---|
| **Contexto Geral** | Visao consolidada do produto, problema, OKRs e decisoes estrategicas acumuladas de M1 a M5 | Time de Arquitetura (para C4 + constitution.md) |
| **Contexto do Epico** | Detalhamento do epico especifico: objetivo, atores, regras de negocio, fronteiras, dependencias | PO (referencia no /specify) |
| **Prototipo HiFi (Figma)** | Prototipo de alta fidelidade no Figma, acessivel via link | PO (referencia no /specify via MCP) |
| **Feature Framing (lista)** | Lista das features candidatas do epico, com objetivo, atores e prioridade | PO (escolhe 1 feature por vez para /specify) |

> **Nota sobre Feature Framing**: Feature Framing e uma convencao de board (lista cadastrada no Epico do Azure DevOps), nao um template do Spec Kit. Cada item da lista deve conter no minimo: nome da feature, objetivo, atores envolvidos e prioridade (definida no M4/M5 com Fibonacci). O PO consome essa lista sequencialmente ao iniciar cada ciclo de `/specify`.

---

## Gate Handover: UX → SDD

O Gate Handover e o ponto formal de transicao entre o upstream (UX) e o downstream (SDD). Ele e **gravado no Epico do Azure DevOps** como checklist.

### Checklist do Gate Handover

```
✓ Contexto Geral — disponivel e referenciado no epico do board
✓ Contexto do Epico — cadastrado no epico do board
✓ Prototipo HiFi (Figma) — link funcional compartilhado
✓ Feature Framing (lista) — cadastrada no epico do board junto com o Contexto do Epico
```

### Regras

- O Gate Handover so e considerado completo quando os 4 artefatos estao disponiveis.
- O PO valida a completude antes de iniciar o ciclo de features.
- Se algum artefato estiver incompleto, o PO devolve a equipe de UX com indicacao clara do gap.

### Convencoes de board (Azure DevOps)

O Gate Handover e uma convencao de board, nao um template do Spec Kit. Os artefatos sao registrados diretamente no Epico do Azure DevOps:

- **Contexto Geral**: cadastrado como campo ou anexo no epico.
- **Contexto do Epico**: cadastrado no corpo ou campo dedicado do epico.
- **Prototipo HiFi (Figma)**: link funcional registrado no epico.
- **Feature Framing (lista)**: cadastrada no epico junto com o Contexto do Epico.

O PO verifica a presenca dos 4 itens no epico antes de iniciar `/specify`. Nao ha automacao — e validacao humana.

---

## Passo de Arquitetura

Apos o Gate Handover e **antes** do PO iniciar a escrita de features, o time de Arquitetura atua usando o Contexto Geral como input.

### Atividades

| Item | Conteudo |
|---|---|
| **Input** | Contexto Geral (saida de M5, via Gate Handover) |
| **Quem** | Time de Arquitetura |
| **Atividade** | Desenhar diagrama C4 e definir a constitution.md |
| **Output** | Diagrama C4 + `constitution.md` |
| **Consumidor** | /plan (referencia tecnica), /specify (restricoes arquiteturais), devs (guardrails) |

### Diagrama C4

O diagrama C4 posiciona o sistema no ecossistema (Container level), mostrando:

- Containers envolvidos (APIs, frontend, bancos, filas, integracoes)
- Relacionamentos entre containers
- Sistemas externos e boundaries

### constitution.md

O `constitution.md` e um artefato nativo do Spec Kit, gerenciado pelo comando `/speckit.constitution`. Ele define os principios e restricoes tecnicas que governam a implementacao:

- Stack tecnologica e versoes
- Padroes de API (REST, gRPC, mensageria)
- Estrategia de autenticacao/autorizacao
- Convencoes de codigo e testes
- Limites de performance e SLA
- Dependencias externas e integracoes obrigatorias
- Guardrails que o agente deve respeitar

O Spec Kit gerencia `constitution.md` com versionamento semantico e propaga atualizacoes para todos os templates dependentes. Por isso, **nao e necessario criar um template customizado** — basta executar `/speckit.constitution` no repositorio consumidor durante o passo de Arquitetura.

### Relacao entre C4 e constitution.md

Sao artefatos complementares, mas com naturezas distintas:

| Aspecto | constitution.md | Diagrama C4 |
|---|---|---|
| **Natureza** | Principios abstratos e estaveis | Estrutura concreta do sistema |
| **Escopo** | Repositorio inteiro | Epico ou produto |
| **Evolucao** | Muda quando principios mudam | Muda quando topologia muda |
| **Gerencia** | `/speckit.constitution` (nativo) | Time de Arquitetura (manual) |

A constitution pode ter um principio que **aponta** para o C4 como referencia arquitetural (ex: "A topologia de containers segue o diagrama C4 em `.specify/memory/`"), mas o C4 **nao deve ser incorporado** dentro da constitution. Ambos ficam em `.specify/memory/` e evoluem de forma independente.

### Como executar o passo de Arquitetura

1. O Arquiteto desenha o diagrama C4 (Container level) e o salva em `.specify/memory/` do repositorio consumidor.
2. O Arquiteto executa `/speckit.constitution` no repositorio consumidor, usando o Contexto Geral como input para definir principios, stack e guardrails.
3. Se necessario, adiciona um principio na constitution referenciando o C4: "Consultar diagrama C4 em `.specify/memory/` para topologia de containers e integracoes."

### Regra

O passo de Arquitetura **nao bloqueia** a escrita de features — mas features escritas antes da conclusao do C4 e constitution podem precisar de revisao se houver restricoes arquiteturais nao previstas. Na pratica, o ideal e concluir Arquitetura antes do primeiro `/specify`.

---

## Downstream Negocio — Ciclo de Features SDD

Apos o Gate Handover e o passo de Arquitetura, o PO inicia o ciclo de escrita de features. Cada feature percorre 3 comandos:

### Fluxo por feature (repete 5-8x por epico)

#### 1. PO escolhe 1 feature do Feature Framing

O PO seleciona a proxima feature da lista cadastrada no epico do board, baseado na prioridade definida no M4/M5.

#### 2. `/specify` — Escrita da feature

| Item | Conteudo |
|---|---|
| **Quem** | PO (escreve) + Agente (gera USs) |
| **Input** | Contexto do Epico (board) + Prototipo HiFi (link Figma acessado via MCP) + Feature Framing (referencia) + C4 + constitution.md |
| **Acao** | PO escreve a feature, referencia o epico do board e insere link do Figma. O agente gera as USs derivadas. |
| **Output** | `spec.md` — feature especificada com USs |

#### 3. `/clarify` — Validacao da feature

| Item | Conteudo |
|---|---|
| **Quem** | PO + Tech Lead |
| **Acao** | Validam e refinam a feature + USs. Identificam edge cases, criterios de aceite e questoes tecnicas. |
| **Output** | `spec.md` atualizado e validado |

#### 4. `/sincronizar` — Publicacao no board

| Item | Conteudo |
|---|---|
| **Quem** | PO (dispara) + Agente (executa) |
| **Acao** | Cria ou reutiliza a Feature no Azure DevOps como filha do Epico, depois cria as USs como filhas da Feature. Persiste os IDs de volta no `spec.md`. |
| **Output** | Board atualizado: Epico → Feature → USs (hierarquia completa) |

#### Ready para tecnico

Apos o ciclo /specify → /clarify → /sincronizar, a feature esta:

- Especificada com `spec.md` validado
- Publicada no board com hierarquia: Epico → Feature → USs
- Rastreavel do epico ate cada US individual com IDs persistidos no `spec.md`

---

## SDD + Entrega

O fluxo de entrega opera feature por feature, US por US, conforme o modelo SDD existente:

### Fluxo de entrega

1. `/plan` — TL fecha o recorte tecnico: contratos, fundacao compartilhada, riscos e estrategia. Referencia C4 + constitution.md.
2. **Refinamento tecnico** — devs e TL alinham riscos, dependencias e estrategia.
3. **US assumida** — um dev ou par assume ownership explicito de uma US.
4. `configurar-us USn` — branch da US e contexto operacional preparados.
5. **Loop SDD por US**:
   - `/tasks USn` — plano executavel da US
   - `/implement USn` — agente implementa a US assumida
   - **Checks automaticos** — lint, testes, seguranca
   - `terminar-us USn` — PR + merge na branch integradora
6. **Validacao + staging** — feature flag se necessario.

### Regras mantidas do SDD

- `spec.md` e a fonte de verdade funcional (apos clarificacao e validacao).
- `plan.md` e a fonte de verdade tecnica.
- O board espelha o spec validado.
- `/tasks` e `/implement` operam por US assumida com escopo explicito.
- O agente opera o _how loop_ com guardrails — nao redefine problema nem expande escopo.

---

## Flywheel de melhoria

O flywheel fecha o ciclo de ponta a ponta:

1. **Feedback do delivery** — bugs, retrabalho, lead time, gaps identificados durante a implementacao.
2. **Melhoria do harness** — ajustes em prompts, templates, checklists, constitution e guardrails.
3. **Retroalimenta upstream** — novas hipoteses, lacunas descobertas durante o delivery, padroes reutilizaveis para futuras iteracoes UX.

O feedback do delivery retroalimenta tanto o harness SDD quanto os modulos UX upstream.

---

## Cadeia completa de artefatos

```
UX UPSTREAM
      |
 M1   |  Matriz CSD + Diagnostico de Dores
 M2   |  Visao Produto + 3 OKRs + Hipoteses
 M3   |  Protopersona + Jornada To-Be Visual
 M4   |  USM (Epicos/Features/Stories) + Fibonacci
 M5   |  Contexto Geral | Contexto do Epico | Prototipo HiFi | Feature Framing
      |
      |  --- GATE HANDOVER ---
      |  (4 artefatos verificados no epico do Azure DevOps)
      |
 ARQ  |  Diagrama C4 + constitution.md
      |
      |  --- CICLO DE FEATURES (5-8x por epico) ---
      |
      |  spec.md              Verdade funcional (apos /specify + /clarify)
      |  Board                Epico → Feature → USs (/sincronizar)
      |
      |  --- SDD + ENTREGA ---
      |
      |  plan.md              Verdade tecnica (apos /plan)
      |  tasks.md             Decomposicao por US (apos /tasks)
      |  Branch feature/.../usN  Isolamento da US
      |  PR da US             Integracao na branch da feature
      v
   FLYWHEEL
```

### Cadeia de dependencia

| Artefato | Depende de | Alimenta |
|---|---|---|
| Matriz CSD (M1) | Reuniao sponsors | Visao Produto (M2) |
| Visao Produto + OKRs (M2) | M1 | Personas + Jornada (M3) |
| Protopersona + Jornada (M3) | M2 | USM (M4) |
| USM + Fibonacci (M4) | M3 | Prototipo + Feature Framing (M5) |
| Contexto Geral (M5) | M1-M4 acumulados | Diagrama C4 + constitution.md |
| Contexto do Epico (M5) | M4 + M5 | /specify (referencia) |
| Prototipo HiFi (M5) | M4 | /specify (link Figma via MCP) |
| Feature Framing (M5) | M4 | PO escolhe features para /specify |
| Diagrama C4 + constitution.md | Contexto Geral | /plan, /specify (restricoes), devs |
| `spec.md` | Feature Framing + Contexto Epico + Figma + C4 | `plan.md`, Board |
| Board | `spec.md` validado (/sincronizar: Epico → Feature → USs) | Rastreabilidade |
| `plan.md` | `spec.md` validado + C4 + constitution.md | `tasks.md` |
| `tasks.md` | `plan.md` + `spec.md` | `/implement` |

---

## Gates consolidados

| Gate | Transicao | O que garante |
|---|---|---|
| **Contexto de Dores** | M1 → M2 | Equipe tem entendimento compartilhado do problema |
| **Estrategia Validada** | M2 → M3 | Visao e metricas alinhadas com sponsors |
| **Jornada Humanizada** | M3 → M4 | Jornada do usuario mapeada e validada |
| **Backlog Priorizado** | M4 → M5 | Epicos e features fatiados com prioridade |
| **Prototipo Validado** | M5 → Gate Handover | Prototipo HiFi aprovado, 4 artefatos prontos |
| **Gate Handover** | UX → Arquitetura + SDD | 4 artefatos entregues e verificados no epico do board |
| **Arquitetura pronta** | Arquitetura → Ciclo Features | C4 + constitution.md disponiveis |
| **Ready para tecnico** | Ciclo Features → SDD Entrega | Spec validado, publicado e rastreavel no board |
| **Escopo explicito da US** | SDD → /tasks + /implement | O _how loop_ nao opera com escopo solto |

---

## Personas e responsabilidades

| Persona | UX Upstream (M1-M5) | Gate Handover + Arquitetura | Ciclo Features SDD | Entrega SDD |
|---|---|---|---|---|
| **UX** | Conduz M1-M5, constroi prototipos, mapeia jornadas | Entrega artefatos, valida checklist | — | — |
| **Stakeholder** | Participa de M1-M2, valida jornada e prototipos | Aceita handover | — | — |
| **Arquiteto** | Observa restricoes tecnicas (M4) | Desenha C4 + constitution.md | Referencia tecnica | — |
| **PO** | Participa de M2-M5, valida prioridades | Valida completude do handover | Escreve features (/specify), valida (/clarify), publica (/sincronizar) | Valida spec |
| **TL** | Observa viabilidade (M4-M5) | — | Valida features (/clarify) | Fecha plan, contratos |
| **Dev** | — | — | — | Assume US, executa /tasks + /implement |
| **Agente** | Input IA nos modulos M1-M5 | — | Gera USs no /specify, executa /sincronizar | Opera /tasks + /implement + checks |

**Regra invariante**: O agente nunca decide. Ele gera, executa e valida dentro do harness. Decisoes sao das pessoas. Isso preserva o principio **humans in the loop** do AIDD.

---

## Modelo de assistencia de IA

| Etapa | Papel humano | Papel do agente | Modelo |
|---|---|---|---|
| M1-M5 (UX) | UX conduz workshops e prototipa | IA recebe transcricoes, atas, resumos e gera inputs | **Assistente** |
| Gate Handover | PO valida completude | — | — |
| Arquitetura | Arquiteto desenha C4 + constitution | IA pode auxiliar na geracao de rascunhos | **Assistente** |
| /specify | PO escreve a feature | Agente gera USs a partir da feature escrita | **Gerador** |
| /clarify | PO + TL validam e refinam | Agente identifica gaps e edge cases | **Provocador** |
| /sincronizar | PO decide publicar | Agente grava no Azure DevOps | **Executor** |
| /plan | TL fecha recorte tecnico | Agente estrutura contratos e riscos | **Estruturador** |
| /tasks | Dev assume US | Agente decompoe em tarefas acionaveis | **Decompositor** |
| /implement | Dev valida resultado | Agente implementa a US assumida | **Implementador** |
| Flywheel | Time analisa feedback | Agente identifica padroes de retrabalho | **Analista** |

**Harness**: Templates, checklists, gates, C4 e constitution.md sao o harness. O agente opera exclusivamente dentro dele. As pessoas projetam o _why loop_.

---

## Anti-patterns

### No upstream (UX M1-M5)

| Anti-pattern | Por que e perigoso |
|---|---|
| Pular modulos (M1 direto para M4) | Fatiamento sem entendimento do problema gera features desconectadas |
| Prototipo sem validacao com stakeholder | Fluxos bonitos que ninguem testou; jornada nao validada |
| Feature Framing sem priorizacao | PO recebe lista sem criterio; dificulta escolha no /specify |
| Contexto Geral superficial | Arquitetura e constitution ficam genericos; restricoes nao previstas |

### No Gate Handover

| Anti-pattern | Por que e perigoso |
|---|---|
| Handover sem checklist formal | Artefatos faltantes descobertos no meio do /specify |
| Prototipo sem link acessivel | PO nao consegue referenciar Figma no /specify |
| Feature Framing nao cadastrado no board | Perda de rastreabilidade entre features e epico |

### No ciclo de features

| Anti-pattern | Por que e perigoso |
|---|---|
| /specify sem referenciar Contexto do Epico | Features nascem desconectadas do epico |
| /specify sem link do Figma | USs geradas sem base visual; gaps de interface |
| /clarify sem TL presente | Edge cases tecnicos nao identificados |
| Features escritas antes da Arquitetura | Restricoes arquiteturais nao previstas geram retrabalho |

### Na entrega SDD

| Anti-pattern | Por que e perigoso |
|---|---|
| /tasks sem US assumida com escopo explicito | Agente decompoe a feature inteira |
| Board como fonte funcional primaria | Board deve espelhar o spec, nao substitui-lo |
| PR de US direto para main | Quebra isolamento da branch integradora |
| Hotfix tratado como caminho padrao | Hotfix e excecao, nao fluxo normal |

---

## Referencias conceituais

| Tecnica / Referencia | Autor | Onde aparece no fluxo |
|---|---|---|
| **Design Thinking** | Design Council / IDEO | M1 (Empatia, divergir-convergir) |
| **Golden Circle** | Simon Sinek | M2 (Why → How → What) |
| **Lean UX** | Jeff Gothelf | M2 (Hipoteses, OKRs orientados a outcome) |
| **User Centered Design** | Don Norman / ISO 9241 | M3 (Personas, jornada) |
| **Lean Inception** | Paulo Caroli | M4 (Visao, personas, features, sequenciador) |
| **Design Sprint** | Jake Knapp (Google Ventures) | M4 (Prototipacao rapida, validacao) |
| **User Story Mapping** | Jeff Patton | M4 (Backbone de atividades + stories) |
| **Agile Prototyping** | — | M5 (HiFi, happy path, fluxos) |
| **Spec-Driven Development** | GitHub / Spec Kit | Ciclo Features + Entrega SDD |
| **BDD** | Dan North / Matt Wynne | /clarify (exemplos, criterios de aceite) |
| **C4 Model** | Simon Brown | Passo de Arquitetura |
| **Harness Engineering** | Kief Morris / Martin Fowler | Modelo geral — templates, gates, guardrails sao o harness |
| **Humans in the loop** | AIDD / Fowler-Morris | Principio invariante em todo o fluxo |

---

## Alinhamento com referencias externas

| Principio | Como aparece no fluxo integrado |
|---|---|
| **Double Diamond** (Design Council) | M1-M3 sao o primeiro diamante (divergir → convergir no problema). M4-M5 sao o segundo diamante (divergir em solucoes → convergir em prototipos validados). |
| **4 Riscos** (Cagan/SVPG) | Valor e usabilidade validados no upstream (M1-M5). Viabilidade e negocio validados no passo de Arquitetura e /clarify. |
| **Opportunity Solution Tree** (Teresa Torres) | M2 define outcomes, M3 mapeia oportunidades, M4 gera solucoes, M5 valida. |
| **User Story Mapping** (Jeff Patton) | M4 usa USM como backbone. Feature Framing e o slice priorizado. |
| **Harness Engineering** (Morris/Fowler) | Templates + checklists + gates + C4 + constitution sao o harness. O agente opera dentro dele. As pessoas projetam o _why loop_. |
| **Flywheel de melhoria** | Feedback do delivery retroalimenta tanto o harness SDD quanto os modulos UX upstream. |
| **Humans in the loop** (AIDD) | Nenhuma decisao de fluxo e delegada ao agente. UX conduz upstream, PO+TL conduzem features, devs conduzem entrega. O agente opera com guardrails. |

---

## Proximos passos

| # | Acao | Status |
|---|---|---|
| 1 | ~~Criar template de Gate Handover~~ — e convencao de board, nao template Spec Kit | Documentado |
| 2 | ~~Criar template de Feature Framing~~ — e convencao de board, nao template Spec Kit | Documentado |
| 3 | ~~Criar template base de `constitution.md`~~ — ja existe como comando nativo `/speckit.constitution` | Nativo |
| 4 | Atualizar `/specify` (BE+FE) para exigir Contexto do Epico + Figma link (MCP) | Concluido |
| 5 | Atualizar `/plan` (BE+FE) para referenciar diagrama C4 em `.specify/memory/` | Concluido |
| 6 | ~~Atualizar `docs/aidd/README.md` com o workflow integrado~~ | Concluido |
| 7 | Avaliar se modulos M1-M5 precisam de guia operacional detalhado (ownership da equipe UX) | Pendente |
| 8 | Documentar convencoes de artefatos no board (como cadastrar Feature Framing, Contexto do Epico) | Documentado neste arquivo |

O modelo e incremental — os presets e convencoes podem evoluir conforme a pratica estabilizar.
