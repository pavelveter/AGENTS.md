# Testing

## Principles
- Test behavior and contract. Do not test implementation details.
- One test checks one behavior. Name the test after the behavior.
- Each test is independent. It does not depend on other tests or on order.
- A test must fail when the logic breaks. Check this: break the logic for a moment, run the test, restore the code.
- Cover the main path and at least one edge or error case.

## Mocks
- Do not mock what you own. Use the real code.
- Mock only external boundaries: network, clock, randomness, and slow services.
- Prefer a fake or a local test server to a deep mock.

## Test data
- Keep data small and visible in the test.
- Use fixed values. Fix the seed for randomness. Fix the clock.
- Use temporary directories. Clean up after the test.

## Flaky test
- Do not disable it. Do not add `sleep` or retries.
- Find the cause: shared state, order, time, network, or concurrency.
- If you cannot find the cause in 3 attempts, write the evidence in the report.

## By stack
- Python: `uv run pytest -x -q`. Use `pytest.mark.parametrize` for cases. Use the `tmp_path` fixture.
- Go: table-driven tests, `t.Run`, `t.TempDir()`, `t.Helper()`. Add `-race` for concurrent code.
- Node and web: test the behavior that the user sees. Use roles and labels to find elements.

## Do not
- Do not change the expected value of a test to make it pass.
- Do not delete a test to remove a failure.
- Do not write a test that always passes.