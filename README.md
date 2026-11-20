# AGENTS.md

Agent rules for coding without vibes, hallucinations, or scope creep.

## What This Is

A strict rulebook for coding agents. It favors small diffs, real verification, and honest failure reports over fast guesswork. No corporate fluff, no fake confidence.

## Repo Layout

- `AGENTS.md` — Core rules: mission, scope, safe decisions, pre-edit checks, stack detection, ponytail ladder, bug fixing, testing, recovery, tooling, on-demand docs, done checklist, and report format.
- `debug.md` — Root-cause debugging. Reproduce first. Do not mask errors or weaken tests.
- `deps.md` — Dependency rules, package commands, and safety checks before adding or bumping packages.
- `evals.md` — Test scenarios and scoring for rule changes.
- `git.md` — Branch safety, diff checks, staging discipline, and commit message rules.
- `refactor.md` — Structural refactors without changing behavior.
- `review.md` — Pre-report sanity check for scope, leftovers, correctness, and honesty.
- `sdd.md` — Spec-driven flow for features, APIs, schemas, and architecture shifts.
- `security.md` — Input boundaries, injection defense, secrets hygiene, and auth/network rules.
- `stacks/` — Per-stack rules loaded only when needed:
  - `stacks/go.md`
  - `stacks/node.md`
  - `stacks/python.md`
  - `stacks/web.md`
- `testing.md` — Behavior tests, real boundaries, clean test data, flaky test rules, and stack test commands.
- `tools.md` — Search order (`fff`, `codebase-memory-mcp`, `rg`) and command rules.

## Core Principles

- **Small diff, real proof**: Make the smallest right change. Do not say it works without receipts.
- **Zero scope creep**: Keep existing behavior unless asked. Do not sneak in refactors, renames, or cleanup.
- **Fix the root cause**: Trace the real bug path instead of slapping a band-aid on symptoms.
- **Ponytail ladder**: Check existing code, stdlib, platform tools, or installed packages before writing custom code.
- **On-demand loading**: Keep `AGENTS.md` lean. Pull extra docs (`~/.config/opencode/agents/*.md`) only when the task hits that trigger.
- **No cap in reports**: Surface failed checks, unknowns, skipped checks, and solo decisions plainly.

## How to Use

Drop or link `AGENTS.md` and the supporting markdown files into your agent setup, then tweak stack rules or paths to fit your machine.

## License

MIT
