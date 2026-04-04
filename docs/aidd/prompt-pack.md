# Prompt Pack Operacional do AIDD

Este prompt pack foi escrito para uso real por PO, TL, Devs e agentes no fluxo AIDD. Ele transforma o processo em instruções reutilizáveis, sem obrigar o time a reinventar o framing de cada etapa toda vez.

Os prompts abaixo operacionalizam o processo definido em [README.md](./README.md). Eles não substituem a definição oficial do fluxo; apenas a transformam em instruções reutilizáveis por etapa.

---

## Índice

- [1. Leitura da feature do upstream](#1-leitura-da-feature-do-upstream)
- [2. Prompt de /speckit.specify](#2-prompt-de-speckitspecify)
- [3. Prompt de /speckit.clarify](#3-prompt-de-speckitclarify)
- [4. Prompt de derivação para board](#4-prompt-de-derivação-para-board)
- [5. Prompt de /speckit.plan](#5-prompt-de-speckitplan)
- [6. Prompt de commitment](#6-prompt-de-commitment)
- [7. Prompt de /tasks por US](#7-prompt-de-tasks-por-us)
- [8. Prompt de /implement por US](#8-prompt-de-implement-por-us)
- [9. Prompt de review por US](#9-prompt-de-review-por-us)
- [10. Prompt de análise de paralelismo](#10-prompt-de-análise-de-paralelismo)
- [11. Prompt de tratamento de dependência cruzada](#11-prompt-de-tratamento-de-dependência-cruzada)
- [12. Prompt de hotfix](#12-prompt-de-hotfix)
- [13. Prompt de retrospectiva e flywheel](#13-prompt-de-retrospectiva-e-flywheel)
- [Como usar o prompt pack](#como-usar-o-prompt-pack)

---

## 1. Leitura da feature do upstream

```text
Leia a feature abaixo como entrada de upstream. Não a trate como verdade final. Extraia objetivo,
restrições, critérios de qualidade, ownership provável, riscos de ambiguidade, gaps funcionais e
pontos que precisam ser clarificados no downstream. Entregue:
1. Resumo executivo em até 5 linhas.
2. Lista de ambiguidades críticas.
3. Lista de gaps funcionais ou regras faltantes.
4. Sinais de dependências FE/BE.
5. Recomendação de próximo passo no AIDD.

Feature:
[colar feature]
```

---

## 2. Prompt de /speckit.specify

```text
Transforme a feature de upstream em `spec.md` executável no modelo AIDD. Não apenas transcreva o
texto recebido. Identifique, explicite e feche os gaps funcionais que impactem entendimento,
comportamento, testes ou rastreabilidade. Garanta que cada história tenha ownership explícito, teste
independente e critérios verificáveis. Preserve dependências cruzadas como handoff, e não como
mistura de ownership.
```

---

## 3. Prompt de /speckit.clarify

```text
Analise o `spec.md` atual e reduza apenas ambiguidades que afetem arquitetura, comportamento,
rastreabilidade, testes ou decomposição por US. Não invente escopo novo. Se surgir trabalho de outra
trilha, registre como follow-up em vez de cruzar ownership.
```

---

## 4. Prompt de derivação para board

```text
A partir do `spec.md` validado, derive a estrutura que deve aparecer no board. O board deve espelhar
o spec, não a feature bruta do upstream. Liste:
1. Título da Feature.
2. USs derivadas com prioridade e ownership.
3. Critério mínimo para considerar a feature pronta para planejamento técnico.
4. Riscos de publicar USs ainda ambíguas.
```

---

## 5. Prompt de /speckit.plan

```text
Feche o `plan.md` técnico a partir do `spec.md` validado. Trate o plan como fonte de verdade
técnica. Identifique fundação compartilhada, contratos, riscos de paralelismo, pontos de colisão,
estratégia de rollout e checks. Não reabra discussões funcionais já resolvidas no spec.
```

---

## 6. Prompt de commitment

```text
Com base em `spec.md`, `plan.md` e board atual, proponha o commitment da sprint ou da janela de
execução. Liste quais USs entram, quem assume cada uma, quais dependências bloqueiam paralelismo,
o que precisa ser foundation primeiro e quais saem do escopo agora.
```

---

## 7. Prompt de /tasks por US

```text
Gere ou refine `tasks.md` apenas para a US informada. Preserve `US1` como fase inicial se ela
carregar fundação compartilhada, mas não decomponha a feature inteira. Escopo atual: [USn].
Branch esperada: `feature/<feature-branch>/usN`. Se o escopo não estiver explícito, pare e peça
desambiguação.
```

---

## 8. Prompt de /implement por US

```text
Implemente apenas a US informada, usando `spec.md`, `plan.md` e `tasks.md` como contexto. Não
avance para outras USs. Respeite a branch `feature/<feature-branch>/usN`, execute checks locais e
prepare a entrega para PR na branch integradora da feature.
```

---

## 9. Prompt de review por US

```text
Revise esta entrega com foco exclusivo na US informada. Verifique aderência ao `spec.md`, ao
`plan.md`, ao recorte técnico da US, aos contratos e aos checks combinados. Aponte bugs, regressões,
lacunas de teste, violações de ownership e riscos de colisão com outras USs.
```

---

## 10. Prompt de análise de paralelismo

```text
Analise se estas USs podem seguir em paralelo no mesmo repositório. Considere fundação
compartilhada, contratos, arquivos compartilhados, migrations, schemas, roteamento central,
observabilidade e feature flags. Classifique como:
- paralelo seguro;
- paralelo seguro após foundation;
- paralelo inseguro.

Explique a decisão e recomende a ordem.
```

---

## 11. Prompt de tratamento de dependência cruzada

```text
Analise a dependência cruzada entre FE e BE ou entre duas USs diferentes. Diga o que pertence ao
spec funcional, o que pertence ao plan técnico, o que precisa virar contrato e o que precisa ser
tratado como foundation compartilhada. Não duplique a feature; mantenha um único fio de
rastreabilidade.
```

---

## 12. Prompt de hotfix

```text
Trate este caso como hotfix, fora do fluxo SDD normal. Registre contexto, impacto, causa provável,
estratégia de mitigação, validação mínima, rollback e comunicação necessária. Não decomponha a
feature inteira em várias USs. Ao final, aponte o que deve voltar para o fluxo normal do AIDD
como melhoria estrutural.
```

---

## 13. Prompt de retrospectiva e flywheel

```text
Revise a entrega concluída e alimente o flywheel do AIDD. Identifique:
1. O que funcionou no spec, plan, tasks e implement.
2. Quais ambiguidades escaparam.
3. Quais guardrails faltaram.
4. Melhorias em prompts, harness, checklists, templates e contratos.
5. Ajustes que devem retroalimentar o upstream.
```

---

## Como usar o prompt pack

- Use os prompts como base, não como ritual burocrático.
- Troque apenas o contexto da feature, ownership, repositório e restrições reais.
- Mantenha a coerência entre prompt, spec, plan, board e diagrama oficial.
