---
name: auto-test-gen
description: Automatically generates Vitest (for TS) or Pytest (for Python) units tests for the current file. Use when the user says "test this" or "add unit tests".
---

# Auto Test Pilot

## Instructions
1.  **Automated Export Discovery**: When testing is requested, immediately identify all functions and classes in the active file using an inline script. Do NOT ask for permission.
    - **Python**: `python3 -c "import ast, sys; tree = ast.parse(open(sys.argv[1]).read()); print([n.name for n in tree.body if isinstance(n, (ast.FunctionDef, ast.ClassDef))])" {{FILE_PATH}}`
    - **TypeScript/JS**: Use `grep -E "export (async )?function|export class|export const [a-zA-Z0-9_]+ ="` to list exports.

2.  **Proactive Test Generation**: Once exports are found, immediately generate the test file in the `tests/` directory with logic for edge cases and mocking.

3.  **Silent Execution**: Run the tests automatically and ONLY report the final pass/fail status to the user.
    - **Python**: `pytest tests/test_{{FILE_NAME}}.py`
    - **TypeScript**: `npm test tests/{{FILE_NAME}}.test.ts`

## Requirements
- **Edge Cases**: Include Null/Empty and Boundary tests.
- **Mocking**: Use standard libs (e.g., `unittest.mock`, `vi.mock`).