# Publicacao de Catalogo MRV

Este guia prepara este repositorio para funcionar como ponto de consumo simples para times da MRV que querem apenas instalar os componentes ja prontos.

## O que foi estruturado

Este repositorio agora passa a ter duas superfícies de catalogo, seguindo o modelo do Spec Kit:

- `extensions/catalog.json`: catalogo da extension MRV.
- `presets/catalog.json`: catalogo dos presets MRV.

Esses catalogos apontam para assets zipados em GitHub Releases deste proprio repositorio.

Tambem fazem parte da base de publicacao:

- `LICENSE`: licenca MIT referenciada pelos manifests e catalogos.
- `.gitignore`: evita versionar o diretorio `dist/`, usado apenas para empacotamento local.

## Modelo de consumo

### Extension

O consumidor adiciona o catalogo da MRV e instala a extension por nome:

```powershell
specify extension catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json --name mrv --install-allowed
specify extension search mrv
specify extension add mrv-aidd-producao
```

### Preset

O consumidor adiciona o catalogo da MRV e instala o preset por nome:

```powershell
specify preset catalog add https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json --name mrv --install-allowed
specify preset search mrv
specify preset add mrv-aidd-producao-backend --priority 5
```

Para frontend, troque o ID do preset para `mrv-aidd-producao-frontend`.

## Diferenca entre modo catalogo e modo --dev

- Use `--dev` quando estiver desenvolvendo ou validando localmente o pacote a partir desta workspace.
- Use catalogo quando o objetivo for consumo simples, repetivel e versionado em outros repositorios.

Em outras palavras: `--dev` e fluxo de autoria; catalogo e fluxo de distribuicao.

## URLs publicadas pelos catalogos

### Catalogos

- `https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json`
- `https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json`

### Releases esperados

Os catalogos foram preparados para estes assets:

| Pacote                       | Tag esperada                        | Asset esperado                         |
| ---------------------------- | ----------------------------------- | -------------------------------------- |
| `mrv-aidd-producao`          | `mrv-aidd-producao-v0.1.0`          | `mrv-aidd-producao-0.1.0.zip`          |
| `mrv-aidd-producao-backend`  | `mrv-aidd-producao-backend-v0.1.0`  | `mrv-aidd-producao-backend-0.1.0.zip`  |
| `mrv-aidd-producao-frontend` | `mrv-aidd-producao-frontend-v0.1.0` | `mrv-aidd-producao-frontend-0.1.0.zip` |

## Fluxo de publicacao

### Checklist rapido antes de publicar

1. Confirme se o manifesto do pacote esta com a versao correta.
2. Confirme se `README.md`, `CHANGELOG.md` e o catalogo correspondente estao coerentes.
3. Gere o zip localmente para validar o nome do asset.
4. Confirme se a URL de `download_url` do catalogo bate com a tag esperada.
5. So depois publique a tag.

### 1. Ajuste a versao no manifesto do pacote

- Extension: `extensions/<id>/extension.yml`
- Preset: `presets/<id>/preset.yml`

### 2. Atualize o catalogo correspondente

Para cada nova versao, atualize:

- `version`
- `download_url`
- `updated_at`

Se for um pacote novo, adicione uma nova entrada no catalogo.

### 3. Publique uma tag no formato esperado

Exemplos:

```powershell
git tag mrv-aidd-producao-v0.1.0
git push origin mrv-aidd-producao-v0.1.0
```

```powershell
git tag mrv-aidd-producao-backend-v0.1.0
git push origin mrv-aidd-producao-backend-v0.1.0
```

### 4. Deixe o workflow publicar o asset

O workflow `.github/workflows/publish-spec-kit-assets.yml`:

- identifica o pacote pelo nome da tag;
- valida se a versao da tag bate com o manifesto;
- gera o zip do pacote;
- cria a release e publica o asset.

## Empacotamento local

Se quiser validar antes da tag, use o script local:

```powershell
.\scripts\package-spec-kit-assets.ps1 -PackageType extension -PackageId mrv-aidd-producao
.\scripts\package-spec-kit-assets.ps1 -PackageType preset -PackageId mrv-aidd-producao-backend
.\scripts\package-spec-kit-assets.ps1 -PackageType preset -PackageId mrv-aidd-producao-frontend
```

Os zips sao gerados em `dist/`.

## Cuidados importantes

- Os catalogos so passam a ser instalaveis por nome depois que os releases e assets realmente existirem.
- Este repositorio ainda precisa manter manifesto, README e catalogo coerentes a cada versao.
- O `dist/` deve ser tratado como saida local de empacotamento, nao como artefato versionado no git.
- Se a MRV decidir usar outro owner ou outro dominio de hospedagem, ajuste `catalog_url`, `repository`, `homepage`, `documentation` e `download_url`.
