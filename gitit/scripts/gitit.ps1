#Requires -Version 7
param(
    [Parameter(Mandatory)]
    [string]$RepoUrl,

    [Parameter(Mandatory)]
    [string[]]$Folders,

    [Parameter()]
    [string]$Destination = (Get-Location).Path,

    [switch]$IncludeSource
)

$clonePath = Join-Path $env:TEMP ([Guid]::NewGuid().ToString())

try {
    Write-Host "Cloning $RepoUrl to $clonePath ..."
    git clone --depth 1 $RepoUrl $clonePath
    if ($LASTEXITCODE -ne 0) { throw "git clone failed with exit code $LASTEXITCODE" }

    # Gather commit metadata once if -IncludeSource is set
    if ($IncludeSource) {
        $branch      = git -C $clonePath rev-parse --abbrev-ref HEAD
        $commitHash  = git -C $clonePath rev-parse HEAD
        $commitShort = git -C $clonePath rev-parse --short HEAD
        $commitMsg   = git -C $clonePath log -1 --format='%s'
        $commitAuthor = git -C $clonePath log -1 --format='%an'
        $commitDate  = git -C $clonePath log -1 --format='%aI'
        $copyTimestamp = (Get-Date -Format 'o')

        # Normalize repo URL to a base HTTPS URL (strip .git suffix and trailing slash)
        $baseUrl = $RepoUrl -replace '\.git$', '' -replace '/$', ''
        # Ensure it starts with https://github.com if it's a GitHub shorthand
        if ($baseUrl -notmatch '^https?://') {
            $baseUrl = "https://github.com/$baseUrl"
        }
    }

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

        if ($IncludeSource) {
            # Build the full tree URL: repo/tree/branch/folder-path
            $folderUrl = "$baseUrl/tree/$branch/$($folder -replace '\\','/')"
            $commitUrl = "$baseUrl/commit/$commitHash"

            $sourceBlock = @"

---

## Source

> Extracted from an external repository. See links below for original source and license.

| | |
|---|---|
| **Repository** | [$baseUrl]($baseUrl) |
| **Path** | [$folder]($folderUrl) |
| **Branch** | ``$branch`` |
| **Commit** | [``$commitShort``]($commitUrl) — $commitMsg |
| **Author** | $commitAuthor |
| **Commit date** | $commitDate |
| **Copied on** | $copyTimestamp |
"@

            # Find an existing README (case-insensitive) in the target folder
            $existingReadme = Get-ChildItem -Path $target -Filter 'readme.md' -File -ErrorAction SilentlyContinue |
                              Select-Object -First 1

            if ($existingReadme) {
                $readmePath = $existingReadme.FullName
                Write-Host "Appending source info to $readmePath"
                Add-Content -Path $readmePath -Value $sourceBlock -Encoding utf8
            }
            else {
                $readmePath = Join-Path $target 'README.md'
                $newContent = "# $targetName`n$sourceBlock"
                Write-Host "Creating $readmePath with source info"
                Set-Content -Path $readmePath -Value $newContent -Encoding utf8
            }
        }
    }

    Write-Host "Done."
}
finally {
    if (Test-Path $clonePath) {
        Remove-Item -Path $clonePath -Recurse -Force
    }
}
