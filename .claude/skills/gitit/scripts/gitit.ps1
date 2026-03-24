#Requires -Version 7
param(
    [Parameter(Mandatory)]
    [string]$RepoUrl,

    [Parameter(Mandatory)]
    [string[]]$Folders,

    [Parameter()]
    [string]$Destination = (Get-Location).Path
)

$clonePath = Join-Path $env:TEMP ([Guid]::NewGuid().ToString())

try {
    Write-Host "Cloning $RepoUrl to $clonePath ..."
    git clone --depth 1 $RepoUrl $clonePath
    if ($LASTEXITCODE -ne 0) { throw "git clone failed with exit code $LASTEXITCODE" }

    foreach ($folder in $Folders) {
        $source = Join-Path $clonePath $folder
        if (-not (Test-Path $source)) {
            Write-Warning "Folder not found in repo: $folder (skipping)"
            continue
        }
        $targetName = Split-Path $folder -Leaf
        $target = Join-Path $Destination $targetName
        Write-Host "Copying $folder -> $target"
        Copy-Item -Path $source -Destination $target -Recurse -Force
    }

    Write-Host "Done."
}
finally {
    if (Test-Path $clonePath) {
        Remove-Item -Path $clonePath -Recurse -Force
    }
}
