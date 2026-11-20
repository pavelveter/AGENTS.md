# Debug

1. Reproduce the failure. Run the exact command or test. Save the error text.
   If you cannot reproduce it, write this in the report. Do not guess a fix.
2. Write a failing test for the failure. If a test is not practical, write the smallest runtime check.
3. Find the root cause. Trace the path from the error to the first wrong value or state.
   Change one thing at a time.
4. Fix the root cause at the narrowest shared point.
5. Run the failing test. It must pass.
6. Run the checks of the stack. They must pass.

## Do not
- Do not add `try/except`, `recover`, `catch`, or a `None` check to hide the error.
- Do not delete, skip, or weaken a failing test.
- Do not change the expected value of a test to match wrong output.
- Do not add `sleep` or retries to fix a timing problem. Find the cause.
- Do not change many files to find a bug. Add temporary logging, then remove it.

## Same problem after 3 attempts
Stop. Write in the report: the error, the hypotheses you tested, the evidence, and the next hypothesis.