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

Os catalogos foram preparados para uma release unica por versao da plataforma, com uma tag compartilhada e tres assets zipados:

| Pacote                       | Tag compartilhada            | Asset esperado                         |
| ---------------------------- | ---------------------------- | -------------------------------------- |
| `mrv-aidd-producao`          | `mrv-aidd-platform-v0.1.0`  | `mrv-aidd-producao-0.1.0.zip`          |
| `mrv-aidd-producao-backend`  | `mrv-aidd-platform-v0.1.0`  | `mrv-aidd-producao-backend-0.1.0.zip`  |
| `mrv-aidd-producao-frontend` | `mrv-aidd-platform-v0.1.0`  | `mrv-aidd-producao-frontend-0.1.0.zip` |

## Fluxo de publicacao

### Checklist rapido antes de publicar

1. Confirme se o manifesto do pacote esta com a versao correta.
2. Confirme se os tres manifests compartilham a mesma versao da release de plataforma.
3. Confirme se `README.md`, `CHANGELOG.md` e os catalogos estao coerentes.
4. Gere os zips localmente para validar os nomes dos assets.
5. Confirme se as URLs de `download_url` dos catalogos batem com a tag compartilhada.
6. So depois publique a tag.

### 1. Ajuste a versao nos manifests da release

- Extension: `extensions/mrv-aidd-producao/extension.yml`
- Preset backend: `presets/mrv-aidd-producao-backend/preset.yml`
- Preset frontend: `presets/mrv-aidd-producao-frontend/preset.yml`

Os tres manifests precisam carregar a mesma versao quando a distribuicao for feita na mesma release de plataforma.

### 2. Atualize os catalogos

Para cada nova versao, atualize:

- `version`
- `download_url`
- `updated_at`

Todos os `download_url` devem apontar para a mesma tag compartilhada, mudando apenas o nome do asset zip.

Se for um pacote novo, adicione uma nova entrada no catalogo correspondente.

### 3. Publique uma tag no formato esperado

Exemplo:

```powershell
git tag mrv-aidd-platform-v0.1.0
git push origin mrv-aidd-platform-v0.1.0
```

### 4. Deixe o workflow publicar o asset

O workflow `.github/workflows/publish-spec-kit-assets.yml`:

- valida se a versao da tag bate com os tres manifests publicados juntos;
- gera os tres zips da versao;
- cria uma release unica;
- publica os tres assets na mesma release.

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
