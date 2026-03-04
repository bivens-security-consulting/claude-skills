---
name: python-refactor
description: Modernizes Python code by adding type hints, replacing 'os.path' with 'pathlib', and optimizing imports. Use when the user asks to "clean up" or "modernize" Python files.
---

# Python Modernization Skill

## Instructions
- **Type Safety**: Always add Python 3.10+ type annotations to function signatures.
- **Modern Libs**: Replace legacy `os.path` calls with `pathlib.Path`.
- **Formatting**: Suggest or apply `black` formatting standards.
- **Efficiency**: Replace manual loops with list comprehensions or `itertools` where it improves readability.

## Workflow
1. Analyze the file for legacy patterns.
2. Propose a plan to the user showing "Before" and "After" logic.
3. Once approved, apply changes and run `pytest` if a test suite exists.