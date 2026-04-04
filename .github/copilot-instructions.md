# Diretrizes do Workspace

## Proposito do repositorio

Este repositorio e a base central compartilhada da plataforma MRV para AIDD.

- Trate a raiz como fonte de componentes reutilizaveis do time, e nao como um repositorio consumidor isolado.
- Trate a raiz como base oficial de documentacao, catalogo de extensoes e presets, e guia operacional da jornada MRV AIDD Platform.
- O escopo atual inclui extensoes e presets, e pode evoluir para skills, diretivas, templates e outros padroes compartilhados.
- Antes de propor mudancas estruturais, preserve o objetivo principal: consolidar ativos portaveis entre repositorios e fluxos de trabalho.

## Hierarquia conceitual da plataforma

- `AIDD` significa `AI Driven Development` e e a estrategia maior da MRV para inserir IA em toda a jornada de desenvolvimento.
- O objetivo do AIDD e usar IA para reduzir gaps, sanar problemas e trazer efetividade ao fluxo, mantendo humanos no loop inteiro para objetivo, restricoes, qualidade, ownership e validacao.
- A jornada operacional da plataforma combina `BDD + SDD`.
- `Spec Kit` nao e a plataforma inteira: ele e um dos toolkits usados na camada `SDD`, fornecendo CLI, comandos core, extensoes e presets.
- `MRV AIDD Platform` e a camada da MRV que operacionaliza essa estrategia com documentacao, catalogos, extensoes, presets, guardrails e integracoes.

## Regras do modelo AIDD

- Preserve a ideia de `humans in the loop` em toda explicacao do fluxo: agentes operam o how loop, pessoas definem objetivo, restricoes, qualidade e passagem entre gates.
- A feature de upstream e entrada do processo, mas nao deve ser tratada como verdade final sem clarificacao.
- `spec.md` e a fonte de verdade funcional somente depois de clarificacao e validacao.
- `plan.md` e a fonte de verdade tecnica.
- O board deve espelhar o `spec.md` validado, nunca a entrada bruta do upstream.
- `/tasks` e `/implement` devem operar por US assumida e com escopo explicito.
- Fluxos de hotfix devem ser tratados como excecao ao fluxo SDD normal, nao como regra principal.

## Estrutura esperada

- `extensions/`: extensoes instalaveis, com manifesto, README e comandos/configuracoes encapsulados.
- `presets/`: presets orientados por contexto de uso, stack ou ownership, sempre com manifesto, README e templates/comandos proprios.
- `.github/`: customizacoes compartilhadas de workspace, como estas instrucoes e outros artefatos de manutencao do repositorio.
- Novos grupos como `skills/`, `directives/` ou equivalentes so devem ser adicionados quando houver um caso de reuso transversal claro para a plataforma.

## Regras de manutencao

- Preserve os ids publicos existentes de extensoes e presets, salvo quando houver motivo tecnico claro e plano de migracao documentado.
- Prefira mudancas pequenas, reversiveis e com escopo bem definido.
- Evite misturar ajustes da plataforma com customizacoes especificas de um repositorio consumidor.
- Sempre mantenha README e manifesto coerentes entre si quando um componente for alterado.
- Para componentes voltados ao time, prefira documentacao e textos operacionais em portugues do Brasil, exceto quando um formato externo exigir outro idioma.
- Em documentacao, priorize navegacao orientada por intencao do usuario: entender a base, configurar repositorio consumidor, ver catalogo e colaborar com a plataforma.
- No README raiz, trate explicacoes institucionais longas como apoio; a entrada principal deve favorecer descoberta rapida de fluxo, instalacao, catalogo e contribuicao.
- Trate `docs/aidd/README.md` como fonte de verdade textual do fluxo AIDD; documentos satelite devem complementar, e nao redefinir, esse modelo.
- Quando alterar o fluxo AIDD, preserve coerencia entre README raiz, `docs/aidd/README.md`, diagramas, prompts, templates e READMEs de extensoes/presets.

## Compatibilidade e portabilidade

- Preserve caminhos relativos dentro dos pacotes e evite dependencias em caminhos absolutos, estrutura local de maquina ou ferramentas nao documentadas.
- Nao introduza acoplamentos desnecessarios com o repositorio de origem do pacote anterior, nomes antigos de pasta ou convencoes que so facam sentido fora desta raiz.
- Nao trate artefatos gerados por repositorios consumidores, como `.specify/`, `specs/` ou automacoes locais, como fonte da plataforma. Esses artefatos so entram aqui quando forem exemplos ou ativos compartilhados intencionais.
- Ao migrar conteudo de outros repositorios, adapte referencias de instalacao, manutencao e ownership para esta raiz central sem alterar o comportamento publico sem necessidade.

## Evolucao futura

- Novos componentes devem nascer desacoplados, com fronteira clara, documentacao minima e potencial real de reuso.
- Quando houver duvida entre criar um novo pacote ou estender um existente, prefira a alternativa que reduz duplicacao sem concentrar responsabilidades demais em um unico artefato.
- Se o repositorio crescer por area, adicione instrucoes mais especificas por pasta apenas quando as regras deixarem de ser universais.

## Referencias

- Use o `README.md` da raiz para a visao geral da plataforma.
- Use os READMEs dentro de `extensions/` e `presets/` para detalhes operacionais de cada pacote.
