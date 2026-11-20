# SDD

No user is available. Do not ask questions.

1. Search `docs/` and existing specs with `rg`. Do not duplicate a spec.
2. Write or update `docs/specs/<feature>.md` before you implement.
   Create `docs/specs/` only if needed.
3. In the spec, add an "Assumptions" section.
   For each unclear decision, write the choice you made and the reason.
   Choose the option that is reversible and keeps existing behavior.
4. Define observable behavior and acceptance criteria.
   State what must be true. Do not add implementation detail.
5. Implement and test against the spec.
6. Update the spec to match the final behavior.
7. List the assumptions in the DECISIONS part of the final report.

New config values need: config, parse, validate, runtime use, observable behavior.
Each value needs a safe fallback and a short note: purpose, valid range, default.
Verify runtime behavior, not only parsing.