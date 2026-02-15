# Arduino CLI Skills

<img src="skills/arduino-cli-suite/assets/icon-small.svg" alt="Arduino CLI Suite logo" width="96" />

This is the repository-level README for the public package.

It contains a modular Arduino CLI skill collection and one recommended public entrypoint skill:

- `skills/arduino-cli-suite`

The suite skill routes to domain skills for board operations, core and library management, sketch operations, profile workflows, compile/upload, debug/monitor, config, maintenance, daemon/gRPC, and ecosystem specs.

## Repository Layout

- `skills/`: all skill folders (`SKILL.md` + `agents/openai.yaml`)
- `tmp/icl_capture/logs/`: curated real command transcripts used for ICL examples
- `tmp/icl_capture/*.sh`: repeatable capture scripts used to generate those transcripts

## Install (Single Public Skill)

Install from a GitHub repo path into Codex skills:

```bash
/Users/trent/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo <owner>/<repo> \
  --path skills/arduino-cli-suite
```

After installation:

1. Restart Codex.
2. Invoke with `$arduino-cli-suite`.

Example:

```text
Use $arduino-cli-suite to compile and upload this sketch to an Arduino Nano using old bootloader settings.
```

## Curated ICL Artifacts

- `tmp/icl_capture/logs/non_hardware_success.log`
- `tmp/icl_capture/logs/hardware_nano.log`
- `tmp/icl_capture/logs/supplemental.log`

## Publish Checklist

- [ ] Validate all skills:
  - `/Users/trent/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/<skill-name>`
- [ ] Confirm public entrypoint is `skills/arduino-cli-suite`.
- [ ] Confirm `skills/arduino-cli-suite/agents/openai.yaml` UI metadata is final.
- [ ] Confirm all skill files include current ICL examples.
- [ ] Run a clean install smoke test from GitHub path.
- [ ] Make repository public and publish release notes/tag.
