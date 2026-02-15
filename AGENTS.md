# AGENTS.md

## Project Scope
This repository contains Codex skills for Arduino CLI workflows.

## Repository Layout
- `skills/<skill-name>/SKILL.md`: Main instructions for each skill.
- `skills/<skill-name>/agents/openai.yaml`: Agent metadata/config for each skill.

## Working Rules For Agents
- Keep changes focused on the requested skill(s); avoid unrelated edits.
- Preserve existing skill names, folder structure, and file paths.
- Use clear, task-oriented language in `SKILL.md`.
- Prefer small, explicit updates over large rewrites.
- Do not remove or rename a skill directory unless explicitly requested.

## Editing Guidance
- When updating a skill, ensure `SKILL.md` and `agents/openai.yaml` stay consistent.
- Use ASCII unless a file already requires Unicode.
- If a request affects multiple skills, apply consistent terminology and command style.

## Validation Checklist
- Confirm modified paths exist and are correct.
- Confirm each edited skill still has:
  - `SKILL.md`
  - `agents/openai.yaml`
- Quickly scan for broken command snippets or obvious typos before finishing.
