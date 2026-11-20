# Refactor

A refactor changes the structure. It does not change the behavior.

1. Check that tests cover the current behavior of the code. If they do not, write characterization tests first. Run them. They must pass.
2. Make one small change.
3. Run the checks. They must pass.
4. Commit the step if the repository workflow calls for it. Use the `refactor:` prefix.
5. Repeat.

## Rules
- Do not mix a refactor with a behavior change or a bug fix. If you find a bug, write it in the report.
- Do not change a public API unless the task asks for it.
- Do not rename and move code in the same step.
- Use the editor or language tools for renames when they are available. Check the result with `rg`.
- Stop when the stated goal is reached. Do not clean up other code.

## Done
- The tests from step 1 still pass without changes.
- The diff shows structure changes only.