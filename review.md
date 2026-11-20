# Review before the final report

Run `git diff` and `git status`. Read the full diff. Answer each question.

## Scope
- Does every changed file belong to the task?
- Is there any formatting, rename, or cleanup that the task did not need? Remove it.
- Did you touch existing user changes? If yes, restore them.

## Leftovers
- Debug output: `print`, `console.log`, `fmt.Println`, `dbg!`.
- Commented-out code.
- `TODO` or `FIXME` that you added.
- Temporary files, logs, `.agent/` files in the diff.
- Secrets, tokens, local paths, or user names.

## Correctness
- Does the diff match what you will write in the report?
- Does each behavior change have a check that fails if the logic breaks?
- Did you handle errors and resource cleanup in the new code?
- Did you run the checks of every stack that you changed? Did each command return exit code 0?

## Report
- VERIFICATION lists only commands that you ran in this session.
- Each assumption and decision is in the DECISIONS list.
- Each failed or skipped check is in the report with the reason.

If any answer is wrong, fix it. Then run this list again.