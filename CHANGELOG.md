# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-08

### Added
- Initial release of Claude Execution Partners skill
- Automatic task type detection (code vs design)
- Smart keyword-based routing to Codex or Gemini Designer
- Case-insensitive keyword matching
- Manual partner override with `--partner` flag
- Parameter routing for partner-specific options
- Cross-platform support (Windows, macOS, Linux)
- Comprehensive documentation (README.md, SKILL.md)
- Usage examples and troubleshooting guide

### Features
- **Codex Integration**: Routes code-related tasks (implement, refactor, test, fix, etc.)
- **Gemini Designer Integration**: Routes design tasks (UI, mockup, HTML, SVG, etc.)
- **Intelligent Defaults**: Falls back to Codex when task type is ambiguous
- **Full Parameter Support**: Passes all partner-specific flags correctly

### Technical Details
- Bash script with proper error handling
- HTTP header configuration for API compatibility
- Timeout settings optimized for long-running tasks
- Clean exit codes and error messages

## [Unreleased]

### Planned
- Support for additional execution partners
- Configuration file support
- Enhanced logging options
- Performance metrics
