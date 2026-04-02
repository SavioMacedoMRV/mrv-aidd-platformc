# Guia de Instalacao Detalhado

Este guia agora funciona como complemento ao [README raiz](../README.md). O README concentra o onboarding e os comandos principais; este documento fica com as decisoes de instalacao, os efeitos esperados no repositorio consumidor e os cuidados operacionais.

## Quando usar este guia

Consulte este documento quando voce precisar:

- decidir entre catalogo e `--dev`;
- confirmar o que muda no repositorio depois da instalacao;
- revisar limitacoes operacionais antes de rodar o fluxo com MCP;
- localizar os arquivos exatos para diagnostico ou manutencao.

## Escolha do modo de instalacao

### Use catalogo MRV quando

- o objetivo for consumir os componentes publicados sem depender desta workspace;
- o time quiser instalacao repetivel por nome a partir dos arquivos de catalogo;
- a validacao ja estiver feita e a release publicada existir.

Fluxo esperado:

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
```

Depois disso, instale a extension base e exatamente um preset, conforme o ownership do repositorio.

### Use `--dev` quando

- voce estiver criando, ajustando ou validando os pacotes a partir desta raiz;
- precisar testar uma mudanca ainda nao publicada em release;
- quiser validar templates, comandos ou manifests antes de mexer no catalogo.

Ordens recomendadas:

Backend:

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-backend --priority 5
```

Frontend:

```powershell
specify extension add --dev .\extensions\mrv-aidd-producao
specify preset add --dev .\presets\mrv-aidd-producao-frontend --priority 5
```

## Efeitos esperados da instalacao

### Ao instalar a extension base

Depois de adicionar `mrv-aidd-producao`, o repositorio consumidor passa a ter:

- os comandos `speckit.mrv-aidd-producao.sincronizar-us-devops`, `speckit.mrv-aidd-producao.configurar-us` e `speckit.mrv-aidd-producao.terminar-us`;
- o arquivo de configuracao `mrv-aidd-producao-config.yml`, provisionado a partir do template do pacote;
- hooks opcionais para sugerir `configurar-us` antes de `tasks` e `implement`, e `terminar-us` depois de `implement`.

### Ao instalar um preset

Depois de adicionar um preset, o repositorio consumidor passa a usar:

- os templates `spec-template`, `plan-template`, `tasks-template` e `checklist-template` do contexto selecionado;
- as versoes customizadas dos comandos `/speckit.*` sobrescritos pelo preset;
- ownership, tags, idioma e handoff coerentes com backend ou frontend.

## Decisao de ownership

Instale apenas um preset por repositorio consumidor.

- Use `mrv-aidd-producao-backend` quando o repositorio for owner principal das historias de backend.
- Use `mrv-aidd-producao-frontend` quando o repositorio for owner principal das historias de frontend.
- Se backend e frontend estiverem separados em repositorios diferentes, cada um instala apenas o preset do proprio ownership.

## Cuidados operacionais

- O modo catalogo depende de releases zipadas publicadas com as URLs declaradas em `extensions/catalog.json` e `presets/catalog.json`.
- O comando de sincronizacao nao cria a Feature pai. Ela deve existir antes.
- O fluxo de Azure DevOps usa MCP exclusivamente. Nao use Azure CLI, PAT ou REST bruto para substituir esse comportamento dentro do comando.
- Se o ambiente nao tiver autenticacao ou MCP configurado, os comandos dependentes devem falhar cedo.

## Onde aprofundar

- [README da plataforma](../README.md)
- [README da extension base](../extensions/mrv-aidd-producao/README.md)
- [README do preset backend](../presets/mrv-aidd-producao-backend/README.md)
- [README do preset frontend](../presets/mrv-aidd-producao-frontend/README.md)
- [Guia de contribuicao](./guia-contribuicao.md)
- [Guia de publicacao do catalogo](./publicacao-catalogo.md)
