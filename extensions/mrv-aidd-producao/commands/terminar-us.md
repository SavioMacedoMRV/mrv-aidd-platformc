---
description: Finalizar a historia de usuario ativa com validacoes finais, commit no padrao da constituicao e abertura de PR para a branch base da feature usando os MCPs do GitHub.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

You **MUST** use the GitHub MCP pull request management tools to create the pull request for this workflow. Do **NOT** ask the user to open the PR manually if the MCP tools are available.

## Goal

Encerrar a US atual depois da implementacao, garantindo que a branch da US esteja pronta para revisao e que exista uma PR aberta da branch da US para a branch base da feature.

## Outline

1. Identifique a branch atual e a branch base da feature:
   - Se a branch atual estiver no formato `feature/<feature-branch>/usN`, use `<feature-branch>` como branch base.
   - Se a branch atual nao estiver em uma branch filha de US, interrompa e oriente o usuario a executar primeiro `/speckit.mrv-aidd-producao.configurar-us USn` ou a trocar para a branch correta.
   - Extraia tambem o identificador da US a partir do sufixo `usN`.

2. Determine o escopo de finalizacao:
   - Trate `$ARGUMENTS` como a fonte primaria para o identificador da US e para qualquer titulo complementar de commit ou PR.
   - Se `$ARGUMENTS` trouxer `US1`, `us1` ou apenas `1`, normalize para `US1`.
   - Se houver divergencia entre a US informada e a US derivada da branch atual, pare e use `vscode_askQuestions` para confirmar qual US deve ser finalizada.

3. Resolva o ID da US no Azure DevOps:
   - Leia o `spec.md` ativo e procure, dentro do bloco da US atual, a linha `**ID da US no Azure DevOps**: <valor>`.
   - Se o ID nao estiver registrado no `spec.md`, leia `.specify/extensions/mrv-aidd-producao/us-sync-map.json` quando ele existir e procure a entrada correspondente ao `specKey` da US atual, como `US1`.
   - Extraia o `workItemId` da historia sincronizada.
   - Se nao encontrar um `workItemId` confiavel para a US atual, interrompa e oriente o usuario a executar primeiro `/speckit.mrv-aidd-producao.sincronizar-us-devops` ou a informar o ID correto da US.
   - Trate esse ID como o valor que substitui o placeholder `#task` da constituicao, usando a sintaxe compativel com GitHub e Azure Boards: `AB#<workItemId>`.

4. Valide o estado local antes de commitar:
   - Use `run_in_terminal` para verificar `git status --short`.
   - Se nao houver alteracoes locais, pergunte via `vscode_askQuestions` se o usuario quer apenas abrir ou atualizar a PR sem novo commit.
   - Se houver conflitos, arquivos nao rastreados inesperados ou alteracoes claramente fora do escopo da US, pare e explique o que precisa ser resolvido antes de continuar.
   - Verifique se o `tasks.md` da feature existe e, quando possivel, confirme que as tarefas da US em escopo estao concluidas ou explicitamente aceitas pelo usuario para finalizacao.

5. Execute uma verificacao final minima:
   - Se existir um task/build padrao apropriado para validacao do repositorio, prefira executa-lo antes do commit.
   - Neste repositorio, prefira pelo menos a task `build-backend-solution` quando a mudanca afetar codigo de backend.
   - Se a validacao falhar, nao siga para commit ou PR ate o usuario decidir como tratar.

6. Monte a mensagem de commit no padrao da constituicao:
   - Use o padrao observado neste repositorio: `feature AB#<workItemId>: <resumo curto em portugues>`.
   - A documentacao oficial do Azure Boards para GitHub usa `AB#<ID>` em commits e descricoes de PR para criar o link de desenvolvimento com o work item.
   - O resumo deve mencionar a US ou o resultado entregue de forma curta e objetiva.
   - Se `$ARGUMENTS` trouxer um resumo explicito, aproveite-o. Caso contrario, derive um resumo a partir do contexto da US, dos arquivos alterados e do `tasks.md`.
   - Se ainda houver ambiguidade relevante sobre a mensagem, use `vscode_askQuestions` antes de commitar.

7. Gere o commit:
   - Use `run_in_terminal` para executar `git add -A` e `git commit -m "<mensagem>"`.
   - Se nao houver mudancas para commitar e o usuario tiver confirmado continuar sem commit novo, pule esta etapa.
   - Se o commit falhar, interrompa e reporte a falha sem tentar abrir PR.

8. Publique a branch da US se necessario:
   - Verifique se a branch atual tem upstream remoto.
   - Se nao tiver, use `run_in_terminal` para executar `git push -u origin <branch-atual>`.
   - Se ja tiver upstream, use `git push` para garantir que a PR sera aberta com o estado mais recente.

9. Abra a pull request com os MCPs do GitHub:
   - Ative os tools de gerenciamento de pull request do GitHub quando necessario.
   - Crie a PR com origem na branch atual `feature/<feature-branch>/usN` e destino na branch base da feature `<feature-branch>`.
   - Use um titulo claro em portugues, preferencialmente no formato `USN: <resumo curto>`.
   - No corpo da PR, resuma:
     - referencia `AB#<workItemId>` em uma linha dedicada para garantir o vinculo com Azure Boards
     - objetivo da US
     - principais alteracoes
     - validacoes executadas
     - observacoes pendentes, se existirem
   - Nao dependa do titulo da PR para o link com Azure Boards. Use `AB#<workItemId>` no corpo da PR, porque a integracao oficial cria o vinculo a partir da descricao.
   - Se ja existir uma PR aberta da mesma branch para a mesma base, nao crie duplicata; recupere a existente e reporte o link ao usuario.

10. Reporte o encerramento da US ao usuario em portugues do Brasil:
   - branch da US finalizada
   - branch base da feature
   - ID da US no Azure DevOps usado no vinculo
   - commit criado ou motivo de nao ter sido criado
   - status do push
   - PR criada ou PR existente reutilizada
   - proximo passo recomendado: revisao da PR e, depois de aprovada, merge para a branch base da feature

## Regras adicionais

- Sempre que precisar pedir confirmacao, desambiguacao ou autorizacao para seguir sem commit novo, use `vscode_askQuestions`.
- Nao abra PR da branch da US direto para `main`; o destino correto e sempre a branch base da feature.
- Nao use GitHub CLI, browser automation ou instrucoes manuais para criar a PR se os MCPs do GitHub estiverem disponiveis.
- O placeholder `#task` da constituicao deve ser interpretado neste fluxo como o ID do work item do Azure DevOps usando a sintaxe `AB#<workItemId>`.
- Nao faca amend de commit automaticamente.
- Se houver falha em build, testes, push ou criacao da PR, pare no primeiro erro e reporte exatamente o que faltou.
- Todas as mensagens ao usuario devem estar em portugues do Brasil, preservando comandos, caminhos e identificadores tecnicos quando necessario.