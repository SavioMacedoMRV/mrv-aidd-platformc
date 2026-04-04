# Guia de Publicação do Catálogo MRV

Este documento é para quem publica uma nova versão da plataforma. Para entender o fluxo ou instalar os pacotes em um projeto consumidor, veja [../README.md](../README.md) e [./guia-instalacao.md](./guia-instalacao.md).

---

## Índice

- [O que significa publicar esta plataforma](#o-que-significa-publicar-esta-plataforma)
- [Superfícies publicadas](#superfícies-publicadas)
- [Modelo de release adotado](#modelo-de-release-adotado)
- [Checklist antes de publicar](#checklist-antes-de-publicar)
- [Arquivos que entram na publicação](#arquivos-que-entram-na-publicação)
- [Fluxo de publicação](#fluxo-de-publicação)
- [Validação depois da publicação](#validação-depois-da-publicação)
- [Empacotamento local](#empacotamento-local)
- [Armadilhas comuns de publicação](#armadilhas-comuns-de-publicação)
- [Veja também](#veja-também)

---

## O que significa publicar esta plataforma

Publicar o MRV AIDD Platform significa sincronizar quatro superfícies públicas:

1. Versão declarada nos manifests dos pacotes.
2. Entries dos catálogos.
3. Assets zipados gerados na release.
4. Documentação pública coerente com a versão publicada.

Como este repositório é ao mesmo tempo documentação, catálogo e distribuição, drift entre esses pontos quebra consumo ou entendimento do que foi realmente entregue.

---

## Superfícies publicadas

### Catálogos

- `extensions/catalog.json`
- `presets/catalog.json`

### Pacotes atualmente publicados

- `mrv-aidd-producao`
- `mrv-aidd-producao-backend`
- `mrv-aidd-producao-frontend`

### URLs públicas dos catálogos

```
https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/extensions/catalog.json
https://raw.githubusercontent.com/SavioMacedoMRV/mrv-aidd-platformc/main/presets/catalog.json
```

---

## Modelo de release adotado

O repositório usa uma release única por versão da plataforma, com uma tag compartilhada e múltiplos assets zipados.

Exemplo da versão atual:

| Pacote | Tag compartilhada | Asset esperado |
| --- | --- | --- |
| `mrv-aidd-producao` | `mrv-aidd-platform-v0.1.0` | `mrv-aidd-producao-0.1.0.zip` |
| `mrv-aidd-producao-backend` | `mrv-aidd-platform-v0.1.0` | `mrv-aidd-producao-backend-0.1.0.zip` |
| `mrv-aidd-producao-frontend` | `mrv-aidd-platform-v0.1.0` | `mrv-aidd-producao-frontend-0.1.0.zip` |

---

## Checklist antes de publicar

1. Confirme a versão nos manifests dos pacotes.
2. Confirme a mesma versão nos catálogos.
3. Revise README e documentação afetada.
4. Gere os zips localmente se precisar validar nomes e conteúdo.
5. Confirme que a tag a ser publicada bate com a versão declarada.

---

## Arquivos que entram na publicação

### Manifests

- `extensions/mrv-aidd-producao/extension.yml`
- `presets/mrv-aidd-producao-backend/preset.yml`
- `presets/mrv-aidd-producao-frontend/preset.yml`

### Catálogos

- `extensions/catalog.json`
- `presets/catalog.json`

### Workflow e empacotamento

- `.github/workflows/publish-spec-kit-assets.yml`
- `scripts/package-spec-kit-assets.ps1`

---

## Fluxo de publicação

### 1. Atualize as versões dos manifests

Os três pacotes publicados na mesma release devem carregar a mesma versão da plataforma, salvo se a estratégia de distribuição mudar explicitamente.

### 2. Atualize os catálogos

Para cada entrada afetada, revise:

- `version`
- `download_url`
- `updated_at`

Os `download_url` devem apontar para a mesma tag compartilhada, mudando apenas o asset zip correspondente.

### 3. Gere a tag

```powershell
git tag mrv-aidd-platform-v0.1.0
git push origin mrv-aidd-platform-v0.1.0
```

### 4. Deixe o workflow publicar os assets

O workflow da plataforma deve:

- Validar a coerência entre tag e manifests.
- Empacotar os três pacotes.
- Criar a release.
- Anexar os assets zipados esperados.

---

## Validação depois da publicação

Depois que a release terminar, confirme:

1. A release existe na tag esperada.
2. Os três assets zipados foram publicados.
3. Os catálogos apontam para URLs válidas.
4. A documentação pública não ficou atrás da versão publicada.

---

## Empacotamento local

Use o script local quando precisar validar a estrutura antes da tag:

```powershell
.\scripts\package-spec-kit-assets.ps1 -PackageType extension -PackageId mrv-aidd-producao
.\scripts\package-spec-kit-assets.ps1 -PackageType preset -PackageId mrv-aidd-producao-backend
.\scripts\package-spec-kit-assets.ps1 -PackageType preset -PackageId mrv-aidd-producao-frontend
```

Os arquivos são gerados em `dist/`.

---

## Armadilhas comuns de publicação

- Esquecer de atualizar um dos manifests.
- Publicar tag sem alinhar os catálogos.
- Publicar asset com nome diferente do esperado pelo catálogo.
- Assumir que editar o catálogo já torna o pacote instalável sem release correspondente.
- Deixar README ou guias descrevendo uma versão diferente da que foi publicada.

---

## Veja também

- [../README.md](../README.md)
- [./guia-instalacao.md](./guia-instalacao.md)
- [./guia-contribuicao.md](./guia-contribuicao.md)
- [../extensions/mrv-aidd-producao/README.md](../extensions/mrv-aidd-producao/README.md)
- [../presets/mrv-aidd-producao-backend/README.md](../presets/mrv-aidd-producao-backend/README.md)
- [../presets/mrv-aidd-producao-frontend/README.md](../presets/mrv-aidd-producao-frontend/README.md)
