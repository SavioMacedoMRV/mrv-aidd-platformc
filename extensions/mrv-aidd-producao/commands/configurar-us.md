---
description: Criar ou reutilizar a branch de trabalho da historia de usuario ativa preservando a branch base da feature para os scripts nativos do Speckit.
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

You **MUST** use Azure DevOps MCP tools for every Azure DevOps read or write in this workflow. Do **NOT** use Azure CLI, PATs, raw REST calls, browser automation, or shell scripts to consultar ou atualizar work items.

## Outline

1. Determine a branch base da feature atual:
   - Se a branch git atual estiver no formato `feature/<feature-branch>/usN`, use `<feature-branch>` como branch base.
   - Se a branch git atual estiver no formato nativo do Speckit (`###-feature-name` ou `YYYYMMDD-HHMMSS-feature-name`), use a propria branch atual como branch base.
   - Se nao for possivel identificar uma branch base valida, interrompa e oriente o usuario a executar primeiro `/speckit.specify` ou a trocar para a branch da feature.

2. Localize a feature ativa, o spec e o contexto do Azure DevOps:
   - Execute `.specify/scripts/powershell/check-prerequisites.ps1 -Json -PathsOnly` a partir da raiz do repositorio.
   - Capture pelo menos `FEATURE_DIR` e `FEATURE_SPEC`.
   - Leia o `spec.md` ativo para extrair `Organizacao`, `Projeto` e a referencia da Feature pai em `## Rastreabilidade Azure DevOps`.
   - Leia `.specify/extensions/mrv-aidd-producao/us-sync-map.json` quando ele existir, mas trate-o apenas como cache auxiliar e nao como fonte obrigatoria.
   - Parseie todas as historias de usuario do `spec.md`, capturando ao menos `specKey`, titulo e, quando existir, `**ID da US no Azure DevOps**`.

3. Determine qual US sera assumida nesta execucao:
   - Trate `$ARGUMENTS` como a fonte primaria do identificador da US.
   - Aceite `US1`, `us1` ou apenas `1` e normalize para `us1`.
   - Quando o usuario nao informar a US com clareza, monte a lista de opcoes a partir das historias do `spec.md` em vez de depender do mapa de sincronizacao.
   - Para cada historia candidata, resolva o `workItemId` por esta ordem:
     1. `**ID da US no Azure DevOps**` registrado no proprio `spec.md`
     2. entrada correspondente no `us-sync-map.json`, quando existir
     3. match deterministico por titulo entre a historia do spec e os child work items da Feature pai no Azure DevOps
   - Quando o match por titulo encontrar exatamente um child work item confiavel, trate esse resultado como valido para a execucao atual.
   - Para cada `specKey` candidato com `workItemId` resolvido, busque o work item correspondente via MCP
     - exclua da lista todas as USs cujo estado atual esteja em categoria concluida ou em estados finais conhecidos, como `Done`, `Closed`, `Completed`, `Concluido`, `Concluida`, `Cancelado` ou equivalentes do processo
     - se o metadata do tipo `User Story` estiver disponivel via MCP, prefira a categoria de workflow `Completed` para decidir o que e considerado concluido
     - apresente em `vscode_askQuestions` apenas as USs ainda nao concluidas
   - Se nao for possivel resolver nenhum `workItemId`, ainda assim apresente as USs do spec em `vscode_askQuestions`, mas informe que o estado no Azure DevOps nao pode ser verificado nem atualizado para esses itens ate que a sincronizacao seja concluida.

4. Mova a US selecionada para `DEV` no Azure DevOps quando houver work item sincronizado:
   - Resolva o `workItemId` da US selecionada pela mesma ordem: `spec.md`, `us-sync-map.json`, match confiavel por titulo nos filhos da Feature.
   - Se existir `workItemId`, consulte o work item atual por MCP antes de alterar estado.
   - Se o work item ja estiver concluido, interrompa e informe que USs concluidas nao devem ser reassumidas por este comando.
   - Se o estado `DEV` existir para o processo dessa `User Story`, atualize o campo de estado do work item para `DEV` usando MCP.
   - Se o processo nao aceitar o valor `DEV` ou o MCP retornar erro de transicao invalida, pare e reporte o erro com clareza; nao siga silenciosamente.
   - Se nao houver `workItemId`, nao tente atualizar estado no Azure DevOps.

5. Crie ou reutilize a branch filha da US:
   - Monte a branch alvo como `feature/<feature-branch>/usN`.
   - Use a ferramenta `run_in_terminal` para executar `git checkout <branch>` quando ela ja existir ou `git checkout -b <branch>` quando ainda nao existir.
   - Na mesma sessao de terminal, defina `$env:SPECIFY_FEATURE = '<feature-branch>'` para manter os scripts nativos do Speckit apontando para a pasta da feature base.

6. Reporte o resultado ao usuario em portugues do Brasil:
   - branch base da feature reconhecida
   - branch da US ativa apos o comando
   - status da atualizacao do work item no Azure DevOps para `DEV`, quando aplicavel
   - proximo passo recomendado: `/speckit.tasks USn` ou `/speckit.implement USn`

## Regras adicionais

- Sempre que precisar pedir confirmacao, desambiguacao ou o identificador da US, use `vscode_askQuestions`.
- Nao apresente em `vscode_askQuestions` opcoes de US que ja estejam concluidas no Azure DevOps.
- Nao altere a branch base da feature; apenas crie ou reutilize a branch filha da US.
- Preserve a nomenclatura nativa da branch principal criada pelo Speckit.
- Quando houver `**ID da US no Azure DevOps**` no spec, esse dado deve ser tratado como a referencia primaria do work item.
- Quando houver mapeamento da US para Azure DevOps, este comando deve tratar o work item como a fonte de verdade para decidir se a US ainda pode entrar em desenvolvimento.
- Todas as mensagens ao usuario devem estar em portugues do Brasil, preservando comandos, caminhos e identificadores tecnicos quando necessario.
