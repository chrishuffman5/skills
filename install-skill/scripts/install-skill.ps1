[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SkillName,

    [Parameter(Mandatory = $false)]
    [string]$RepoUrl = "https://github.com/chrishuffman5/skills",

    [Parameter(Mandatory = $false)]
    [string]$Destination = ".claude/skills"
)

$ErrorActionPreference = "Stop"

# Resolve destination to absolute path
$Destination = [System.IO.Path]::GetFullPath($Destination)
$targetPath = Join-Path $Destination $SkillName

# Check if skill already exists
if (Test-Path $targetPath) {
    Write-Host "Skill '$SkillName' already exists at $targetPath"
    Write-Host "To update, remove the existing folder first: rm -rf '$targetPath'"
    exit 1
}

# Ensure parent directory exists
if (-not (Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Write-Host "Created directory: $Destination"
}

Write-Host "Installing skill '$SkillName' from $RepoUrl ..."
git clone $RepoUrl --branch $SkillName --depth 1 $targetPath 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install skill '$SkillName'. Check that the skill branch exists."
    exit 1
}

# Remove .git directory - the skill doesn't need its own repo history
$gitDir = Join-Path $targetPath ".git"
if (Test-Path $gitDir) {
    Remove-Item -Recurse -Force $gitDir
}

Write-Host "Installed '$SkillName' to $targetPath"
