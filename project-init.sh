#!/usr/bin/env bash
# project-init: initialize Git and add project-specific .gitignore and AGENTS.md sections.
# Usage: project-init.sh [--py] [--go] [--node] [--web] [--agents]
#   --web includes --node. Without stack options, detect stacks from lockfiles/config.
#   --agents creates .agents -> the directory containing this script and excludes that link locally.
#   Safe to run again: existing files and sections are preserved.

set -Eeuo pipefail

SCRIPT_NAME="${0##*/}"

usage() {
  cat <<EOF_USAGE
Usage: $SCRIPT_NAME [--py] [--go] [--node] [--web] [--agents]

Options:
  --py, --python  Add Python instructions and ignore rules.
  --go            Add Go instructions and ignore rules.
  --node          Add Node instructions and ignore rules.
  --web           Add Node and Web instructions and ignore rules.
  --agents, -a    Create .agents link to this script's directory.
  -h, --help      Show this help.

Without a stack option, detect stacks in the current directory from
uv.lock or pyproject.toml, go.mod, pnpm-lock.yaml or package.json,
astro.config.*, and vite.config.*.
EOF_USAGE
}

error() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

# Add a line to .git/info/exclude (local only, not committed). Idempotent.
exclude_locally() {
  local file
  file="$(git rev-parse --git-path info/exclude)"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -Fxq "$1" "$file" || printf '%s\n' "$1" >> "$file"
}

# Resolve the script directory without relying on GNU readlink -f (not available on macOS).
resolve_script_dir() {
  local source="${BASH_SOURCE[0]}"
  local dir

  while [[ -L "$source" ]]; do
    dir="$(cd -P "$(dirname "$source")" >/dev/null 2>&1 && pwd)"
    source="$(readlink "$source")"
    [[ "$source" = /* ]] || source="$dir/$source"
  done

  cd -P "$(dirname "$source")" >/dev/null 2>&1 && pwd
}

SRC="${AGENTS_SRC:-$(resolve_script_dir)}"
[[ -d "$SRC" ]] || error "source directory does not exist: $SRC"
SRC="$(cd -P "$SRC" >/dev/null 2>&1 && pwd)" || error "cannot resolve source directory: $SRC"
PROJECT_DIR="$(pwd -P)"

# Bash 3.2-compatible arrays for the default macOS Bash.
# Expand them as ${arr[@]+"${arr[@]}"}: a plain "${arr[@]}" fails on an empty array under set -u.
SELECTED=()
LINK_AGENTS=0
STACK_OPTIONS_SEEN=0

add_stack() {
  local candidate="$1"
  local existing
  for existing in ${SELECTED[@]+"${SELECTED[@]}"}; do
    [[ "$existing" == "$candidate" ]] && return 0
  done
  SELECTED+=("$candidate")
}

for arg in "$@"; do
  case "$arg" in
    --py|--python) STACK_OPTIONS_SEEN=1; add_stack python ;;
    --go) STACK_OPTIONS_SEEN=1; add_stack go ;;
    --node) STACK_OPTIONS_SEEN=1; add_stack node ;;
    --web) STACK_OPTIONS_SEEN=1; add_stack node; add_stack web ;;
    --agents|-a) LINK_AGENTS=1 ;;
    -h|--help) usage; exit 0 ;;
    *) error "unknown option: $arg (use --help)" ;;
  esac
done

# Detect from lockfiles and manifests. A new project has a manifest before it has a lockfile.
if [[ "$STACK_OPTIONS_SEEN" -eq 0 ]]; then
  [[ -f uv.lock || -f pyproject.toml ]] && add_stack python
  [[ -f go.mod ]] && add_stack go
  [[ -f pnpm-lock.yaml || -f package.json ]] && add_stack node

  if compgen -G 'astro.config.*' >/dev/null || compgen -G 'vite.config.*' >/dev/null; then
    add_stack node
    add_stack web
  fi

  if [[ "${#SELECTED[@]}" -gt 0 ]]; then
    printf 'Detected stacks:'
    printf ' %s' "${SELECTED[@]}"
    printf '\n'
  else
    printf '%s\n' 'No stack detected. Use --py, --go, --node, or --web to select one.'
  fi
fi

# Normalize stack order so output and generated files are deterministic.
STACKS=()
for candidate in python go node web; do
  for selected in ${SELECTED[@]+"${SELECTED[@]}"}; do
    if [[ "$selected" == "$candidate" ]]; then
      STACKS+=("$candidate")
      break
    fi
  done
done

# Validate every source and destination before making changes.
command -v git >/dev/null 2>&1 || error "git is required but was not found in PATH"

for stack in ${STACKS[@]+"${STACKS[@]}"}; do
  stack_file="$SRC/stacks/$stack.md"
  [[ -f "$stack_file" && -s "$stack_file" ]] || error "missing or empty stack file: $stack_file"
  IFS= read -r first_line < "$stack_file" || true
  [[ "$first_line" == '## Stack:'* ]] || error "$stack_file must start with '## Stack:'"
done

if [[ "$LINK_AGENTS" -eq 1 ]]; then
  [[ -f "$SRC/AGENTS.md" ]] || error "missing source file: $SRC/AGENTS.md"
  [[ "$SRC" != "$PROJECT_DIR" ]] || error "--agents cannot link .agents to the project directory itself"
fi

if [[ -L .gitignore ]]; then
  error '.gitignore is a symlink; refusing to modify its target'
fi
if [[ -e .gitignore && ! -f .gitignore ]]; then
  error '.gitignore exists but is not a regular file'
fi

if [[ -L AGENTS.md ]]; then
  if [[ "${#STACKS[@]}" -gt 0 ]]; then
    warn 'AGENTS.md is a symlink; stack sections will not be written to the shared file'
  fi
elif [[ -e AGENTS.md && ! -f AGENTS.md ]]; then
  error 'AGENTS.md exists but is not a regular file'
fi

# Return the section marker used to detect existing .gitignore blocks.
gitignore_marker() {
  case "$1" in
    base) printf '%s\n' '# ---- macOS ----' ;;
    python) printf '%s\n' '# ---- Python (uv, ruff, pytest) ----' ;;
    go) printf '%s\n' '# ---- Go ----' ;;
    node) printf '%s\n' '# ---- Node / pnpm ----' ;;
    web) printf '%s\n' '# ---- Web (React, Vite, Astro, Tailwind) ----' ;;
  esac
}

write_gitignore_block() {
  case "$1" in
    base)
      cat <<'EOF_BASE'
# ---- macOS ----
.DS_Store
.AppleDouble
.LSOverride
._*
.Spotlight-V100
.Trashes

# ---- Editors / IDE ----
.idea/
*.iml
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
!.vscode/launch.json
*.swp
*.swo
*~

# ---- Secrets and local env ----
.env
.env.*
!.env.example
*.pem
*.key
*.p12
secrets/
*.local

# ---- Logs and temp ----
*.log
logs/
tmp/
.tmp/
.cache/
EOF_BASE
      ;;
    python)
      cat <<'EOF_PYTHON'
# ---- Python (uv, ruff, pytest) ----
__pycache__/
*.py[cod]
.venv/
venv/
.pytest_cache/
.ruff_cache/
.mypy_cache/
.pyright/
.coverage
.coverage.*
coverage.xml
htmlcov/
*.egg-info/
.eggs/
build/
dist/
# Commit uv.lock. Do not ignore it.
EOF_PYTHON
      ;;
    go)
      cat <<'EOF_GO'
# ---- Go ----
/bin/
*.exe
*.test
*.out
coverage.out
coverage.html
go.work.sum
# Commit go.sum. Do not ignore it.
EOF_GO
      ;;
    node)
      cat <<'EOF_NODE'
# ---- Node / pnpm ----
node_modules/
.pnpm-store/
.pnpm-debug.log*
npm-debug.log*
yarn-debug.log*
yarn-error.log*
*.tsbuildinfo
.eslintcache
.npm/
dist/
coverage/
# Commit pnpm-lock.yaml. Do not ignore it.
EOF_NODE
      ;;
    web)
      cat <<'EOF_WEB'
# ---- Web (React, Vite, Astro, Tailwind) ----
.astro/
.vite/
.turbo/
.output/
storybook-static/
playwright-report/
test-results/
EOF_WEB
      ;;
  esac
}

# Initialize Git only when the current directory is not already in a worktree.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  toplevel="$(git rev-parse --show-toplevel)"
  if [[ "$toplevel" != "$PROJECT_DIR" ]]; then
    warn "directory is inside another repository ($toplevel); git init skipped"
  else
    printf '%s\n' 'git: worktree exists, skip init'
  fi
else
  git init
fi

# Add the base block even when .gitignore already contains user rules.
# Existing content is never replaced. Marker checks make repeated runs idempotent.
if [[ ! -e .gitignore ]]; then
  : > .gitignore
fi
for stack in base ${STACKS[@]+"${STACKS[@]}"}; do
  marker="$(gitignore_marker "$stack")"
  if grep -qxF "$marker" .gitignore; then
    printf '.gitignore: %s present, skip\n' "$stack"
  else
    [[ ! -s .gitignore ]] || printf '\n' >> .gitignore
    write_gitignore_block "$stack" >> .gitignore
    printf '.gitignore: added %s\n' "$stack"
  fi
done

# Add stack instructions without replacing project-specific content.
if [[ "${#STACKS[@]}" -gt 0 && ! -L AGENTS.md ]]; then
  if [[ ! -e AGENTS.md ]]; then
    cat > AGENTS.md <<'EOF_AGENTS'
# AGENTS.md

## Project
- Purpose: <one line>
- Layout: <directory = stack, for example api/ = Go, web/ = Astro, tools/ = Python>
- Do not touch: <generated or vendored paths>
- Full check: <command, for example make check>

Run each stack command in the directory of that stack.
Run checks only for the stacks that you changed.
EOF_AGENTS
    printf '%s\n' 'AGENTS.md: created'
  fi

  for stack in "${STACKS[@]}"; do
    marker="<!-- stack:$stack -->"
    heading="$(sed -n '1p' "$SRC/stacks/$stack.md")"
    if grep -qxF "$marker" AGENTS.md || grep -qxF "$heading" AGENTS.md; then
      printf 'AGENTS.md: %s present, skip\n' "$stack"
    else
      {
        printf '\n%s\n' "$marker"
        awk 1 "$SRC/stacks/$stack.md"
      } >> AGENTS.md
      printf 'AGENTS.md: added %s. Update the Layout line.\n' "$stack"
    fi
  done
fi

# Create the optional local link. Do not hide an unrelated existing .agents path.
if [[ "$LINK_AGENTS" -eq 1 ]]; then
  if [[ -e .agents || -L .agents ]]; then
    if [[ -L .agents ]]; then
      existing_target="$(readlink .agents)"
      resolved_target=""
      if [[ "$existing_target" = /* ]]; then
        resolved_target="$existing_target"
      else
        resolved_target="$PROJECT_DIR/$existing_target"
      fi
      if [[ -d "$resolved_target" ]]; then
        resolved_target="$(cd -P "$resolved_target" >/dev/null 2>&1 && pwd)"
      fi
      if [[ "$resolved_target" == "$SRC" ]]; then
        printf '%s\n' 'link: .agents already points to the source directory'
        exclude_locally .agents
      else
        warn '.agents already exists as a different symlink; leaving it unchanged and not changing Git excludes'
      fi
    else
      warn '.agents already exists and is not a symlink; leaving it unchanged and not changing Git excludes'
    fi
  else
    ln -s "$SRC" .agents
    printf 'link: .agents -> %s\n' "$SRC"
    exclude_locally .agents
  fi
fi

# Report only the known project-template placeholders.
if [[ -f AGENTS.md && ! -L AGENTS.md ]] && grep -qE '^- (Purpose|Layout|Do not touch|Full check): <' AGENTS.md; then
  cat <<'EOF_TODO'
---
TODO: fill in the placeholders in AGENTS.md (section "## Project"):
  Purpose:       one sentence about the project
  Layout:        directory = stack. Example: root = Go (go.mod); web/ = Astro (pnpm)
  Do not touch:  generated or vendored paths, or "none"
  Full check:    one command, for example "make check", or "none"
Do not keep "<...>" as project values.
Lines to fix:
EOF_TODO
  grep -nE '^- (Purpose|Layout|Do not touch|Full check): <' AGENTS.md || true
fi

printf '%s\n' '---'
git status --short
