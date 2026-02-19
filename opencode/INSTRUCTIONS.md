# INSTRUCTIONS

## TypeScript

- Use TypeScript for all code with `strict` mode enabled
- Avoid `any` type - use `unknown` and narrow when needed
- Don't cast types to circumvent issues - fix the underlying problem
- Prefer `const` over `let`
- Use descriptive variable names with auxiliary verbs (e.g., `isLoading`, `hasError`)

## Code Style

- Use early returns and guard clauses to reduce nesting
- Avoid unnecessary destructuring of variables
- DO NOT use `else` statements unless necessary
- DO NOT use `try`/`catch` unless handling external I/O (network, database, filesystem)
- Use regular `function` over arrow functions for named functions (unless you need lexical `this`)
- Prefer functional and declarative programming patterns - avoid classes
- Prefer iteration and modularization over code duplication
- Minimize code comments - focus on *why* not *what*, especially for I/O, validation, and edge cases
- Don't leave `console.log` in production code
- Don't nest callbacks more than 2 levels deep

## Error Handling

- Prioritize error handling: handle errors and edge cases early
- Use guard clauses for predictable validation
- Use try/catch only for external I/O operations where exceptions are expected
- Implement proper error logging and user-friendly messages
- Validate all user input

## Logging

- Follow structured logging principles with context
- Include request IDs in error responses for traceability
- Log errors with sufficient context (user ID, request ID, timestamp, stack traces)
- Don't log sensitive data (passwords, tokens, PII)
- Use appropriate log levels: error for failures, info for significant events, debug sparingly

## Error Responses

- Standardize error response format with `meta` and `error` objects
- Include `requestId` in meta for correlation
- Error object should contain: `code`, `status`, `message`
- Map error codes to HTTP status codes consistently

## Code Organization

- Use import path aliases like `~/*` when possible
- Alphabetize object properties when reasonable (except cases like `package.json`)
- Optimize images before committing
- Avoid N+1 queries
- Use pagination for large datasets

## Formatting

- **Arrow function parens**: always
- **Bracket spacing**: `{ foo }`
- **Quotes**: single quotes
- **Semicolons**: always
- **Trailing commas**: always

## Naming Conventions

- **API endpoints**: kebab-case, RESTful conventions
- **Classes**: PascalCase
- **Constants**: UPPER_SNAKE_CASE
- **Database tables**: snake_case, plural
- **Directories**: kebab-case, lowercase
- **Files**: kebab-case for components, camelCase otherwise
- **Functions**: camelCase, verb-first like `getUserById`
- **Interfaces/Types**: PascalCase
- **Variables**: camelCase
- **Zod Schema**: PascalCase

## Tech Stack

### Languages & Frameworks

- **Primary language**: TypeScript
- **Frontend**: React
- **Backend**: Bun (preferred), fallback to Node.js
- **Styling**: TailwindCSS
- **Database**: SQLite for small projects, PostgreSQL for larger ones

### Package Managers

Bun is preferred. Secondary: pnpm. Otherwise: npm or yarn.

## Git Workflow

- Keep commit messages short: `docs: adds usage example to README`
- ALWAYS create new branches off the default branch for features/fixes
- DO NOT commit directly to the default branch
- DO NOT commit changes, push branches, or create PRs without explicit instruction
- Include lockfiles in commits (package-lock.json, Cargo.lock, bun.lockb, etc.)
- Install dependencies using the project's toolchain (e.g., `npm i`, `cargo install`)
- Minimize new dependencies unless necessary and agreed upon
- Prefer `gh` CLI for GitHub operations, especially for private repos
- DO NOT list files changed in PR descriptions - the diff shows that

## PR Structure

- Short opening sentence describing the fix/feature
- Explain the issue with concrete context
- (Optional) Show real-world data or code demonstrating the problem
- Bullet points showing major functional changes
- Code snippet showing user-facing result (if applicable)
- Brief mention of docs, tests, etc. as applicable

## Testing

- Bias towards fewer overall tests
- Focus on integration tests or stubs that test validation, state, and error handling
- Avoid unit tests that simply test language functions (e.g., testing that object spread works)

## Security

- Never commit secrets or API keys
- Validate all user input
- Use parameterized queries

## Documentation & Writing

- Act as editor, not author replacement
- Use imperative mood: "Install the package" not "You should install"
- Be concise - avoid walls of text
- Lead with problem or context before solution
- Keep paragraphs short: 2-4 sentences max
- Use "we" for collaboration; "you" to address the reader
- Explain why, not just what
- Link liberally to sources, docs, and references
- Use bullet points over numbered lists unless order matters
- Be direct and opinionated; acknowledge tradeoffs honestly
- Use bold for key phrases that anchor an argument
- Prefer AP style unless project has existing convention
- Retain original voice and tone when editing prose - keep edits small and surgical
- Avoid marketing speak: "perfect for", "empowers you to", "modernization"
- Em-dashes are OK. Semi-colons less so.
- Don't use emojis unless I do

## Communication

- DO NOT say "you're absolutely right" - just agree/disagree and continue
- Present options when prudent, but don't overdo it
- Bring opinions when presenting options - recommend with reasons
- Be concise, avoid long walls of text
- Link to sources when appropriate
