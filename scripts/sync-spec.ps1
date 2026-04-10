<#
.SYNOPSIS
    Sincroniza spec.md e contratos do repo maestro para repos consumidores.

.DESCRIPTION
    Script generico e plug-and-play da MRV AIDD Platform para fluxos multi-repo.
    Funciona com qualquer combinacao de repos -- basta informar quem e o maestro
    (repo-fonte do spec) e quais sao os alvos (repos que recebem a copia).

    Modos de uso:
      1. Auto-discovery -- detecta repos com .specify/ no diretorio pai
      2. Arquivo de config -- le sync-spec.json do diretorio atual
      3. Parametros explicitos -- passa maestro, alvos e feature na linha de comando

.PARAMETER Feature
    Nome do diretorio da feature (ex: 001-minha-feature).
    Se omitido, tenta detectar pelo branch do repo maestro.

.PARAMETER Maestro
    Caminho relativo ou absoluto do repo maestro (fonte do spec).
    Se omitido, usa o campo "maestro" do sync-spec.json ou auto-discovery.

.PARAMETER Target
    Caminho(s) dos repos alvo. Aceita multiplos valores.
    Se omitido, usa o campo "targets" do sync-spec.json ou auto-discovery.

.PARAMETER ConfigFile
    Caminho do arquivo de configuracao. Padrao: sync-spec.json no diretorio atual.

.PARAMETER Include
    Artefatos a sincronizar. Padrao: spec.md e contracts/.

.PARAMETER DryRun
    Mostra o que seria feito sem executar.

.EXAMPLE
    # Auto-discovery (detecta repos com .specify/ no diretorio pai)
    .\sync-spec.ps1

.EXAMPLE
    # Com parametros explicitos
    .\sync-spec.ps1 -Maestro ../meu-front -Target ../meu-back -Feature 001-login

.EXAMPLE
    # Com config file
    .\sync-spec.ps1 -ConfigFile ./sync-spec.json

.EXAMPLE
    # Dry run para validar antes de executar
    .\sync-spec.ps1 -DryRun
#>

param(
    [string]$Feature,
    [string]$Maestro,
    [string[]]$Target,
    [string]$ConfigFile = "sync-spec.json",
    [string[]]$Include = @("spec.md", "contracts/"),
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# -- Helpers ------------------------------------------------------------------

function Write-Step([string]$msg) { Write-Host "  > $msg" -ForegroundColor Cyan }
function Write-Ok([string]$msg) { Write-Host "  + $msg" -ForegroundColor Green }
function Write-Skip([string]$msg) { Write-Host "  - $msg" -ForegroundColor DarkGray }
function Write-Warn([string]$msg) { Write-Host "  ! $msg" -ForegroundColor Yellow }

function Resolve-RepoPath([string]$path) {
    $resolved = Resolve-Path -Path $path -ErrorAction SilentlyContinue
    if ($resolved) { return $resolved.Path }
    $joined = Join-Path (Get-Location) $path
    if (Test-Path $joined) { return (Resolve-Path $joined).Path }
    return $null
}

function Get-FeatureFromBranch([string]$repoPath) {
    try {
        $branch = git -C $repoPath rev-parse --abbrev-ref HEAD 2>$null
        if ($branch -match '(?:^|/)(\d{3,}-[^\s/]+)') {
            return $Matches[1]
        }
    }
    catch { }
    return $null
}

function Find-SpecifyRepos([string]$searchRoot) {
    $repos = @()
    Get-ChildItem -Path $searchRoot -Directory -Depth 0 | ForEach-Object {
        $specifyDir = Join-Path $_.FullName ".specify"
        if (Test-Path $specifyDir) {
            $repos += $_.FullName
        }
    }
    return $repos
}

function Get-SpecsDir([string]$repoPath) {
    # Spec Kit usa specs/ como diretorio padrao
    $specsDir = Join-Path $repoPath "specs"
    if (-not (Test-Path $specsDir)) {
        # Fallback: tentar .specify/specs (menos comum)
        $altDir = Join-Path $repoPath ".specify" "specs"
        if (Test-Path $altDir) { return $altDir }
    }
    return $specsDir
}

function Get-RepoShortHash([string]$repoPath) {
    try {
        return (git -C $repoPath rev-parse --short HEAD 2>$null)
    }
    catch {
        return "unknown"
    }
}

function Get-RepoName([string]$repoPath) {
    return (Split-Path $repoPath -Leaf)
}

function Add-ReferenceHeader([string]$content, [string]$sourceName, [string]$hash) {
    $timestamp = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'
    $header = "<!--`n  REFERENCIA - NAO EDITE ESTE ARQUIVO`n  Fonte: $sourceName @ $hash`n  Sincronizado em: $timestamp`n  Para alterar: edite no repo maestro e re-execute sync-spec.ps1`n-->`n`n"
    # Remove header anterior se existir
    $content = $content -replace ('(?s)<!--\s*REFERENCIA.*?-->\s*'), ''
    return $header + $content.TrimStart()
}

# -- Resolucao de config -----------------------------------------------------

Write-Host ""
Write-Host "MRV AIDD Platform - sync-spec" -ForegroundColor White
Write-Host "------------------------------" -ForegroundColor DarkGray

$config = $null

# 1. Tentar ler config file
if (-not $Maestro -and -not $Target) {
    $configPath = if ([System.IO.Path]::IsPathRooted($ConfigFile)) {
        $ConfigFile
    }
    else {
        Join-Path (Get-Location) $ConfigFile
    }

    if (Test-Path $configPath) {
        Write-Step "Lendo config de $(Split-Path $configPath -Leaf)"
        $config = Get-Content $configPath -Raw | ConvertFrom-Json
    }
}

# 2. Resolver maestro
$maestroPath = $null

if ($Maestro) {
    $maestroPath = Resolve-RepoPath $Maestro
}
elseif ($config -and $config.maestro) {
    $maestroPath = Resolve-RepoPath $config.maestro
}

# 3. Auto-discovery se nenhum maestro definido
if (-not $maestroPath) {
    Write-Step "Auto-discovery: buscando repos com .specify/ ..."
    $searchRoot = Split-Path (Get-Location) -Parent

    # Se estamos dentro de um repo com .specify/, o parent e a raiz certa
    if (Test-Path (Join-Path (Get-Location) ".specify")) {
        $searchRoot = Split-Path (Get-Location) -Parent
    }

    $discovered = Find-SpecifyRepos $searchRoot

    if ($discovered.Count -eq 0) {
        Write-Error "Nenhum repo com .specify/ encontrado em $searchRoot. Use -Maestro e -Target."
        return
    }

    Write-Host ""
    Write-Host "  Repos encontrados:" -ForegroundColor White
    for ($i = 0; $i -lt $discovered.Count; $i++) {
        $name = Get-RepoName $discovered[$i]
        Write-Host "    [$i] $name" -ForegroundColor Cyan
    }
    Write-Host ""

    $maestroIdx = Read-Host "  Qual e o repo MAESTRO (fonte do spec)? [numero]"
    $maestroIdx = [int]$maestroIdx

    if ($maestroIdx -lt 0 -or $maestroIdx -ge $discovered.Count) {
        Write-Error "Indice invalido."
        return
    }

    $maestroPath = $discovered[$maestroIdx]
    $targetPaths = @()

    $targetInput = Read-Host "  Quais sao os repos ALVO? (numeros separados por virgula, ou 'todos' para os demais)"
    if ($targetInput -eq "todos") {
        $targetPaths = $discovered | Where-Object { $_ -ne $maestroPath }
    }
    else {
        $indices = $targetInput -split ',' | ForEach-Object { [int]$_.Trim() }
        foreach ($idx in $indices) {
            if ($idx -ge 0 -and $idx -lt $discovered.Count -and $discovered[$idx] -ne $maestroPath) {
                $targetPaths += $discovered[$idx]
            }
        }
    }
}

# 4. Resolver targets (se nao veio de auto-discovery)
if (-not $targetPaths -or $targetPaths.Count -eq 0) {
    $targetPaths = @()

    if ($Target) {
        foreach ($t in $Target) {
            $resolved = Resolve-RepoPath $t
            if ($resolved) { $targetPaths += $resolved }
            else { Write-Warn "Target nao encontrado: $t" }
        }
    }
    elseif ($config -and $config.targets) {
        foreach ($t in $config.targets) {
            $resolved = Resolve-RepoPath $t
            if ($resolved) { $targetPaths += $resolved }
            else { Write-Warn "Target do config nao encontrado: $t" }
        }
    }
}

if (-not $maestroPath -or -not (Test-Path $maestroPath)) {
    Write-Error "Repo maestro nao encontrado: $Maestro"
    return
}

if ($targetPaths.Count -eq 0) {
    Write-Error "Nenhum repo alvo definido. Use -Target, config file ou auto-discovery."
    return
}

$maestroName = Get-RepoName $maestroPath
Write-Ok "Maestro: $maestroName ($maestroPath)"
foreach ($tp in $targetPaths) {
    Write-Ok "Alvo:    $(Get-RepoName $tp)"
}

# -- Resolucao de feature ----------------------------------------------------

if (-not $Feature) {
    # Tentar detectar pelo branch
    $Feature = Get-FeatureFromBranch $maestroPath

    if (-not $Feature) {
        # Listar features disponiveis no maestro
        $specsDir = Get-SpecsDir $maestroPath
        if (Test-Path $specsDir) {
            $features = Get-ChildItem -Path $specsDir -Directory | Select-Object -ExpandProperty Name
            if ($features.Count -gt 0) {
                Write-Host ""
                Write-Host "  Features encontradas no maestro:" -ForegroundColor White
                for ($i = 0; $i -lt $features.Count; $i++) {
                    Write-Host "    [$i] $($features[$i])" -ForegroundColor Cyan
                }
                Write-Host ""
                $featureIdx = Read-Host "  Qual feature sincronizar? [numero]"
                $featureIdx = [int]$featureIdx
                if ($featureIdx -ge 0 -and $featureIdx -lt $features.Count) {
                    $Feature = $features[$featureIdx]
                }
            }
        }
    }
}

if (-not $Feature) {
    Write-Error "Feature nao identificada. Use -Feature ou crie uma feature no maestro."
    return
}

Write-Ok "Feature: $Feature"

# -- Validacao de origem -----------------------------------------------------

$sourceSpecsDir = Join-Path (Get-SpecsDir $maestroPath) $Feature

# Resolve includes
if ($config -and $config.include) {
    $Include = @($config.include)
}

$sourceSpecPath = Join-Path $sourceSpecsDir "spec.md"
if (-not (Test-Path $sourceSpecPath)) {
    Write-Error "spec.md nao encontrado em $sourceSpecsDir"
    return
}

Write-Host ""
Write-Host "------------------------------" -ForegroundColor DarkGray

# -- Sync --

$hash = Get-RepoShortHash $maestroPath
$synced = 0

foreach ($targetRepo in $targetPaths) {
    $targetName = Get-RepoName $targetRepo
    Write-Host ""
    Write-Step "Sincronizando para $targetName ..."

    $targetFeatureDir = Join-Path (Get-SpecsDir $targetRepo) $Feature

    if ($DryRun) {
        Write-Skip "[DRY RUN] Criaria $targetFeatureDir"
    }
    else {
        New-Item -ItemType Directory -Path $targetFeatureDir -Force | Out-Null
    }

    foreach ($item in $Include) {
        $sourcePath = Join-Path $sourceSpecsDir $item

        if ($item -like "*/" -or (Test-Path $sourcePath -PathType Container)) {
            # Diretorio (ex: contracts/)
            $cleanItem = $item.TrimEnd('/', '\')
            $sourceDir = Join-Path $sourceSpecsDir $cleanItem

            if (-not (Test-Path $sourceDir)) {
                Write-Skip "$cleanItem/ nao existe no maestro - pulando"
                continue
            }

            $targetDir = Join-Path $targetFeatureDir $cleanItem

            if ($DryRun) {
                Write-Skip "[DRY RUN] Copiaria $cleanItem/ -> $targetDir"
            }
            else {
                Copy-Item $sourceDir -Destination $targetDir -Recurse -Force
                Write-Ok "$cleanItem/ sincronizado"
            }
        }
        else {
            # Arquivo (ex: spec.md)
            if (-not (Test-Path $sourcePath)) {
                Write-Skip "$item nao existe no maestro - pulando"
                continue
            }

            $targetFilePath = Join-Path $targetFeatureDir $item

            if ($DryRun) {
                Write-Skip "[DRY RUN] Copiaria $item -> $targetFilePath"
            }
            else {
                $content = Get-Content $sourcePath -Raw -Encoding UTF8
                $tagged = Add-ReferenceHeader $content $maestroName $hash
                [System.IO.File]::WriteAllText($targetFilePath, $tagged, [System.Text.UTF8Encoding]::new($false))
                Write-Ok "$item sincronizado"
            }
        }
    }

    $synced++
}

# -- Resultado --

Write-Host ""
Write-Host "------------------------------" -ForegroundColor DarkGray
if ($DryRun) {
    Write-Warn "DRY RUN concluido - nenhum arquivo foi alterado"
}
else {
    Write-Ok "Sync completo: $synced repo(s) atualizados a partir de $maestroName @ $hash"
}
Write-Host ""
