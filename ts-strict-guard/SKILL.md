---
name: ts-strict-guard
description: Enforces strict TypeScript patterns, removes 'any' types, and implements Discriminated Unions for error handling. Use when the user asks for a "code review" or "type safety check".
---

# TypeScript Strict Guard

## Instructions
- **No 'any'**: Identify all instances of `any` and suggest the most specific type possible (or `unknown` if truly dynamic).
- **Error Handling**: Prefer `Result` types (e.g., `{ success: true, data: T } | { success: false, error: Error }`) over throwing exceptions for predictable logic.
- **Null Checks**: Ensure optional chaining (`?.`) or nullish coalescing (`??`) is used rather than assuming data exists.

## Workflow
1. Scan `.ts` or `.tsx` files for type-safety violations.
2. Provide a summary table of "Weak Types Found."
3. Suggest specific interfaces or Type Guards to fix them.