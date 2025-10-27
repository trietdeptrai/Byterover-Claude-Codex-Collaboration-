#!/bin/bash

# Claude-Codex Collaboration Helper Script
# Provides command templates for the collaboration workflow
#
# Usage: ./collaborate.sh <command>
#
# Commands:
#   session     - Generate a new unique session ID
#   codex-review <session-id>  - Get command to run Codex review
#   codex-validate <session-id> - Get command to run Codex validation
#   help        - Show this help message

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_help() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}    Claude-Codex Collaboration Helper${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Usage: ./collaborate.sh <command> [args]"
    echo ""
    echo "Commands:"
    echo ""
    echo -e "  ${GREEN}session${NC}"
    echo "    Generate a new unique session ID for a collaboration"
    echo ""
    echo -e "  ${GREEN}codex-review${NC} <session-id>"
    echo "    Get the Codex command to review Claude's plan"
    echo ""
    echo -e "  ${GREEN}codex-validate${NC} <session-id>"
    echo "    Get the Codex command to validate Claude's implementation"
    echo ""
    echo -e "  ${GREEN}help${NC}"
    echo "    Show this help message"
    echo ""
    echo "Example Workflow:"
    echo ""
    echo "  # 1. Generate session ID"
    echo -e "  ${CYAN}./collaborate.sh session${NC}"
    echo "  # Output: SESSION-20251027-A7F3K2M9"
    echo ""
    echo "  # 2. Ask Claude to create plan with that session ID"
    echo "  # (In Claude Code)"
    echo ""
    echo "  # 3. Get Codex review command"
    echo -e "  ${CYAN}./collaborate.sh codex-review SESSION-20251027-A7F3K2M9${NC}"
    echo "  # Copy and run the output command"
    echo ""
    echo "  # 4. Return to Claude to implement"
    echo "  # (In Claude Code)"
    echo ""
    echo "  # 5. Get Codex validation command"
    echo -e "  ${CYAN}./collaborate.sh codex-validate SESSION-20251027-A7F3K2M9${NC}"
    echo "  # Copy and run the output command"
    echo ""
}

generate_session_id() {
    # Generate timestamp
    local timestamp=$(date +%Y%m%d)

    # Generate random 8-character alphanumeric string
    local random=$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom | head -c 8)

    local session_id="SESSION-${timestamp}-${random}"

    echo ""
    echo -e "${GREEN}✓${NC} Generated unique session ID:"
    echo ""
    echo -e "  ${CYAN}${session_id}${NC}"
    echo ""
    echo "Use this session ID when asking Claude to create a plan:"
    echo ""
    echo -e "${YELLOW}Example prompt for Claude Code:${NC}"
    echo "\"Create a plan for [your feature] and store it in Byterover with session ID: ${session_id}\""
    echo ""
}

codex_review_command() {
    local session_id=$1

    if [ -z "$session_id" ]; then
        echo -e "${YELLOW}Error: Session ID required${NC}"
        echo ""
        echo "Usage: ./collaborate.sh codex-review <session-id>"
        echo ""
        echo "Example:"
        echo "  ./collaborate.sh codex-review SESSION-20251027-A7F3K2M9"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}✓${NC} Codex Review Command for session: ${CYAN}${session_id}${NC}"
    echo ""
    echo -e "${YELLOW}Copy and run this command:${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "codex exec \"Use the byterover-retrieve-knowledge tool to search for '${session_id} Claude plan'. Review the architectural approach and provide detailed feedback. Store your review in Byterover using byterover-store-knowledge, including the same session ID '${session_id}'.\""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "${BLUE}What Codex will do:${NC}"
    echo "  1. Retrieve Claude's plan from Byterover"
    echo "  2. Analyze the architectural approach"
    echo "  3. Provide detailed feedback and recommendations"
    echo "  4. Store the review back in Byterover"
    echo ""
    echo -e "${BLUE}After Codex completes:${NC}"
    echo "  Return to Claude Code and say:"
    echo "  \"Codex has reviewed. Retrieve feedback for ${session_id} and implement.\""
    echo ""
}

codex_validate_command() {
    local session_id=$1

    if [ -z "$session_id" ]; then
        echo -e "${YELLOW}Error: Session ID required${NC}"
        echo ""
        echo "Usage: ./collaborate.sh codex-validate <session-id>"
        echo ""
        echo "Example:"
        echo "  ./collaborate.sh codex-validate SESSION-20251027-A7F3K2M9"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}✓${NC} Codex Validation Command for session: ${CYAN}${session_id}${NC}"
    echo ""
    echo -e "${YELLOW}Copy and run this command:${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "codex exec \"Use the byterover-retrieve-knowledge tool to search for '${session_id} implementation'. Review the actual code files listed and validate the implementation quality. Store validation results in Byterover using byterover-store-knowledge with session ID '${session_id}'.\""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "${BLUE}What Codex will do:${NC}"
    echo "  1. Retrieve implementation summary from Byterover"
    echo "  2. Review the actual code files"
    echo "  3. Validate code quality and best practices"
    echo "  4. Store validation results in Byterover"
    echo ""
    echo -e "${BLUE}After Codex completes:${NC}"
    echo "  Return to Claude Code to address any feedback if needed"
    echo ""
}

# Main script logic
case "${1:-help}" in
    session)
        generate_session_id
        ;;
    codex-review)
        codex_review_command "$2"
        ;;
    codex-validate)
        codex_validate_command "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${YELLOW}Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
