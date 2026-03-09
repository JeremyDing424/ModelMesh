#!/usr/bin/env bash
# Ensure bash is used, not sh
if [ -z "$BASH_VERSION" ]; then
  exec bash "$0" "$@"
fi
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  execute.sh <task> [options]

Unified execution partner script that automatically routes tasks to:
  - Codex: for code implementation, refactoring, testing, bug fixes
  - Gemini: for UI/UX design, HTML mockups, SVG icons, design advice

Options:
  --partner <codex|gemini|auto>  Force specific partner or auto-detect (default: auto)
  --file <path>                  File context (repeatable, for Codex)
  --workspace <path>             Workspace directory (for Codex)
  --session <id>                 Resume session (for Codex)
  --model <name>                 Override model
  --reasoning <level>            Reasoning effort: low/medium/high (for Codex)
  --read-only                    Read-only mode (for Codex)
  --html                         Output as HTML (for Gemini)
  --svg                          Output as SVG (for Gemini)
  -o, --output <path>            Output file path (for Gemini)
  -h, --help                     Show this help

Examples:
  # Auto-detect and execute
  execute.sh "Add a power function to calculator and write tests"

  # Force Codex
  execute.sh "Refactor UserService" --partner codex --file src/services/UserService.ts

  # Force Gemini
  execute.sh "Design a login form" --partner gemini --html

  # With file context
  execute.sh "Fix the memory leak" --file src/WebSocketHandler.ts
USAGE
}

# --- Parse arguments ---

task_text=""
partner="auto"
codex_args=()
gemini_args=()
output_type=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --partner)
      partner="${2:-}"
      shift 2
      ;;
    --file)
      codex_args+=(--file "${2:-}")
      shift 2
      ;;
    --workspace)
      codex_args+=(--workspace "${2:-}")
      shift 2
      ;;
    --session)
      codex_args+=(--session "${2:-}")
      shift 2
      ;;
    --model)
      codex_args+=(--model "${2:-}")
      shift 2
      ;;
    --reasoning)
      codex_args+=(--reasoning "${2:-}")
      shift 2
      ;;
    --read-only)
      codex_args+=(--read-only)
      shift
      ;;
    --html)
      gemini_args+=(--html)
      output_type="html"
      shift
      ;;
    --svg)
      gemini_args+=(--svg)
      output_type="svg"
      shift
      ;;
    -o|--output)
      gemini_args+=(-o "${2:-}")
      shift 2
      ;;
    -*)
      echo "[ERROR] Unknown option: $1" >&2
      exit 1
      ;;
    *)
      if [[ -z "$task_text" ]]; then
        task_text="$1"
      else
        echo "[ERROR] Multiple positional arguments not allowed" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$task_text" ]]; then
  echo "[ERROR] Task text is required" >&2
  usage
  exit 1
fi

# --- Auto-detect partner if needed ---

if [[ "$partner" == "auto" ]]; then
  # Convert to lowercase for case-insensitive matching
  task_lower="${task_text,,}"

  # Design keywords (check first, higher priority)
  if [[ "$task_lower" =~ (design|mockup|ui|ux|icon|svg|html|layout|color|palette|typography|visual|style|form|button|page|website|landing|card|modal) ]]; then
    partner="gemini"
  # Code keywords
  elif [[ "$task_lower" =~ (implement|refactor|test|fix|bug|function|class|component|api|code|write|add|update|create) ]]; then
    partner="codex"
  # Default to codex if ambiguous
  else
    partner="codex"
  fi

  echo "[INFO] Auto-detected partner: $partner" >&2
fi

# --- Execute with selected partner ---

case "$partner" in
  codex)
    codex_script="$HOME/.claude/skills/codex/scripts/ask_codex.sh"
    if [[ ! -x "$codex_script" ]]; then
      echo "[ERROR] Codex script not found or not executable: $codex_script" >&2
      exit 1
    fi

    echo "[INFO] Executing with Codex..." >&2
    exec "$codex_script" "$task_text" "${codex_args[@]}"
    ;;

  gemini)
    gemini_script="$HOME/.claude/skills/gemini-designer/scripts/ask_gemini.sh"
    if [[ ! -x "$gemini_script" ]]; then
      echo "[ERROR] Gemini script not found or not executable: $gemini_script" >&2
      exit 1
    fi

    echo "[INFO] Executing with Gemini Designer..." >&2
    exec "$gemini_script" "$task_text" "${gemini_args[@]}"
    ;;

  *)
    echo "[ERROR] Invalid partner: $partner (must be codex, gemini, or auto)" >&2
    exit 1
    ;;
esac
