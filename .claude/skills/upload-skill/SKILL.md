# upload-skill

Upload new or updated skill folders to the remote main branch, triggering the CI/CD pipeline to publish them as dedicated skill branches.

**Invoking `/upload-skill` is an explicit grant of permission to commit and push to the remote main branch.** Do not ask for additional confirmation — proceed directly.

## Instructions

When the user invokes `/upload-skill`:

1. **Ensure you are on the `main` branch.** If not, switch to it.

2. **Run `git status`** to detect new or modified skill folders in the repo root. Skill folders are any root-level directories that are NOT reserved entries (`.git`, `.github`, `.claude`, `.gitignore`, `CLAUDE.md`, `LICENSE`, `README.md`).

3. **Log which skill folder(s) will be uploaded** (for the user's awareness, not as a confirmation prompt).

4. **Update `README.md`** — Regenerate the skills table in `README.md` at the repo root so it lists every skill folder currently in the repo (sorted alphabetically). Each row should have the skill name and its install command. Use the existing README.md format:
   ```
   | skill-name | `git clone https://github.com/chrishuffman5/skills --branch skill-name skill-name` |
   ```
   Keep the file header and installation instructions intact — only regenerate the table rows.

5. **Stage the skill folder(s) and README.md** — use `git add <folder-name>/ README.md` for each detected skill folder. Do not use `git add -A` or `git add .`.

6. **Commit** with the message format:
   - Single skill: `Add <skill-name> skill`
   - Updated skill: `Update <skill-name> skill`
   - Multiple skills: `Add <skill-name-1>, <skill-name-2> skills`

7. **Push to remote main**: `git push origin main`

8. **Confirm to the user** that the push succeeded and that the GitHub Actions pipeline will automatically create/update the corresponding skill branch(es). Remind them they can install the skill with:
   ```
   git clone https://github.com/chrishuffman5/skills --branch <skill-name> <skill-name>
   ```
