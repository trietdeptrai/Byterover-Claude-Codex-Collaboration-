#!/bin/bash

# Claude-Codex Collaboration Helper Script
# Usage: ./collaborate.sh <task-name> [iterations]

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TASK_NAME=${1:?'Error: Task name required. Usage: ./collaborate.sh <task-name> [iterations]'}
ITERATIONS=${2:-3}
SESSION_ID="collab-$(date +%Y%m%d-%H%M%S)-${TASK_NAME}"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    Claude-Codex Collaboration Workflow${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Session ID:${NC} $SESSION_ID"
echo -e "${GREEN}Task:${NC} $TASK_NAME"
echo -e "${GREEN}Max Iterations:${NC} $ITERATIONS"
echo ""

# Function to wait for user confirmation
wait_for_user() {
  read -p "$(echo -e ${YELLOW}Press Enter to continue...${NC})" -r
  echo ""
}

# Function to invoke Codex for review
invoke_codex_review() {
  local version=$1
  echo -e "${BLUE}━━━ Invoking Codex for Review (v${version}) ━━━${NC}"

  if [ "$version" -eq 1 ]; then
    # First review - start new session
    codex exec "Retrieve the collaboration plan v${version} for session '${SESSION_ID}' from Byterover memory using the byterover-retrieve-knowledge tool. Review the plan from an architectural and implementation perspective. Store your review back in Byterover using byterover-store-knowledge with tag 'collaboration:review:v${version}:${SESSION_ID}'. Format your review with sections: Strengths, Concerns, Recommendations, and Verdict (iterate/proceed)."
  else
    # Subsequent reviews - resume session for context continuity
    codex resume --last "I've updated the plan based on your previous feedback. Please retrieve plan v${version} for session '${SESSION_ID}' from Byterover and review it. Store your review as 'collaboration:review:v${version}:${SESSION_ID}'. Compare with previous version and assess if concerns were addressed."
  fi

  echo ""
}

# Function to invoke Codex for validation
invoke_codex_validation() {
  echo -e "${BLUE}━━━ Invoking Codex for Implementation Validation ━━━${NC}"

  codex resume --last "Implementation is complete. Please retrieve the implementation summary for session '${SESSION_ID}' from Byterover. Review the actual code files listed in the summary. Validate code quality, pattern adherence, security, and test coverage. Store your validation results in Byterover with tag 'collaboration:validation:${SESSION_ID}'."

  echo ""
}

# Main workflow
echo -e "${YELLOW}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║       PHASE 1: Planning & Iteration               ║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

echo "Instructions for Claude Code:"
echo "1. Analyze the requirements for: $TASK_NAME"
echo "2. Create an initial plan (v1)"
echo "3. Store it in Byterover with tag: 'collaboration:plan:v1:${SESSION_ID}'"
echo ""
echo "Use this format:"
echo "───────────────────────────────────────────────────"
echo "**COLLABORATION PLAN v1**"
echo "Session: ${SESSION_ID}"
echo "Task: [task description]"
echo ""
echo "## Context"
echo "[relevant context]"
echo ""
echo "## Proposed Approach"
echo "[detailed plan]"
echo ""
echo "## Open Questions"
echo "[areas needing feedback]"
echo "───────────────────────────────────────────────────"
echo ""

wait_for_user

# Iteration loop
for i in $(seq 1 $ITERATIONS); do
  echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║             Iteration $i of $ITERATIONS                        ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
  echo ""

  # Codex reviews
  invoke_codex_review $i

  echo -e "${YELLOW}Review complete. Check Codex's feedback above.${NC}"
  echo ""

  # Ask if should continue iterating
  echo -e "${YELLOW}Does Codex recommend proceeding to implementation?${NC}"
  read -p "$(echo -e ${YELLOW}Continue iterating? [y/n]:${NC}) " -n 1 -r
  echo ""

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      echo -e "${GREEN}✓ Ready to implement!${NC}"
      break
    else
      echo "Invalid input. Continuing..."
    fi
  fi

  echo ""
  echo "Instructions for Claude Code:"
  echo "1. Retrieve Codex's review v$i from Byterover"
  echo "2. Address the feedback and improve the plan"
  echo "3. Store updated plan as v$((i+1)) with tag: 'collaboration:plan:v$((i+1)):${SESSION_ID}'"
  echo "4. Include a 'Changes from v$i' section"
  echo ""

  wait_for_user
done

echo ""
echo -e "${YELLOW}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║         PHASE 2: Implementation                   ║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

echo "Instructions for Claude Code:"
echo "1. Retrieve the final validated plan from Byterover"
echo "2. Implement the solution following the plan"
echo "3. Store implementation summary in Byterover with tag: 'collaboration:implementation:${SESSION_ID}'"
echo ""
echo "Implementation summary format:"
echo "───────────────────────────────────────────────────"
echo "**IMPLEMENTATION SUMMARY**"
echo "Session: ${SESSION_ID}"
echo "Based on: Plan v[final version]"
echo ""
echo "## What Was Built"
echo "[overview]"
echo ""
echo "## Key Files"
echo "[list files with paths]"
echo ""
echo "## Patterns Used"
echo "[patterns applied]"
echo ""
echo "## Testing"
echo "[testing approach and coverage]"
echo "───────────────────────────────────────────────────"
echo ""

wait_for_user

echo ""
echo -e "${YELLOW}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║         PHASE 3: Validation                       ║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

invoke_codex_validation

echo -e "${YELLOW}Validation complete. Check Codex's feedback above.${NC}"
echo ""

echo "Instructions for Claude Code:"
echo "1. Retrieve Codex's validation from Byterover"
echo "2. Address any issues or recommendations"
echo "3. If changes were made, update the implementation"
echo "4. Store final reusable patterns in Byterover for future use"
echo ""

wait_for_user

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Collaboration Complete! ✓               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Session ID:${NC} $SESSION_ID"
echo ""
echo "All context has been preserved in Byterover memory."
echo "You can query this session anytime with:"
echo -e "${YELLOW}  - Query: \"${SESSION_ID}\"${NC}"
echo -e "${YELLOW}  - Tag: \"collaboration:*:${SESSION_ID}\"${NC}"
echo ""
echo "Stored artifacts:"
echo "  • Planning iterations (v1 to v$i)"
echo "  • Codex reviews"
echo "  • Implementation summary"
echo "  • Validation results"
echo "  • Extracted patterns for reuse"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
