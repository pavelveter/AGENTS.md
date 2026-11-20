# Tools

## Choose the tool
1. Find files and search text: `fff` tools `find_files`, `grep`, `multi_grep`.
2. Find callers, call paths, architecture, and change impact: `codebase-memory-mcp`.
3. Search ignored files, or if a tool fails: `rg`.
Do not install tools.

## fff
Put the known directory in the first search. Use `path` or `paths`.
- Declaration: `grep` with `{"query":"ParseConfig","path":"internal/config","definitions_only":true}`
- Regex in scope: `grep` with `{"query":"retry|backoff","mode":"regex","paths":["src","lib"],"globs":["*.go","!**/*_test.go"],"context":3}`
- Find a file: `find_files` with `{"query":"config loader","path":"src"}`
- Exact path pattern: `find_files` with `{"query":"**/*.test.ts","mode":"glob"}`
- Many names at once: `multi_grep`. Read its schema for the parameter names.
Rules:
- Use `definitions_only` to find where a symbol is declared.
- With `mode` set, matching is case-sensitive. Without `mode`, smart-case applies.
- A result page has up to 100 lines. Use the returned cursor for the next page.
- Use `context: 0` for matching lines only.
- A notice in the result means fff changed the search (fuzzy match, dropped filter). Read the notice.
- fff does not search files that `.gitignore` excludes. Use `rg` for them.
- Read more source only when the returned lines need context.

## codebase-memory-mcp
Check the index first. Use `index_status` for the project.
If the project is not indexed or the index is old, run `index_repository`.
- Callers or callees: `trace_path` with `function_name` and `direction` (`inbound` or `outbound`).
- Find symbols by name pattern, label, or meaning: `search_graph`.
- Module layout, routes, hotspots, cycles: `get_architecture` with `aspects`.
- Impact of uncommitted changes: `detect_changes`. Add `scope: "tests"` to find related tests.
- Graph-aware text search: `search_code`.
Rules:
- Before you write "X does not exist" or "nothing calls X", run `check_index_coverage` for the paths.
  A clean result means only "no recorded gap". Read the source to confirm.
- Graph edges are static. Dynamic calls and templates can be missing.
- Treat graph results as leads. Read the source before you edit.
- Check the tool schema for exact parameter names.

## rg fallback
- Definition: `rg -n "func ParseConfig|def parse_config|function parseConfig"`
- Callers: `rg -n "\bparse_config\(" --glob '!*_test.*'`
- Config key: `rg -n "max_retries" --glob '*.{toml,yaml,yml,json}'`
- Ignored files: `rg -n --no-ignore "pattern" path/`

## General rules
- Search first. Read second. Edit third.
- Start narrow. Widen only when the result is empty.
- Do not read a whole large file. Read the lines around the match.
- Read the callers before you edit a function, interface, schema, or config key.
- Prefix shell commands with `rtk`.
- If a command returns an exit code other than 0, read the error before the next attempt.