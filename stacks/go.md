## Stack: Go
Applies to the directory that contains `go.mod`. If `go.work` exists, read it first.
- Format: `gofmt -l .` (or `gofumpt -l .` if the project uses it). The list must be empty.
- Static check: `go vet ./...`.
- Lint: `golangci-lint run` if `.golangci.yml` or `.golangci.yaml` exists.
- Test: `go test ./...`. Add `-race` for code that uses goroutines, channels, or locks.
- Vulnerabilities: `govulncheck ./...` if it is installed.
- Run `go mod tidy` only after you change imports. Commit `go.sum`.
- Tool dependencies: use the `tool` directive in `go.mod` and run `go tool <name>`.
  Do not add tool-only imports to code.
- Pass `context.Context` as the first argument. Always handle returned errors.
