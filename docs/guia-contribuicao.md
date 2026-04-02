# Guia de Contribuicao e Evolucao

Este guia complementa o [README raiz](../README.md). O README explica como consumir a plataforma; este documento explica como evoluir a plataforma sem descaracterizar os pacotes existentes nem quebrar o modelo de reuso.

## Quando usar este guia

Consulte este documento quando voce precisar:

- decidir se uma mudanca nova deve entrar em extension ou preset;
- criar um pacote novo ou expandir um pacote existente;
- revisar os criterios minimos de manifesto, README e estrutura interna;
- validar se a mudanca continua com cara de plataforma, e nao de customizacao local de consumidor.

## Principio de desenho desta raiz

Esta raiz nao e um repositorio consumidor. Ela e a base compartilhada de componentes reaproveitaveis do time.

Isso implica algumas regras praticas:

- prefira componentes desacoplados, portaveis e com fronteira clara;
- evite misturar necessidade pontual de um unico repositorio consumidor com regra de plataforma;
- preserve ids publicos existentes, salvo quando houver motivo tecnico claro e plano de migracao;
- mantenha manifesto e README coerentes sempre que alterar um pacote.

Se a sua duvida for sobre instalacao, fluxo de uso ou escolha de preset no repositorio consumidor, volte para o [README raiz](../README.md) ou para o [Guia de Instalacao Detalhado](./guia-instalacao.md).

## Modelo mental do toolkit

Hoje o toolkit cresce em dois eixos:

- **Extension**: adiciona capacidades novas ao Spec Kit, como comandos operacionais, hooks e configuracoes.
- **Preset**: altera o comportamento do fluxo base do Spec Kit para um contexto, substituindo templates e comandos existentes.

Use esse criterio para decidir onde mexer:

- se a necessidade e um comando novo ou um hook novo reutilizavel entre varios contextos, a mudanca tende a ser extension;
- se a necessidade e alterar linguagem, ownership, estrutura de artefato ou comportamento de comandos nativos em um contexto especifico, a mudanca tende a ser preset.

## Estrutura minima de cada tipo de pacote

### Extension

Estrutura esperada:

```text
extensions/<id-da-extension>/
  extension.yml
  README.md
  commands/
    <comando>.md
  <arquivos auxiliares opcionais>
```

Responsabilidades tipicas:

- declarar metadados e compatibilidade em `extension.yml`;
- listar comandos em `provides.commands` apontando para arquivos em `commands/`;
- declarar configuracoes em `provides.config` quando houver template de configuracao;
- registrar hooks em `hooks` quando o fluxo precisar sugerir ou automatizar comandos antes ou depois de etapas do Spec Kit.

### Preset

Estrutura esperada:

```text
presets/<id-do-preset>/
  preset.yml
  README.md
  commands/
    speckit.<algo>.md
  templates/
    <template>.md
```

Responsabilidades tipicas:

- declarar metadados e compatibilidade em `preset.yml`;
- sobrescrever templates nativos em `provides.templates` com `replaces`;
- sobrescrever comandos nativos ou comandos de extension quando o contexto exigir;
- documentar claramente o ownership, idioma, handoffs e dependencias do preset.

## Como o pacote atual foi construido

O estado atual do repositorio segue este padrao:

- `extensions/mrv-aidd-producao` concentra comandos operacionais que nao existem no Spec Kit base;
- `presets/mrv-aidd-producao-backend` e `presets/mrv-aidd-producao-frontend` reaproveitam a mesma extension e mudam o comportamento do fluxo `/speckit.*` por ownership;
- os presets tambem sobrescrevem o comando `speckit.mrv-aidd-producao.sincronizar-us-devops` para aplicar filtros e protecoes especificas de backend ou frontend.

Esse desenho e uma boa referencia para crescer sem acoplar demais os componentes.

## O que este guia nao cobre

Este documento nao detalha:

- onboarding de consumo por catalogo;
- comandos principais de instalacao;
- operacao de release e publicacao de assets.

Para isso, use respectivamente:

- [README raiz](../README.md)
- [Guia de Instalacao Detalhado](./guia-instalacao.md)
- [Guia de Publicacao do Catalogo](./publicacao-catalogo.md)

## Quando criar um novo componente

Crie uma nova extension quando:

- o comando ou hook for reutilizavel em mais de um preset;
- a capacidade fizer sentido sem depender de ownership backend ou frontend;
- houver configuracao propria que nao deveria morar dentro de um preset.

Crie um novo preset quando:

- existir um contexto novo de uso, stack ou ownership com regras proprias;
- os overrides de templates e comandos nativos forem especificos daquele contexto;
- a variacao nao puder ser explicada apenas com uma opcao de configuracao da extension atual.

Expanda um pacote existente quando:

- a necessidade for uma extensao natural do papel atual do pacote;
- a mudanca mantiver compatibilidade com os consumidores ja esperados;
- a documentacao puder continuar simples sem transformar o pacote em um agregador confuso.

## Checklist para evoluir uma extension

1. Confirme se o comportamento novo realmente pertence a uma extension e nao a um preset.
2. Atualize `extension.yml` com comandos, configuracoes, tags e hooks necessarios.
3. Crie ou ajuste os arquivos em `commands/`.
4. Se houver configuracao obrigatoria, mantenha um template versionado no pacote.
5. Atualize o `README.md` da extension com objetivo, pre-requisitos, instalacao e saida esperada.
6. Preserve o id publico da extension e evite renomear comandos ja publicados sem plano de migracao.

## Checklist para evoluir um preset

1. Confirme qual contexto o preset representa e qual ownership ele governa.
2. Atualize `preset.yml` com todos os `replaces` necessarios.
3. Mantenha `commands/` e `templates/` alinhados com o manifesto.
4. Garanta que os prompts e artefatos continuem coerentes no idioma e no ownership do preset.
5. Atualize o `README.md` do preset explicando escopo, dependencia e comportamento esperado.
6. Evite sobrescrever mais comandos do que o necessario.

## Padroes que valem preservar

- Documentacao operacional em portugues do Brasil.
- Caminhos relativos dentro do pacote, sem dependencias em caminhos absolutos.
- Separacao clara entre comando da extension e override do preset.
- Uso de ids estaveis em `extension.yml` e `preset.yml`.
- Compatibilidade declarada com `speckit_version`.
- Coerencia entre manifesto, README, catalogo e asset publicado em release.

## Erros de desenho que devem ser evitados

- colocar logica de um repositorio consumidor especifico dentro da raiz da plataforma;
- criar preset novo quando bastava ajustar um template do preset existente;
- colocar em um preset um comando que na verdade deveria ser compartilhado por varios contextos via extension;
- alterar README sem refletir a mesma mudanca no manifesto, ou o inverso;
- introduzir referencia a repositorio antigo, caminho local de maquina ou automacao externa nao documentada.

## Roteiro recomendado para contribuicao

1. Comece pelo pacote mais proximo da mudanca: extension ou preset.
2. Leia o manifesto e o README do pacote antes de editar qualquer comando ou template.
3. Faça a menor mudanca que resolva o problema sem ampliar escopo indevidamente.
4. Atualize a documentacao do proprio pacote.
5. Se a mudanca alterar instalacao, inventario ou a forma de crescer a plataforma, atualize tambem o README raiz, os guias em `docs/` e o catalogo correspondente.

## Publicacao por catalogo

Se a intencao for disponibilizar um pacote para consumo simples por outros times, nao basta editar o manifesto.

Tambem e necessario:

1. Atualizar `extensions/catalog.json` ou `presets/catalog.json`.
2. Garantir que a versao do manifesto bate com a versao publicada no catalogo.
3. Publicar a tag no formato esperado pelo workflow.
4. Verificar se o asset zipado da release corresponde exatamente ao pacote distribuido.

O guia operacional dessa etapa esta em `docs/publicacao-catalogo.md`.

## Inventario atual para referencia

| Caminho                              | Tipo      | Papel                                                        |
| ------------------------------------ | --------- | ------------------------------------------------------------ |
| `extensions/mrv-aidd-producao`       | Extension | Fluxo operacional de US, Azure DevOps, branch e encerramento |
| `presets/mrv-aidd-producao-backend`  | Preset    | Ownership backend e artefatos pt-BR                          |
| `presets/mrv-aidd-producao-frontend` | Preset    | Ownership frontend e artefatos pt-BR                         |

## Perguntas de decisao antes de abrir uma mudanca

- Isso aumenta reuso de plataforma ou resolve um caso isolado de consumidor?
- Isso deve ser compartilhado via extension ou especializado via preset?
- O manifesto, o README e os arquivos reais do pacote continuarao coerentes depois da mudanca?
- O id publico e a portabilidade do pacote estao sendo preservados?

Se a resposta a alguma dessas perguntas for fraca, o desenho ainda precisa amadurecer antes da mudanca entrar.

## Veja tambem

- [README da plataforma](../README.md)
- [Guia de Instalacao Detalhado](./guia-instalacao.md)
- [Guia de Publicacao do Catalogo](./publicacao-catalogo.md)
- [README da extension base](../extensions/mrv-aidd-producao/README.md)
- [README do preset backend](../presets/mrv-aidd-producao-backend/README.md)
- [README do preset frontend](../presets/mrv-aidd-producao-frontend/README.md)
