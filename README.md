# Claude Execution Partners

A unified skill for Claude Code that intelligently routes tasks to specialized execution partners: **Codex** (for code) and **Gemini Designer** (for UI/UX design).

## Features

- **Automatic Task Detection** - Analyzes your task description and routes to the appropriate partner
- **Smart Keyword Matching** - Case-insensitive detection of code vs design keywords
- **Manual Override** - Force specific partner with `--partner` flag
- **Cross-Platform** - Works on Windows, macOS, and Linux
- **Parameter Routing** - Correctly passes partner-specific parameters

## Installation

1. Copy this directory to your Claude skills folder:
   ```bash
   cp -r claude-execution-partners ~/.claude/skills/execution-partners
   ```

2. Make the script executable:
   ```bash
   chmod +x ~/.claude/skills/execution-partners/scripts/execute.sh
   ```

3. Ensure you have the underlying skills installed:
   - [Codex](https://github.com/anthropics/codex-skill) - For code execution
   - [Gemini Designer](https://github.com/your-repo/gemini-designer) - For UI/UX design

## Usage

### Basic Usage

```bash
# Auto-detect and execute
~/.claude/skills/execution-partners/scripts/execute.sh "Your task description"
```

### Examples

**Code Tasks** (routes to Codex):
```bash
execute.sh "Add a power function to calculator and write tests"
execute.sh "Refactor UserService to use async/await"
execute.sh "Fix the memory leak in WebSocketHandler"
```

**Design Tasks** (routes to Gemini):
```bash
execute.sh "Design a login form with email and password fields" --html
execute.sh "Create an SVG icon for settings"
execute.sh "Design a card component with title and description" --html -o card.html
```

### Manual Partner Selection

```bash
# Force Codex
execute.sh "Design a button" --partner codex

# Force Gemini
execute.sh "Implement login" --partner gemini --html
```

## How It Works

### Auto-Detection

The script analyzes your task description for keywords:

**Codex Keywords**: implement, refactor, test, fix, bug, function, class, component, API, code, write, add, update, create

**Gemini Keywords**: design, mockup, UI, UX, icon, SVG, HTML, layout, color, palette, typography, visual, style, form, button, page, website, landing, card, modal

If ambiguous, defaults to Codex.

### Parameter Routing

- **Codex-only**: `--file`, `--workspace`, `--session`, `--reasoning`, `--read-only`
- **Gemini-only**: `--html`, `--svg`, `-o/--output`
- **Shared**: `--model`, `--partner`

## Configuration

### Environment Variables

**For Gemini Designer:**
```bash
export GEMINI_API_KEY="your-api-key"
export GOOGLE_GEMINI_BASE_URL="https://linkapi.ai"  # Optional
export GEMINI_MODEL="gemini-3.1-pro-preview"        # Optional
```

**For Codex:**
See [Codex documentation](https://github.com/anthropics/codex-skill) for configuration.

## Requirements

- Bash shell (Git Bash on Windows, native on macOS/Linux)
- curl
- jq (for Gemini Designer)
- Codex skill installed
- Gemini Designer skill installed

## Troubleshooting

### "Command not found"
Make sure the script is executable:
```bash
chmod +x ~/.claude/skills/execution-partners/scripts/execute.sh
```

### "Partner script not found"
Ensure both Codex and Gemini Designer skills are installed in `~/.claude/skills/`

### API Errors (Gemini)
- Verify your `GEMINI_API_KEY` is correct
- Check that `GOOGLE_GEMINI_BASE_URL` points to the correct endpoint
- Ensure the API endpoint is `/v1/chat/completions`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - See LICENSE file for details

## Credits

Created for the Claude Code community to streamline task delegation between specialized execution partners.
