# Security

## Input and trust boundaries
- Treat all input from users, files, network, environment, and other services as untrusted.
- Validate type, length, range, and format at the boundary. Reject bad input with a clear error.
- Use allowlists. Do not use denylists.

## Injection
- SQL: use parameters. Never build a query with string concatenation.
- Shell: do not build a command from input. Pass an argument list. Do not use `shell=True` (Python) or `sh -c` with input.
- Paths: resolve the path. Check that it stays inside the allowed directory. Reject `..` escapes.
- HTML: escape output. In React and Astro, do not use `dangerouslySetInnerHTML` or `set:html` with untrusted data.
- Deserialization: do not load untrusted data with `pickle` or `yaml.load`. Use `json` or `yaml.safe_load`.

## Secrets
- Never put a secret, token, or key in code, tests, logs, or commits.
- Read secrets from the environment. Add `.env.example` with names only.
- Do not print secrets in errors or logs.
- Do not read `.env` files unless the task needs it. Never copy their values into any file.
- If you find a secret in the repository, do not copy it. Report the file and line.

## Network and auth
- Use TLS. Do not disable certificate checks.
- Set timeouts on all network calls.
- Check authorization on the server for each protected action.
- Compare secrets with a constant-time function.
- Do not log personal data.

## Report
Write each security-relevant decision in the DECISIONS list.