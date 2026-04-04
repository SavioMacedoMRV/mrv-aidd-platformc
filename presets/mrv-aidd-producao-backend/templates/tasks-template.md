---
description: "Template de lista de tarefas para implementacao da funcionalidade"
---

# Tarefas: [NOME DA FUNCIONALIDADE]

**Entrada**: Documentos de design de `/specs/[###-nome-da-funcionalidade]/`
**Pre-requisitos**: `plan.md` (obrigatorio), `spec.md` (obrigatorio para historias de usuario), `research.md`, `data-model.md`, `contracts/`

**Testes**: Tarefas de teste sao OBRIGATORIAS sempre que a funcionalidade alterar comportamento, contratos, validacao, persistencia, fluxos de UI, observabilidade, autenticacao, autorizacao ou integracoes. Omita apenas em atividades nao comportamentais e documente o motivo no plano.

**Organizacao**: As tarefas sao agrupadas por historia de usuario para permitir implementacao e validacao independentes de cada historia.

## Guardrails AIDD

- Este `tasks.md` organiza a feature por US, mas cada execucao de `/speckit.tasks` deve informar a US em foco.
- `/tasks` so pode ser refinado depois que a US foi assumida e o escopo ficou explicito.
- Sem escopo explicito, o agente tende a decompor a feature inteira; isso deve ser evitado.
- Hotfix nao deve reaproveitar este fluxo como se fosse uma feature normal.

## Recorte operacional desta execucao

- **USs em foco nesta execucao**: [Liste as USs realmente assumidas pelo dev ou par]
- **Branch recomendada por US**: `feature/<feature-branch>/usN`
- **Regra de atualizacao**: detalhar apenas as secoes das USs em escopo e preservar as demais, exceto quando `US1` carregar foundation compartilhada.

## Formato: `[ID] [P?] [Historia] Descricao`

- **[P]**: Pode executar em paralelo (arquivos diferentes, sem dependencias)
- **[Historia]**: A qual historia de usuario esta tarefa pertence (ex.: US1, US2, US3)
- Inclua caminhos de arquivo exatos nas descricoes

## Convencoes de caminho

- **Codigo principal**: use os diretorios reais do repositorio para a funcionalidade (ex.: `src/`, `app/`, `packages/`, `lib/`)
- **Testes unitarios**: use o local real definido pelo repositorio para testes unitarios
- **Testes de integracao/contrato/e2e**: use os locais reais definidos pelo repositorio para esses tipos de validacao
- **Ativos compartilhados de teste**: mantenha fixtures, builders, mocks, stubs e utilitarios em um local compartilhado quando o repositorio tiver essa convencao
- Sempre referencie caminhos reais e completos nas tarefas geradas

<!--
  ============================================================================
  IMPORTANTE: As tarefas abaixo sao APENAS EXEMPLOS ilustrativos.

  O comando /speckit.tasks DEVE substituir isso por tarefas reais com base em:
  - Historias de usuario de spec.md (com prioridades P1, P2, P3...)
  - Requisitos da funcionalidade de plan.md
  - Entidades de data-model.md
  - Endpoints de contracts/

  As tarefas DEVEM ser organizadas por historia de usuario para que cada historia possa ser:
  - Implementada de forma independente
  - Testada de forma independente
  - Entregue como incremento de MVP

  NAO mantenha estas tarefas de exemplo no tasks.md gerado.
  ============================================================================
-->

## Fase 1: Historia de Usuario 1 - [Titulo] (Prioridade: P1) 🎯 MVP

**Objetivo**: [Breve descricao do que esta historia entrega]

**Teste independente**: [Como verificar esta historia isoladamente]

### Preparacao compartilhada e fundacional da Historia de Usuario 1

> **CRITICO**: Qualquer setup compartilhado ou pre-requisito bloqueante da funcionalidade DEVE ficar dentro da `US1`, antes da implementacao das demais historias.

- [ ] T001 [US1] Confirmar os diretorios reais de codigo e teste afetados pela funcionalidade
- [ ] T002 [P] [US1] Estender ativos compartilhados de teste quando novas fixtures, assercoes, serializadores, mocks, builders ou utilitarios forem necessarios
- [ ] T003 [P] [US1] Documentar necessidades especificas de execucao, ambiente ou validacao da funcionalidade em `specs/[###-nome-da-funcionalidade]/quickstart.md`
- [ ] T004 [US1] Configurar ou atualizar estruturas, schemas, contratos, componentes base ou modelos compartilhados dos quais as demais historias dependem
- [ ] T005 [P] [US1] Implementar mudancas compartilhadas de autenticacao, autorizacao, contexto de usuario, estado global ou configuracao quando necessario
- [ ] T006 [P] [US1] Configurar ou ajustar roteamento, modulos, composicao da aplicacao, middlewares ou pipeline compartilhado conforme o tipo de projeto
- [ ] T007 [US1] Criar ou atualizar contratos, eventos, interfaces, schemas ou componentes base compartilhados
- [ ] T008 [US1] Configurar tratamento de erro, logging, telemetria, monitoracao, estados de falha ou observabilidade compartilhados
- [ ] T009 [US1] Definir o ambiente minimo de validacao automatizada e local necessario para esta funcionalidade

### Testes da Historia de Usuario 1 ⚠️

> **NOTA: Escreva estes testes PRIMEIRO, garanta que FALHEM antes da implementacao e mantenha cada teste com comentarios explicitos `// Arrange`, `// Act` e `// Assert`**

- [ ] T010 [P] [US1] Adicionar ou atualizar testes unitarios para [modulo/componente/servico] em `[CAMINHO_REAL_DO_TESTE_UNITARIO]`
- [ ] T011 [P] [US1] Adicionar ou atualizar testes de contrato, integracao ou interface para [operacao/fluxo] em `[CAMINHO_REAL_DO_TESTE_RELEVANTE]`
- [ ] T012 [P] [US1] Adicionar ou atualizar cobertura integrada, e2e, smoke ou operacional para [jornada] em `[CAMINHO_REAL_DO_TESTE_RELEVANTE]`

### Implementacao da Historia de Usuario 1

- [ ] T013 [P] [US1] Criar ou atualizar [entidade/schema/componente base] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T014 [P] [US1] Criar ou atualizar [entidade/schema/componente complementar] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T015 [US1] Implementar [servico/logica/estado/controle] em `[CAMINHO_REAL_DO_ARQUIVO]` (depende de T013, T014)
- [ ] T016 [US1] Implementar [endpoint/tela/modulo/fluxo/feature] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T017 [US1] Adicionar validacao, tratamento de erro, feedback ao usuario ou mapeamento de resultados compartilhados
- [ ] T018 [US1] Adicionar observabilidade, acessibilidade, monitoracao, logging ou comportamento operacional quando necessario

**Checkpoint**: Neste ponto, a Historia de Usuario 1 deve estar totalmente funcional e testavel de forma independente

---

## Fase 2: Historia de Usuario 2 - [Titulo] (Prioridade: P2)

**Objetivo**: [Breve descricao do que esta historia entrega]

**Teste independente**: [Como verificar esta historia isoladamente]

### Testes da Historia de Usuario 2 ⚠️

- [ ] T019 [P] [US2] Adicionar ou atualizar testes unitarios para [modulo/componente/servico] em `[CAMINHO_REAL_DO_TESTE_UNITARIO]`
- [ ] T020 [P] [US2] Adicionar ou atualizar testes de contrato, integracao ou interface para [operacao/fluxo] em `[CAMINHO_REAL_DO_TESTE_RELEVANTE]`
- [ ] T021 [P] [US2] Adicionar ou atualizar cobertura integrada, e2e, smoke ou operacional para [jornada] em `[CAMINHO_REAL_DO_TESTE_RELEVANTE]`

### Implementacao da Historia de Usuario 2

- [ ] T022 [P] [US2] Criar ou atualizar [entidade/schema/componente] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T023 [US2] Implementar [servico/logica/estado/controle] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T024 [US2] Implementar [endpoint/tela/modulo/feature] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T025 [US2] Integrar com componentes da Historia de Usuario 1 e ativos compartilhados de teste quando necessario

**Checkpoint**: Neste ponto, as Historias de Usuario 1 E 2 devem funcionar independentemente

---

## Fase 3: Historia de Usuario 3 - [Titulo] (Prioridade: P3)

**Objetivo**: [Breve descricao do que esta historia entrega]

**Teste independente**: [Como verificar esta historia isoladamente]

### Testes da Historia de Usuario 3 ⚠️

- [ ] T026 [P] [US3] Adicionar ou atualizar testes unitarios para [modulo/componente/servico] em `[CAMINHO_REAL_DO_TESTE_UNITARIO]`
- [ ] T027 [P] [US3] Adicionar ou atualizar testes de contrato, integracao ou interface para [operacao/fluxo] em `[CAMINHO_REAL_DO_TESTE_RELEVANTE]`
- [ ] T028 [P] [US3] Adicionar ou atualizar cobertura integrada, e2e, smoke ou operacional para [jornada] em `[CAMINHO_REAL_DO_TESTE_RELEVANTE]`

### Implementacao da Historia de Usuario 3

- [ ] T029 [P] [US3] Criar ou atualizar [entidade/schema/componente] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T030 [US3] Implementar [servico/logica/estado/controle] em `[CAMINHO_REAL_DO_ARQUIVO]`
- [ ] T031 [US3] Implementar [endpoint/tela/modulo/feature] em `[CAMINHO_REAL_DO_ARQUIVO]`

**Checkpoint**: Todas as historias de usuario devem estar funcionalmente independentes neste ponto

---

[Adicione mais fases de historia de usuario conforme necessario, seguindo o mesmo padrao]

---

## Fase N: Polimento e preocupacoes transversais

**Objetivo**: Melhorias que afetam varias historias de usuario

- [ ] TXXX [P] Atualizacoes de documentacao nos caminhos reais de documentacao do repositorio
- [ ] TXXX Limpeza de codigo e refatoracao
- [ ] TXXX Otimizacao de desempenho em todas as historias
- [ ] TXXX [P] Cobertura adicional de unidade, contrato, integracao, e2e, smoke ou operacional nos caminhos reais de teste
- [ ] TXXX Endurecimento de seguranca
- [ ] TXXX Executar a validacao de quickstart.md

---

## Dependencias e ordem de execucao

### Dependencias entre fases

- **Historia de Usuario 1 (Fase 1)**: Comeca primeiro e concentra todo setup compartilhado e toda fundacao bloqueante da funcionalidade
- **Historias de usuario restantes (Fase 2+)**: Dependem da conclusao do bloco compartilhado dentro da US1
  - As historias podem seguir em paralelo depois que a US1 desbloquear os componentes compartilhados
  - Ou sequencialmente em ordem de prioridade (P1 → P2 → P3)
- **Polimento (Fase final)**: Depende da conclusao de todas as historias desejadas

### Dependencias entre historias de usuario

- **Historia de Usuario 1 (P1)**: DEVE ser a primeira historia da feature e carregar o setup/fundacao compartilhados
- **Historia de Usuario 2 (P2)**: Pode comecar depois que a US1 concluir o bloco compartilhado, mas deve continuar testavel de forma independente
- **Historia de Usuario 3 (P3)**: Pode comecar depois que a US1 concluir o bloco compartilhado, mas deve continuar testavel de forma independente

### Dentro de cada historia de usuario

- Os testes DEVEM ser escritos e FALHAR antes da implementacao
- A cobertura unitaria, de contrato, integracao, interface ou e2e DEVE ficar nos alvos corretos de validacao do repositorio
- Cada teste automatizado DEVE manter cenarios claros, independentes e observaveis
- Ativos compartilhados de teste devem ficar no local comum definido pelo repositorio, quando houver essa convencao
- Estruturas base antes da logica de negocio
- Logica principal antes das superficies de entrada e saida
- Implementacao principal antes da validacao integrada
- A historia deve estar completa antes de seguir para a proxima prioridade

### Oportunidades de paralelismo

- As tarefas compartilhadas da US1 marcadas com [P] podem rodar em paralelo
- Quando o bloco compartilhado da US1 terminar, as historias restantes podem comecar em paralelo (se a capacidade da equipe permitir)
- Todos os testes de uma historia de usuario marcados com [P] podem rodar em paralelo
- Models dentro de uma historia marcados com [P] podem rodar em paralelo
- Historias de usuario diferentes podem ser executadas em paralelo por membros diferentes da equipe

---

## Exemplo de paralelismo: Historia de Usuario 1

```text
Tarefa: "Adicionar ou atualizar testes unitarios para [modulo/componente/servico] em [CAMINHO_REAL_DO_TESTE_UNITARIO]"
Tarefa: "Adicionar ou atualizar testes de contrato, integracao ou interface para [operacao/fluxo] em [CAMINHO_REAL_DO_TESTE_RELEVANTE]"
Tarefa: "Adicionar ou atualizar cobertura integrada, e2e, smoke ou operacional para [jornada] em [CAMINHO_REAL_DO_TESTE_RELEVANTE]"

Tarefa: "Criar ou atualizar [Entidade1/schema/componente] em [CAMINHO_REAL_DO_ARQUIVO]"
Tarefa: "Criar ou atualizar [Entidade2/schema/componente] em [CAMINHO_REAL_DO_ARQUIVO]"
```

---

## Estrategia de implementacao

### MVP primeiro (somente Historia de Usuario 1)

1. Concluir o bloco compartilhado e fundacional dentro da Historia de Usuario 1
2. Concluir o restante da Historia de Usuario 1
3. **PARAR E VALIDAR**: Testar a Historia de Usuario 1 de forma independente
4. Fazer deploy ou demonstracao se estiver pronta

### Entrega incremental

1. Concluir a Historia de Usuario 1, incluindo setup e fundacao compartilhados → Testar de forma independente → Deploy/Demo (MVP!)
2. Adicionar Historia de Usuario 2 → Testar de forma independente → Deploy/Demo
3. Adicionar Historia de Usuario 3 → Testar de forma independente → Deploy/Demo
4. Cada historia agrega valor sem quebrar as anteriores

### Estrategia de equipe em paralelo

Com varios desenvolvedores:

1. A equipe conclui primeiro o bloco compartilhado dentro da Historia de Usuario 1
2. Quando a US1 desbloquear a base compartilhada:
   - Desenvolvedor A: Historia de Usuario 1
   - Desenvolvedor B: Historia de Usuario 2
   - Desenvolvedor C: Historia de Usuario 3
3. As historias sao concluidas e integradas independentemente

## Fluxo de branches e PRs

- A branch integradora da funcionalidade deve ser a branch nativa criada pelo Speckit, como `001-feature-name`
- Cada historia de usuario deve preferencialmente ser implementada em uma branch filha como `feature/<feature-branch>/us1`, `feature/<feature-branch>/us2` e assim por diante
- O PR de cada branch de historia de usuario deve ter como destino a branch base da feature, como `001-feature-name`
- O PR final para `main` deve sair apenas da branch base da feature, depois que as USs planejadas para a funcionalidade estiverem concluidas

---

## Observacoes

- Tarefas [P] = arquivos diferentes, sem dependencias
- O rotulo [Historia] vincula a tarefa a uma historia especifica para rastreabilidade
- Setup e fundacao compartilhados devem ser atribuídos a `US1`, nao a uma fase separada
- Cada historia de usuario deve ser concluivel e testavel de forma independente
- Verifique que os testes falham antes de implementar
- Nao marque testes como opcionais quando houver mudanca de comportamento
- Faca commit apos cada tarefa ou grupo logico
- Pare em cada checkpoint para validar a historia de forma independente
- Evite: tarefas vagas, conflitos no mesmo arquivo, dependencias entre historias que quebrem a independencia
