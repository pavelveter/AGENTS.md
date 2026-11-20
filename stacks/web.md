## Stack: Web (React, Astro, Tailwind)
Applies together with the Node stack. Check versions in `package.json` before you use an API.
- Astro: run `pnpm astro check` and `pnpm build`.
  Use static HTML by default. Add a `client:*` directive only when the component needs it.
- React: use function components and hooks. Follow the rules of hooks.
- Tailwind v4: config is CSS-first. Use `@import "tailwindcss";` and the `@tailwindcss/vite` plugin.
  Do not use v3 syntax (`@tailwind base`) or add `tailwind.config.js` unless the project has one.
  Tailwind v3 projects keep their v3 config.
- Accessibility: use semantic HTML, `alt` text, labels for inputs, and keyboard access.
- UI change: run `pnpm build`. If Playwright is configured, run the related test.
  If you cannot check the UI in a browser, write "UI not checked" in the report.
- Do not commit build output (`dist/`, `.astro/`).
