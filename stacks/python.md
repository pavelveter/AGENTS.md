## Stack: Python (uv, ruff, pytest)
Applies to the directory that contains `pyproject.toml` and `uv.lock`.
- Run commands from that directory with `uv run <cmd>`.
- Never use `pip`, `poetry`, or bare `python`.
- Add a dependency: `uv add <pkg>`. Add a dev dependency: `uv add --dev <pkg>`. Sync: `uv sync`.
- Lint: `uv run ruff check`. Format check: `uv run ruff format --check`.
- Types: `uv run ty check` if `ty` is a dev dependency. Otherwise use the checker in `pyproject.toml` (`mypy` or `pyright`).
- Test: `uv run pytest -x -q`. For one test: `uv run pytest path::test_name`.
- Keep all tool config in `pyproject.toml`.
- Use `uv run --with <pkg>` for one-time tools. Do not install globally.
