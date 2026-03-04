---
name: auto-test-gen
description: Automatically generates Vitest (for TS) or Pytest (for Python) units tests for the current file. Use when the user says "test this" or "add unit tests".
---

# Auto Test Pilot

## Instructions
- **Context Awareness**: Check the project root for `package.json` (to use Vitest/Jest) or `requirements.txt` (to use Pytest).
- **Edge Cases**: Always include at least one test case for "Empty/Null input" and "Boundary conditions."
- **Mocking**: Use standard mocking libraries (e.g., `unittest.mock` or `vi.mock`) for external API calls.

## Workflow
1. Read the implementation file.
2. Identify all exported functions/classes.
3. Create a corresponding `.test.ts` or `test_*.py` file in the `tests/` directory.
4. Run the newly created test and report the result.