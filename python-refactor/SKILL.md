---
name: python-refactor
description: Modernizes Python code by adding type hints, replacing 'os.path' with 'pathlib', and optimizing imports. Use when the user asks to "clean up" or "modernize" Python files.
---

# Python Modernization Skill

## Instructions
1.  **Automated Analysis**: When modernization is requested, immediately scan the file for legacy patterns (`os.path`) and missing type hints using an inline script. Do NOT ask for permission.
    - **Python**: `python3 -c "import ast, sys; tree = ast.parse(open(sys.argv[1]).read()); print([n.lineno for n in ast.walk(tree) if isinstance(n, ast.Attribute) and n.attr == 'path' and isinstance(n.value, ast.Name) and n.value.id == 'os'])" {{FILE_PATH}}`

2.  **Proactive Refactoring**: Immediately propose a `diff` showing the replacement of `os.path` with `pathlib.Path` and the addition of type hints.

3.  **Silent Verification**: After user approval, apply changes and run `pytest` automatically. Only report the results.