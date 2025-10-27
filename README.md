# Claude-Codex Collaboration Skill

Automate iterative collaboration between Claude Code and Codex CLI using Byterover as shared memory.

## Overview

This skill enables the powerful workflow pattern:
1. Claude creates a plan
2. Codex reviews the plan
3. Claude improves based on feedback
4. Iterate 2-4 times
5. Claude implements
6. Codex validates implementation

All context persists in Byterover memory, creating a shared knowledge base between both AI agents.

## Quick Start

### Option 1: Use the Helper Script (Recommended)

```bash
cd ~/.claude/skills/claude-codex-collaboration
./collaborate.sh my-feature 3
```

The script guides you through the entire workflow with prompts.

### Option 2: Manual Invocation

Activate the skill in Claude Code:
```
/skill claude-codex-collaboration
```

Then follow the workflow documented in `SKILL.md`.

### Option 3: Direct from Claude

Simply describe your workflow need:
```
"I want to implement user authentication. Let's use the Claude-Codex collaboration workflow to iterate on the plan before implementing."
```

Claude Code will automatically invoke this skill.

## Prerequisites

1. **Byterover MCP configured in both agents**:
   - Claude Code: Already configured (check with `mcp__byterover-mcp__byterover-retrieve-knowledge`)
   - Codex: Verify with `codex mcp list` (should show `byterover-mcp`)

2. **Codex CLI installed**: `which codex` should return a path

## Key Benefits

- **Shared context**: Both agents read/write to Byterover, maintaining full conversation history
- **Better quality**: Iterative review catches issues early
- **Persistent knowledge**: All decisions and patterns stored for future reference
- **Team collaboration**: Other developers can query the session to understand decisions
- **Pattern reuse**: Extract validated patterns for similar future tasks

## Example Usage

```bash
# Start a collaboration for API authentication
./collaborate.sh api-auth 3

# Claude will create plan v1
# Codex will review and provide feedback
# Iterate 3 times or until Codex says "proceed to implementation"
# Claude implements based on validated plan
# Codex validates the implementation
# Final patterns stored in Byterover
```

## Workflow Phases

### Phase 1: Planning (Iterative)
- **Claude**: Creates plan, stores in Byterover
- **Codex**: Retrieves plan, reviews, stores feedback
- **Repeat**: Until plan is validated

### Phase 2: Implementation
- **Claude**: Implements based on validated plan
- **Stores**: Implementation summary in Byterover

### Phase 3: Validation
- **Codex**: Reviews actual code, validates quality
- **Claude**: Addresses feedback, finalizes

## Memory Tags

All artifacts are tagged for easy retrieval:

```
collaboration:plan:v{N}:{session-id}
collaboration:review:v{N}:{session-id}
collaboration:implementation:{session-id}
collaboration:validation:{session-id}
```

Query example:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collaboration session-id",
  limit: 10
})
```

## Files

- `SKILL.md` - Complete skill documentation
- `README.md` - This file
- `collaborate.sh` - Helper script for guided workflow
- `references/example-session.md` - Full example walkthrough

## Tips

1. **Session naming**: Use descriptive task names: `api-auth`, `rate-limiting`, `payment-integration`
2. **Iteration count**: Typically 2-4 cycles is optimal
3. **Codex context**: Use `codex resume --last` to maintain context across reviews
4. **Store patterns**: Always extract final patterns for team reuse

## Troubleshooting

**Issue**: Codex doesn't retrieve from Byterover

**Solution**: Explicitly instruct Codex to use the MCP tool:
```bash
codex exec "Use the byterover-retrieve-knowledge MCP tool to retrieve plan from session X"
```

**Issue**: Memory not persisting

**Solution**: Verify both agents have Byterover configured:
- Claude: Check available MCP tools
- Codex: Run `codex mcp list` and verify `byterover-mcp` is enabled

**Issue**: Too many iterations without convergence

**Solution**: Have user make final decisions on contentious points, store in Byterover, and proceed

## Advanced Usage

### Query Previous Sessions

```typescript
// Find all collaboration sessions
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collaboration session",
  limit: 20
})

// Find specific pattern from past collaboration
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "rate limiting redis pattern collaboration",
  limit: 5
})
```

### Team Knowledge Sharing

After completing a collaboration:
1. Share session ID with team
2. Team members can query the session to see full decision history
3. Patterns become team knowledge base

### Cross-Project Patterns

Validated patterns from one project can be reused in others:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "authentication JWT pattern collaboration",
  limit: 3
})
```

## Integration with Other Skills

This skill works great with:
- **byterover-memory**: General knowledge retrieval before/after collaboration
- **notion-knowledge-capture**: Export final validated plans to Notion for documentation

## Contributing

Improve this skill by:
1. Sharing successful collaboration sessions
2. Documenting new patterns discovered
3. Suggesting workflow enhancements

## License

This skill follows the same license as your Claude Code installation.

---

**Happy Collaborating! 🤝**

For detailed workflow instructions, see `SKILL.md`.
For a complete example, see `references/example-session.md`.
