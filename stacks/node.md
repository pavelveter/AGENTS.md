## Stack: Node (pnpm)
Applies to the directory that contains `package.json` and `pnpm-lock.yaml`.
- Use only `pnpm`. Never use `npm`, `yarn`, or `npx`.
- Use `pnpm exec <bin>` for local tools and `pnpm dlx <pkg>` for one-time tools.
- Read the `scripts` in `package.json` first. Prefer them:
  `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build`.
- If `typecheck` is missing and `tsconfig.json` exists, run `pnpm exec tsc --noEmit`.
- Lint and format: use the tool in the config (`biome.json` means Biome; an ESLint config means ESLint).
  Do not add a second tool.
- Add a dependency: `pnpm add <pkg>`. Dev: `pnpm add -D <pkg>`.
- Install in CI and clean checks: `pnpm install --frozen-lockfile`.
- Respect `engines` and `packageManager` in `package.json`.
- Do not edit `pnpm-lock.yaml` by hand.
