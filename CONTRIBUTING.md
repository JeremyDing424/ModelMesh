# Contributing to Claude Execution Partners

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Your environment (OS, shell version, Claude Code version)
- Relevant logs or error messages

### Suggesting Enhancements

Enhancement suggestions are welcome! Please create an issue with:
- A clear description of the enhancement
- Use cases and benefits
- Any implementation ideas you have

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the code style guidelines below
3. **Test your changes** on multiple platforms if possible
4. **Update documentation** (README.md, SKILL.md, CHANGELOG.md)
5. **Submit a pull request** with a clear description of changes

## Code Style Guidelines

### Bash Scripts

- Use 2 spaces for indentation
- Add comments for complex logic
- Use meaningful variable names
- Include error handling with proper exit codes
- Quote variables to prevent word splitting: `"$variable"`
- Use `[[ ]]` for conditionals instead of `[ ]`

### Documentation

- Use clear, concise language
- Include code examples where helpful
- Keep line length under 100 characters
- Use proper markdown formatting

## Testing

Before submitting a PR, please test:

1. **Auto-detection** works correctly for various task descriptions
2. **Manual override** with `--partner` flag functions properly
3. **Parameter routing** passes correct flags to underlying scripts
4. **Cross-platform compatibility** (if possible, test on Windows/macOS/Linux)

### Test Commands

```bash
# Test Codex routing
./scripts/execute.sh "Add a function to calculate factorial"

# Test Gemini routing
./scripts/execute.sh "Design a button with rounded corners" --html

# Test manual override
./scripts/execute.sh "Design a form" --partner codex

# Test with parameters
./scripts/execute.sh "Create an icon" --svg -o icon.svg
```

## Project Structure

```
claude-execution-partners/
├── SKILL.md              # Skill documentation for Claude Code
├── README.md             # User-facing documentation
├── LICENSE               # MIT License
├── CHANGELOG.md          # Version history
├── CONTRIBUTING.md       # This file
├── .gitignore           # Git ignore rules
└── scripts/
    └── execute.sh       # Main execution script
```

## Adding New Features

When adding new features:

1. **Maintain backward compatibility** when possible
2. **Update all relevant documentation**
3. **Add entries to CHANGELOG.md** under [Unreleased]
4. **Consider cross-platform implications**
5. **Keep the script simple and maintainable**

## Questions?

Feel free to open an issue for any questions about contributing!

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other contributors

Thank you for contributing! 🎉
