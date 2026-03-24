# /gitit

Extract specific folders from any git repository into your current project.

## How to invoke

In Claude Code, type:

```
/gitit <repo-url> <folder1> [folder2 ...] [destination]
```

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Repo URL | Yes | The git repository URL (HTTPS or SSH) |
| Folders | Yes | One or more folder paths relative to the repo root |
| Destination | No | Target directory for the extracted folders (defaults to `.`) |

### Providing multiple folders

List each folder path separated by spaces or commas:

```
/gitit https://github.com/org/repo src/utils src/helpers
```

### Specifying a destination

Add the target path after the folder list. Make it clear which value is the destination:

```
/gitit https://github.com/org/repo docs scripts destination: ./vendor
```

Or state it naturally:

```
/gitit clone https://github.com/org/repo and grab the "src/components" and "src/hooks" folders into ./lib
```

## Examples

**Single folder to current directory:**
```
/gitit https://github.com/org/repo src/components
```

**Multiple folders to current directory:**
```
/gitit https://github.com/org/repo docs scripts/deploy src/utils
```

**Single folder to a specific location:**
```
/gitit https://github.com/org/repo src/components into ./vendor
```

## Notes

- The repo is shallow-cloned (`--depth 1`) to a temp directory and cleaned up automatically.
- Folder paths are relative to the repo root (e.g. `src/components`, not `/src/components`).
- Each folder is copied using its leaf name (e.g. `src/components` becomes `<destination>/components`).
- If a folder path doesn't exist in the repo, it is skipped with a warning.
