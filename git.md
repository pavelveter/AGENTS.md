# Git rules

## Branch
Run `rtk git branch --show-current`.
Never commit to `main` or `master`.
If the current branch is `main` or `master`, create a branch: `rtk git switch -c agent/<task>`.
Use a short kebab-case name for `<task>`.
If the current branch is another branch, stay on it.
Do not merge, rebase, or push unless the task says so.
Write the branch name in the final report.

## Before you edit
rtk git status
rtk git diff
Existing user changes stay in the working tree. Do not stage them.

## Before you commit
rtk git status
rtk git diff
rtk git diff --check
Review the staged diff. Stage only files of the current task.

## Forbidden
Never overwrite, revert, format, delete, stage, or commit existing user changes.
Never use `reset --hard`, `clean`, or force history rewrite.
To undo your own work, use `git revert` or edit the files back.

## Commit message
Title: one line, `type: summary`.
Types: feat, fix, refactor, chore, docs, test, perf, build, ci, style.
Use the most accurate type. Do not overuse `chore`.
The title is never a section header such as `WHAT WE DID:`.

Body:

WHAT WE DID:
- Exact changes.

WHY WE DID THIS:
- Reason.

VERIFICATION:
- Exact commands that passed with exit code 0.

Write the message to a file. Run `git commit -F <file>`.
Do not use `git commit -m` for a multi-line message.
The `commit-msg` hook rejects escaped `\n`, bodies that end in `...`,
missing sections, and bad titles. Install it with `make hooks-install`.

## Do not write in commits
- Names of AI, agents, models, prompts, or tools.
- The `rtk` prefix in the VERIFICATION commands.
Use the local Git identity.