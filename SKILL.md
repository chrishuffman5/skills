# gitit

Clone a git repo and extract specific folders from it using PowerShell 7.

## Usage

When the user invokes `/gitit`, run the `gitit.ps1` script located in this skill's `scripts/` directory. Construct the command from user input:

```powershell
pwsh -File "<skill-dir>/scripts/gitit.ps1" -RepoUrl "<repo-url>" -Folders "<folder1>","<folder2>" -Destination "<target-path>"
```

## Parameters

- **RepoUrl** (required) — The git repository URL to clone.
- **Folders** (required) — One or more folder paths within the repo to extract. Paths are relative to the repo root.
- **Destination** (optional) — Where to copy the extracted folders. Defaults to the current working directory.

## Examples

Extract a single folder:
```powershell
pwsh -File gitit.ps1 -RepoUrl "https://github.com/org/repo" -Folders "src/components"
```

Extract multiple folders to a specific location:
```powershell
pwsh -File gitit.ps1 -RepoUrl "https://github.com/org/repo" -Folders "docs","scripts/deploy" -Destination "./vendor"
```

## Behavior

1. Clones the repo with `--depth 1` into a temp folder (`$env:TEMP/<random-guid>`).
2. Copies each specified folder to the destination (using the folder's leaf name).
3. Cleans up the temp clone automatically, even on failure.
4. Warns and skips any folder path not found in the repo.
