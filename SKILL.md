---
name: execution-partners
description: Unified guide for delegating tasks to Codex (code execution) and Gemini Designer (UI/UX design). Use when you need to execute clear plans through either coding or design partners. Codex handles implementation, refactoring, testing; Gemini handles UI mockups, icons, design advice.
---

# Execution Partners — Codex & Gemini Designer

Unified reference for delegating tasks to your two execution partners: **Codex** for code execution and **Gemini Designer** for design execution.

## Decision Matrix: When to Use Which

| Task Type | Use Codex | Use Gemini |
|-----------|-----------|-----------|
| Implement features | ✓ | |
| Refactor code | ✓ | |
| Write/update tests | ✓ | |
| Bug fixes | ✓ | |
| Code generation | ✓ | |
| HTML/web mockups | | ✓ |
| SVG icons/illustrations | | ✓ |
| Color palettes | | ✓ |
| Typography suggestions | | ✓ |
| Design feedback | | ✓ |
| UI component design | | ✓ |
| Layout advice | | ✓ |

---

## Part 1: Codex — Code Execution Partner

Delegate coding tasks to Codex CLI for implementation, refactoring, testing, and bug fixes.

### Critical Rules

- ONLY interact with Codex through the bundled shell script. NEVER call `codex` CLI directly.
- Run the script ONCE per task. If it succeeds (exit code 0), read the output file and proceed. Do NOT re-run or retry.
- Do NOT read or inspect the script source code. Treat it as a black box.
- ALWAYS quote file paths containing brackets, spaces, or special characters (e.g. `--file "src/app/[locale]/page.tsx"`).
- Keep the task prompt focused (~500 words max). Describe WHAT to do and constraints, not step-by-step HOW.
- Never paste file contents into the prompt. Use `--file` to point Codex to key files — it reads them directly.
- Don't reference the SKILL.md itself in the prompt.

### Script Location

```
~/.claude/skills/codex/scripts/ask_codex.sh
```

### Basic Usage

**Minimal invocation:**
```bash
~/.claude/skills/codex/scripts/ask_codex.sh "Your request in natural language"
```

**With file context:**
```bash
~/.claude/skills/codex/scripts/ask_codex.sh "Refactor these components to use the new API" \
  --file src/components/UserList.tsx \
  --file src/components/UserDetail.tsx
```

**Multi-turn conversation (continue previous session):**
```bash
~/.claude/skills/codex/scripts/ask_codex.sh "Also add retry logic with exponential backoff" \
  --session <session_id from previous run>
```

### Output

The script prints on success:
```
session_id=<thread_id>
output_path=<path to markdown file>
```

Read the file at `output_path` to get Codex's response. Save `session_id` for follow-up calls.

### Codex Options

- `--workspace <path>` — Target workspace directory (defaults to current directory).
- `--file <path>` — Point Codex to key entry-point files (repeatable). Don't duplicate contents in prompt.
- `--session <id>` — Resume a previous session for multi-turn conversation.
- `--model <name>` — Override model (default: uses Codex config).
- `--reasoning <level>` — Reasoning effort: `low`, `medium`, `high` (default: `medium`). Use `high` for code review, debugging, complex refactoring.
- `--sandbox <mode>` — Override sandbox policy (default: workspace-write via full-auto).
- `--read-only` — Read-only mode for pure discussion/analysis, no file changes.

### When to Use Codex

Call Codex when at least one of these is true:

- The implementation plan is clear and needs coding execution.
- The task involves batch refactoring, code generation, or repetitive changes.
- Multiple files need coordinated modifications following a defined pattern.
- You want a practitioner's perspective on whether a plan is feasible.
- The task is cost-sensitive and doesn't require deep architectural reasoning.
- Writing or updating tests based on existing code.
- Simple-to-moderate bug fixes where the root cause is identified.

### Codex Workflow

1. Design the solution and identify key files involved.
2. Run the script with a clear, concise task description. Tell Codex the goal and constraints — it figures out implementation details.
3. Pass relevant files with `--file` (2-6 high-signal entry points; Codex has full workspace access).
4. Read the output — Codex executes changes and reports what it did.
5. Review the changes in your workspace.

For multi-step projects, use `--session <id>` to continue with full conversation history.

### Codex Examples

**Batch refactoring:**
```bash
~/.claude/skills/codex/scripts/ask_codex.sh "Convert all class components in src/components to functional components with hooks" \
  --file src/components
```

**Test writing:**
```bash
~/.claude/skills/codex/scripts/ask_codex.sh "Write comprehensive unit tests for the UserService class covering all public methods and error cases" \
  --file src/services/UserService.ts
```

**Bug fix:**
```bash
~/.claude/skills/codex/scripts/ask_codex.sh "Fix the memory leak in the WebSocket connection handler. The issue is that event listeners aren't being cleaned up on disconnect." \
  --file src/websocket/handler.ts \
  --reasoning high
```

---

## Part 2: Gemini Designer — Design Execution Partner

Delegate design tasks to Gemini via API for UI mockups, icons, color palettes, and design advice.

### Critical Rules

- ONLY interact with Gemini through the bundled shell script. NEVER call the API directly.
- Run the script ONCE per task. Read the output file and proceed.
- The script requires a Gemini API key. It checks (in order): `GEMINI_API_KEY` env var, `.env.local` in current/parent dirs, `~/.config/gemini-designer/api_key` file.
- Keep the task prompt short and focused on what the design is for, not how it should look (unless user specified).
- If the user didn't specify style/color/font, don't invent one — let Gemini decide.
- Only pass explicit user preferences (e.g. "dark mode", "use blue") when the user actually said so.

### Script Location

```
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh
```

### Basic Usage

**HTML page design:**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "Design a modern landing page for a SaaS product called FlowSync" --html
```

**SVG icon:**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "Create a minimal settings gear icon, 24x24, stroke style" --svg
```

**Design advice (text):**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "Suggest a color palette and typography for a developer blog"
```

**Custom output path (auto-infers type from extension):**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "Design a pricing card component" \
  -o ./designs/pricing-card.html
```

### Output

The script prints on success:
```
output_path=<path to output file>
```

Read the file at `output_path` to get Gemini's response.

### Output Types

- `html` — Self-contained HTML file with inline CSS. Ready to open in browser. Use `--html` shorthand or `--output-type html`.
- `svg` — Clean SVG code. Can be saved directly or embedded in HTML/React. Use `--svg` shorthand or `--output-type svg`.
- `text` (default) — Design advice in markdown: color palettes, typography, layout suggestions.

If you pass `-o` with a `.html` or `.svg` extension and don't specify an output type, the type is auto-inferred from the file extension.

### Gemini Configuration

- `GEMINI_API_KEY` - API key (required)
- `GOOGLE_GEMINI_BASE_URL` - API base URL (default: `https://zenmux.ai/api/v1`)
- `GEMINI_MODEL` - Model name (default: `google/gemini-3.1-pro-preview`)

### When to Use Gemini Designer

- Need a visual reference or HTML mockup for a UI component or page
- Need SVG icons or simple illustrations
- Need color palette, typography, or layout suggestions
- Need design feedback or critique on an existing design
- Want a quick single-page HTML prototype to show a concept

### Gemini Workflow

1. Only describe what the page/component is for and the core content — do NOT add your own design opinions unless the user explicitly specified them.
2. Run the script with the appropriate output type flag (`--html`, `--svg`, or default text).
3. Read the output file.
4. For HTML/SVG: save to the project and iterate if needed.
5. For text advice: apply the suggestions to your implementation.

### Gemini Tips

- Keep the task prompt short and focused on what it is, not how it should look.
- If the user didn't specify a style/color/font, don't invent one — let Gemini decide.
- Only pass explicit user preferences when the user actually said so.
- Chinese prompts work well — Gemini responds in the same language.

### Gemini Examples

**Landing page mockup:**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "Design a landing page for a project management tool. Include hero section, features overview, pricing table, and CTA buttons." --html
```

**Icon set:**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "Create 5 SVG icons (16x16) for a dashboard: home, settings, users, analytics, notifications. Minimalist line style." --svg
```

**Design system advice:**
```bash
~/.claude/skills/gemini-designer/scripts/ask_gemini.sh "I'm building a B2B SaaS dashboard. Suggest a color palette, typography system, and spacing scale that feels professional and accessible."
```

---

## Unified Workflow

### Step 1: Clarify the Task
- Understand what needs to be done
- Identify if it's a code task (Codex) or design task (Gemini)

### Step 2: Prepare Context
- For Codex: Identify key files to pass with `--file`
- For Gemini: Prepare a clear, focused description of what to design

### Step 3: Execute
- Run the appropriate script with clear instructions
- For Codex: Use `--reasoning high` for complex tasks
- For Gemini: Use appropriate output type (`--html`, `--svg`, or text)

### Step 4: Review & Iterate
- Read the output file
- For Codex: Review code changes in your workspace
- For Gemini: Review design and iterate if needed using `--session` (Codex) or re-run with refinements (Gemini)

### Step 5: Integrate
- For Codex: Commit changes, run tests
- For Gemini: Save design files, apply to project

---

## Configuration

### Codex Configuration
- Uses Codex CLI configuration (check `~/.codex/config` or project-level config)
- Model, reasoning level, and sandbox policy can be overridden per-call

### Gemini Configuration
- `GEMINI_API_KEY` environment variable or `~/.config/gemini-designer/api_key` file
- Optional: `GOOGLE_GEMINI_BASE_URL` and `GEMINI_MODEL` for custom endpoints

---

## Best Practices

### For Codex Tasks
- Keep prompts focused on WHAT, not HOW
- Pass 2-6 key files, let Codex discover the rest
- Use `--reasoning high` for debugging and complex refactoring
- Save `session_id` for multi-turn conversations
- Don't re-run failed tasks — investigate the error first

### For Gemini Tasks
- Describe the purpose, not the appearance
- Let Gemini make design decisions unless user specified preferences
- Use appropriate output type from the start
- Keep prompts short and clear
- Iterate by re-running with refinements

### General
- Use Codex for implementation, Gemini for design — don't mix concerns
- Review all outputs before integrating into your project
- For complex projects, use `--session` (Codex) to maintain conversation context
- Document decisions and keep outputs for future reference
