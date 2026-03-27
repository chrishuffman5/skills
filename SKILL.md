---
name: install-skill
description: Install a skill from a remote git repository into the local .claude/skills/ directory. Use this skill whenever the user wants to install, add, or set up a new skill — e.g., "install the pdf skill", "add the remotion skill", "set up the xlsx skill". Also trigger when users reference installing skills by name or ask how to get a skill.
---

# install-skill

Install a skill branch from a remote repository into the project's `.claude/skills/` directory.

## Usage

When the user invokes `/install-skill` or asks to install a skill, run the `install-skill.ps1` script located in this skill's `scripts/` directory:

```powershell
pwsh -Command "& '<skill-dir>/scripts/install-skill.ps1'" -SkillName "<skill-name>"
```

## Parameters

- **SkillName** (required) — The name of the skill to install. This corresponds to the branch name in the repository.
- **RepoUrl** (optional) — The git repository to clone from. Defaults to `https://github.com/chrishuffman5/skills`.
- **Destination** (optional) — The local directory to install into. Defaults to `.claude/skills` relative to the current working directory.

## Examples

Install a skill using the default repo:
```powershell
pwsh -Command "& 'install-skill.ps1'" -SkillName "pdf"
```

Install from a different repository:
```powershell
pwsh -Command "& 'install-skill.ps1'" -SkillName "my-skill" -RepoUrl "https://github.com/someone/their-skills"
```

Install to a custom location:
```powershell
pwsh -Command "& 'install-skill.ps1'" -SkillName "pdf" -Destination ".claude/skills"
```

## Behavior

1. Checks if the skill already exists at the target path — exits with a message if so.
2. Creates the destination directory if it doesn't exist.
3. Clones the skill branch with `--depth 1` into `<destination>/<skill-name>`.
4. Removes the `.git` directory from the cloned skill (skills don't need repo history once installed).
5. Confirms the installation path.

## Notes

- If the user asks to install a skill without specifying a repo, use the default (`https://github.com/chrishuffman5/skills`).
- If the user provides a different repo URL, pass it via `-RepoUrl`.
- The script is safe to run without user confirmation — it only clones a single branch and removes the `.git` metadata.
