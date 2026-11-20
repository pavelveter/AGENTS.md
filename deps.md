# Dependencies

Add a dependency only when no existing code, standard library, native capability, or installed dependency covers the need.

## Checklist before you add

- [ ] The need is real for the task.
- [ ] The package is maintained: recent releases, open issues are answered.
- [ ] The license allows your use. Report it.
- [ ] The size and the transitive dependencies are small.
- [ ] The name is exact. Check for typos and look-alike names.

## Commands

- Python: `uv add <pkg>` or `uv add --dev <pkg>`.
- Go: `go get <module>@<version>`, then `go mod tidy`.
- Node: `pnpm add <pkg>` or `pnpm add -D <pkg>`.
  Use one package manager per stack. Do not edit lockfiles by hand.

## Upgrade

- Upgrade only when the task asks for it or a fix needs it.
- Read the changelog for breaking changes.
- Upgrade one package at a time. Run the checks after each.

## GitHub Actions

Pin each action to a full commit SHA. Write the version in a comment.

## Report

Write the package, the version, the license, and the reason in the DECISIONS list.
