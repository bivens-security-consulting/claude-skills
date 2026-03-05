---
name: ts-strict-guard
description: Enforces strict TypeScript patterns, removes 'any' types, and implements Discriminated Unions for error handling. Use when the user asks for a "code review" or "type safety check".
---

# TypeScript Strict Guard

## Instructions
1.  **Automated Type Audit**: When a code review is requested, immediately scan the file for `any` types and `throw new Error` patterns using an inline script. Do NOT ask for permission.
    - **Cross-Platform (Python)**: `python3 -c "import sys, re; content = open(sys.argv[1]).read(); print([m.start() for m in re.finditer(r':\s*any', content)])" {{FILE_PATH}}`
    - **Alternative**: Use `grep -nI ": any" {{FILE_PATH}}` to list lines with `any`.

2.  **Proactive Suggestions**: Once weak types are found, immediately provide a summary table and suggest specific interfaces or discriminated unions.

3.  **Completion**: Report "TypeScript strict audit complete. Proposed changes ready for review."