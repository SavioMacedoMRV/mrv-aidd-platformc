# Diretrizes do Workspace

## Proposito do repositorio

Este repositorio e a base central compartilhada da plataforma MRV para AIDD.

- Trate a raiz como fonte de componentes reutilizaveis do time, e nao como um repositorio consumidor isolado.
- O escopo atual inclui extensoes e presets, e pode evoluir para skills, diretivas, templates e outros padroes compartilhados.
- Antes de propor mudancas estruturais, preserve o objetivo principal: consolidar ativos portaveis entre repositorios e fluxos de trabalho.

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