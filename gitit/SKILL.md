# gitit

Clone a git repo and extract specific folders from it using PowerShell 7.

## Usage

When the user invokes `/gitit`, run the `gitit.ps1` script located in this skill's `scripts/` directory. Construct the command from user input:

```powershell
pwsh -Command "& '<skill-dir>/scripts/gitit.ps1'" -RepoUrl "<repo-url>" -Folders "<folder1>","<folder2>" -Destination "<target-path>" -IncludeSource
```

## Parameters

- **RepoUrl** (required) — The git repository URL to clone.
- **Folders** (required) — One or more folder paths within the repo to extract. Paths are relative to the repo root.
- **Destination** (optional) — Where to copy the extracted folders. Defaults to the current working directory.
- **IncludeSource** (switch, optional) — When set, writes source provenance info (repository URL, branch, commit, timestamp) into a README.md in each extracted folder. Appends to an existing README.md (case-insensitive match) or creates a new one.

**Always pass `-IncludeSource`** unless the user explicitly asks to omit it.

## Examples

Extract a single folder with source tracking:
```powershell
pwsh -Command "& 'gitit.ps1'" -RepoUrl "https://github.com/org/repo" -Folders "src/components" -IncludeSource
```

Extract multiple folders to a specific location:
```powershell
pwsh -Command "& 'gitit.ps1'" -RepoUrl "https://github.com/org/repo" -Folders "docs","scripts/deploy" -Destination "./vendor" -IncludeSource
```

## Behavior

1. Clones the repo with `--depth 1` into a temp folder (`$env:TEMP/<random-guid>`).
2. Copies each specified folder to the destination (using the folder's leaf name).
3. If `-IncludeSource` is set, appends a **Source** section to an existing `README.md` (case-insensitive) in the target folder, or creates a new `README.md` if none exists. The section includes the full GitHub tree URL to the source folder, commit hash with link, author, commit date, and copy timestamp.
4. Cleans up the temp clone automatically, even on failure.
5. Warns and skips any folder path not found in the repo.
