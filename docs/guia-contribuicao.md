# Guia de Contribuição e Evolução da Plataforma

Este guia é para quem mantém o MRV AIDD Platform. Se você quer instalar ou usar a plataforma em um repositório consumidor, veja [../README.md](../README.md) e [./guia-instalacao.md](./guia-instalacao.md).

---

## Índice

- [O que este repositório mantém](#o-que-este-repositório-mantém)
- [Modelo mental de manutenção](#modelo-mental-de-manutenção)
- [Estrutura esperada dos pacotes](#estrutura-esperada-dos-pacotes)
- [Como decidir onde mexer](#como-decidir-onde-mexer)
- [O que preservar sempre](#o-que-preservar-sempre)
- [Superfícies que precisam ficar sincronizadas](#superfícies-que-precisam-ficar-sincronizadas)
- [Checklist de mudança em extension](#checklist-de-mudança-em-extension)
- [Checklist de mudança em preset](#checklist-de-mudança-em-preset)
- [Checklist documental da plataforma](#checklist-documental-da-plataforma)
- [Armadilhas comuns de manutenção](#armadilhas-comuns-de-manutenção)
- [Quando a mudança afeta o fluxo AIDD](#quando-a-mudança-afeta-o-fluxo-aidd)
- [Publicação e distribuição](#publicação-e-distribuição)
- [Veja também](#veja-também)

---

## O que este repositório mantém

Ao contribuir aqui, você não está mexendo em um projeto de negócio. Você está mexendo em uma base compartilhada que sustenta ao mesmo tempo:

- A documentação oficial do fluxo MRV AIDD.
- O catálogo versionado de extensions e presets.
- Pacotes reutilizáveis instalados por repositórios consumidores.

O critério de design muda por causa disso. O objetivo não é resolver uma dor local de um único repositório. O objetivo é manter um acervo portável, coerente e reaproveitável.

---

## Modelo mental de manutenção

O ecossistema cresce em dois eixos:

- `extension` adiciona capacidade nova ao fluxo.
- `preset` customiza templates, comandos, linguagem e ownership de capacidades existentes.

**Regra prática:**

- Se a mudança cria comando novo, hook novo ou integração nova → tende a ser extension.
- Se a mudança altera ownership, linguagem, formato de artefato ou governança de um fluxo que já existe → tende a ser preset.

---

## Estrutura esperada dos pacotes

### Extension

```text
extensions/<id-da-extension>/
  extension.yml
  README.md
  commands/
    <comando>.md
  <arquivos auxiliares opcionais>
```

### Preset

```text
presets/<id-do-preset>/
  preset.yml
  README.md
  commands/
    speckit.<algo>.md
  templates/
    <template>.md
```

---

## Como decidir onde mexer

### Crie ou evolua uma extension quando

- A capacidade precisa existir independentemente de ownership backend ou frontend.
- O fluxo demanda integração com sistema externo.
- Existe um comando novo que o core do Spec Kit não oferece.
- O comportamento precisa ser compartilhado por vários presets.

### Crie ou evolua um preset quando

- A mudança é de linguagem, ownership ou formato de artefato.
- O fluxo base continua o mesmo, mas a forma de escrever e operar muda.
- A organização precisa aplicar regras específicas de uma trilha sem inventar nova capacidade.

---

## O que preservar sempre

- IDs públicos dos pacotes (salvo quando houver motivo técnico claro e plano de migração documentado).
- Coerência entre manifesto, README, catálogo e comportamento real.
- Documentação operacional em pt-BR.
- Separação clara entre plataforma compartilhada e regra específica de consumidor.
- Coerência entre [../README.md](../README.md), [./aidd/README.md](./aidd/README.md), pacotes e catálogos.

---

## Superfícies que precisam ficar sincronizadas

Quando a mudança for pública, revise o conjunto inteiro afetado:

1. Manifesto do pacote (`extension.yml` ou `preset.yml`)
2. README do pacote
3. Catálogo correspondente (`extensions/catalog.json` ou `presets/catalog.json`)
4. [../README.md](../README.md) quando a experiência pública mudar
5. [./aidd/README.md](./aidd/README.md) quando o fluxo AIDD mudar
6. [./guia-instalacao.md](./guia-instalacao.md) quando instalação ou consumo mudarem

---

## Checklist de mudança em extension

1. Confirme se a necessidade realmente pede capacidade nova.
2. Atualize `extension.yml`.
3. Crie ou ajuste os arquivos em `commands/`.
4. Atualize o `README.md` da extension.
5. Revise impactos em configuração, hooks e catálogo.

---

## Checklist de mudança em preset

1. Confirme qual ownership ou contexto o preset representa.
2. Atualize `preset.yml`.
3. Ajuste `templates/` e `commands/` com o menor escopo possível.
4. Atualize o `README.md` do preset.
5. Revise coerência com a extension base e com o acervo AIDD.

---

## Checklist documental da plataforma

Sempre que a experiência pública mudar, revise também:

1. [../README.md](../README.md)
2. [./guia-instalacao.md](./guia-instalacao.md)
3. [./aidd/README.md](./aidd/README.md)
4. README do pacote afetado
5. Catálogo correspondente, quando houver impacto de distribuição

---

## Armadilhas comuns de manutenção

- Tratar esta raiz como se fosse um repositório consumidor.
- Adicionar regra local de um time como se fosse regra geral da plataforma.
- Mexer em manifesto sem refletir no README, ou o inverso.
- Criar preset novo quando um ajuste pequeno em preset existente resolveria.
- Colocar em preset uma capacidade que deveria ser extension.
- Quebrar IDs públicos sem plano de migração.

---

## Quando a mudança afeta o fluxo AIDD

Quando a mudança afetar o processo AIDD, a revisão não termina no arquivo editado. Valide coerência em:

- [./aidd/README.md](./aidd/README.md)
- [./aidd/modelos-operacionais.md](./aidd/modelos-operacionais.md)
- [./aidd/colaboracao-e-paralelismo.md](./aidd/colaboracao-e-paralelismo.md)
- [./aidd/prompt-pack.md](./aidd/prompt-pack.md)
- Templates e prompts instalados pelos presets
- SVG do fluxo, quando a narrativa textual depender dele

---

## Publicação e distribuição

Alterar pacote não basta. Se a mudança for pública, ela também precisa aparecer em versão, catálogo e release. O processo completo está em [./publicacao-catalogo.md](./publicacao-catalogo.md).

---

## Veja também

- [../README.md](../README.md)
- [./guia-instalacao.md](./guia-instalacao.md)
- [./publicacao-catalogo.md](./publicacao-catalogo.md)
- [./aidd/README.md](./aidd/README.md)
- [../extensions/mrv-aidd-producao/README.md](../extensions/mrv-aidd-producao/README.md)
- [../presets/mrv-aidd-producao-backend/README.md](../presets/mrv-aidd-producao-backend/README.md)
- [../presets/mrv-aidd-producao-frontend/README.md](../presets/mrv-aidd-producao-frontend/README.md)
