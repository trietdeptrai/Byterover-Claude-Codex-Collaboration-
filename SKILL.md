---
name: claude-codex-collaboration
description: Orchestrate iterative collaboration between Claude Code and Codex CLI using Byterover as shared memory. Use for planning, review cycles, and implementation validation workflows where both agents need persistent context.
allowed-tools:
  - mcp__byterover-mcp__byterover-store-knowledge
  - mcp__byterover-mcp__byterover-retrieve-knowledge
  - Bash
  - Read
  - Write
---

# Claude-Codex Collaboration Workflow

This skill automates the iterative collaboration pattern between Claude Code and Codex CLI, using Byterover MCP as the shared memory layer for persistent context across agents.

## Workflow Overview

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│   Claude    │ ◄────► │   Byterover  │ ◄────► │    Codex    │
│    Code     │         │    Memory    │         │     CLI     │
└─────────────┘         └──────────────┘         └─────────────┘
```

Both agents share context through Byterover's memory layer, enabling:
- **Plan iteration**: Claude plans → Codex reviews → Claude improves
- **Implementation validation**: Claude implements → Codex checks
- **Continuous context**: All feedback and decisions persist across the session

## When to Use This Skill

Use this skill when you want to:
- Get Codex's perspective on Claude's architectural plans
- Iterate on designs through multi-agent review cycles
- Have Codex validate Claude's implementation quality
- Leverage both agents' strengths in a single workflow
- Maintain conversation context across agent switches

## Core Workflow Phases

### Phase 1: Planning & Iteration

**Objective**: Develop a robust plan through multi-agent review cycles

1. **Claude creates initial plan**
   - Analyze requirements
   - Design architecture/approach
   - Store plan in Byterover with tag `collaboration:plan:v{N}`

2. **Codex reviews plan**
   - Retrieve plan from Byterover
   - Provide architectural feedback
   - Store review in Byterover with tag `collaboration:review:v{N}`

3. **Claude improves plan**
   - Retrieve Codex's review
   - Address feedback
   - Update plan in Byterover
   - Repeat 2-3 as needed (typically 2-4 cycles)

### Phase 2: Implementation

**Objective**: Build the solution based on the validated plan

1. **Claude implements**
   - Retrieve final plan from Byterover
   - Implement the solution
   - Store implementation summary in Byterover with tag `collaboration:implementation`

### Phase 3: Validation

**Objective**: Get final quality check from Codex

1. **Codex validates**
   - Retrieve implementation details from Byterover
   - Review code quality, patterns, edge cases
   - Store validation results with tag `collaboration:validation`

2. **Claude addresses feedback** (if needed)
   - Retrieve validation feedback
   - Fix issues
   - Update implementation

## Implementation Guide

### Setting Up Collaboration Context

At the start of a collaboration session, create a **collaboration session ID** to namespace the memory:

```
Session ID format: collab-{timestamp}-{task-slug}
Example: collab-20251026-user-auth-feature
```

### Storage Format for Plans

When storing plans in Byterover:

```markdown
**COLLABORATION PLAN v{N}**
Session: {session-id}
Task: {brief task description}

## Context
{relevant context about the problem/requirements}

## Proposed Approach
{detailed plan or architecture}

## Open Questions
{areas where feedback is needed}

## Changes from v{N-1}
{if this is an iteration, what changed based on feedback}
```

### Storage Format for Reviews

When storing reviews in Byterover:

```markdown
**CODEX REVIEW v{N}**
Session: {session-id}
Plan reviewed: v{N}

## Strengths
{positive aspects of the plan}

## Concerns
{potential issues or risks}

## Recommendations
{specific suggestions for improvement}

## Verdict
{overall assessment - iterate/proceed to implementation}
```

### Storage Format for Implementation Summary

```markdown
**IMPLEMENTATION SUMMARY**
Session: {session-id}
Based on: Plan v{final-version}

## What Was Built
{overview of implementation}

## Key Files
{list of main files with paths}

## Patterns Used
{architectural/design patterns applied}

## Testing
{testing approach and coverage}
```

### Storage Format for Validation

```markdown
**CODEX VALIDATION**
Session: {session-id}

## Code Quality
{assessment of code quality}

## Pattern Adherence
{whether implementation matches plan}

## Issues Found
{list of issues if any}

## Recommendations
{suggestions for improvement}
```

## Practical Usage Examples

### Example 1: Feature Development

**Task**: Implement user authentication with JWT

```
User: "I need to add user authentication to my Express API"

Claude (using this skill):
1. Creates initial plan for JWT auth
2. Stores plan in Byterover with tag "collaboration:plan:v1"
3. Invokes Codex via CLI: codex exec "Retrieve collaboration plan v1 from Byterover and review it"
4. Codex reviews and stores feedback
5. Claude retrieves feedback, improves plan → v2
6. Repeats 2-3 times until Codex says "proceed to implementation"
7. Claude implements the feature
8. Stores implementation summary
9. Invokes Codex: "Retrieve implementation from Byterover and validate"
10. Codex provides validation
11. Claude addresses any final issues
```

### Example 2: Refactoring

**Task**: Refactor monolithic service into microservices

```
1. Claude analyzes codebase and creates decomposition plan
2. Stores in Byterover: "collaboration:refactor-plan:v1"
3. Codex reviews plan, identifies service boundaries and data dependencies
4. Claude refines based on feedback (v2, v3)
5. Once plan is solid, Claude implements Phase 1
6. Codex validates Phase 1 implementation
7. Repeat for subsequent phases
```

## Codex Integration Commands

### Starting a Codex Review Session

```bash
# Review a plan stored in Byterover
codex exec "Retrieve the latest collaboration plan from Byterover memory for session 'collab-20251026-user-auth' and provide architectural review. Store your review back in Byterover with tag 'collaboration:review:v1'"

# Resume a previous Codex session (maintains context)
codex resume --last "Continue reviewing the updated plan v2 from Byterover"
```

### Codex Validation Session

```bash
# Validate implementation
codex exec "Retrieve implementation summary from Byterover for session 'collab-20251026-user-auth'. Review the actual code files listed and provide validation. Store feedback in Byterover with tag 'collaboration:validation'"
```

### Maintaining Codex Context

To maintain context across Codex invocations:

1. **Use session resumption**: `codex resume --last` continues the most recent session
2. **Reference Byterover explicitly**: Always mention session ID and what to retrieve
3. **Store incrementally**: Each Codex interaction stores results back to Byterover

## Automation Script (Optional)

For fully automated iteration, create a helper script:

```bash
#!/bin/bash
# collaborate.sh

SESSION_ID="collab-$(date +%Y%m%d-%H%M%S)-$1"
ITERATIONS=${2:-3}

echo "Starting collaboration session: $SESSION_ID"
echo "Iterations: $ITERATIONS"

for i in $(seq 1 $ITERATIONS); do
  echo "\n=== Iteration $i ==="

  # Claude creates/updates plan
  echo "Claude: Creating plan v$i..."
  # (Claude Code handles this)

  # Codex reviews
  echo "Codex: Reviewing plan v$i..."
  codex exec "Retrieve plan v$i from Byterover for session '$SESSION_ID' and provide review. Store as review v$i"

  # Ask user if should continue
  read -p "Continue to next iteration? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    break
  fi
done

echo "\n=== Implementation Phase ==="
# Claude implements
# (Claude Code handles this)

echo "\n=== Validation Phase ==="
codex exec "Retrieve implementation from Byterover for session '$SESSION_ID' and validate. Store validation results."
```

## Best Practices

### 1. Clear Session Naming
Use descriptive session IDs that make it easy to identify related memories:
- `collab-20251026-user-auth-feature`
- `collab-20251026-refactor-database-layer`

### 2. Structured Iteration
- Typically 2-4 review cycles is optimal
- More than 5 cycles suggests requirements need clarification
- Each iteration should address specific feedback points

### 3. Explicit Handoffs
When invoking Codex, be explicit about:
- What to retrieve from Byterover (session ID + tag)
- What feedback you need
- Where to store results (tag format)

### 4. Version Tracking
Use semantic versioning for plans:
- v1, v2, v3 for iterations
- Store "Changes from v{N-1}" to track evolution

### 5. Context Pruning
After collaboration completes:
- Store final validated plan as standalone memory
- Store implementation patterns as reusable knowledge
- Can archive intermediate iterations

## Troubleshooting

### Issue: Codex doesn't have context from previous iteration

**Solution**: Ensure Codex retrieves from Byterover at the start of each invocation:
```bash
codex resume --last "First retrieve all previous reviews from Byterover for session X, then review plan vN"
```

### Issue: Too much back-and-forth without convergence

**Solution**:
1. Ask both agents to identify specific disagreement points
2. Store those as "open questions" in Byterover
3. Have user make final decision on contentious points
4. Update plan with decisions and proceed

### Issue: Byterover memory getting cluttered

**Solution**: Use consistent tagging with session IDs:
- `collaboration:plan:v{N}:{session-id}`
- Makes it easy to query specific session
- Can clean up after collaboration completes

## Advanced: Team Collaboration

Multiple team members can benefit from collaboration sessions:

1. **Session sharing**: Other devs can query the session ID to see full conversation
2. **Pattern reuse**: Final validated plans become team knowledge
3. **Consistency**: Same review process across team members

## Integration with Byterover Skill

This skill is designed to work alongside the `byterover-memory` skill:

- **This skill**: Orchestrates Claude-Codex collaboration workflow
- **byterover-memory skill**: Handles general knowledge retrieval/storage

Use both together:
1. Retrieve general patterns with `byterover-memory`
2. Use this skill for collaboration workflow
3. Store final patterns back with `byterover-memory`

## Example Full Session

See `references/example-session.md` for a complete walkthrough of a real collaboration session from start to finish.

## Quick Reference

### Collaboration Flow
1. Create session ID
2. Claude plans (store v1)
3. Codex reviews (store review v1)
4. Claude improves (store v2)
5. Repeat 3-4 until ready
6. Claude implements (store summary)
7. Codex validates (store validation)
8. Claude fixes if needed
9. Store final patterns

### Key Commands
```bash
# Start Codex review
codex exec "Retrieve plan from Byterover session X and review"

# Continue previous session
codex resume --last

# Validate implementation
codex exec "Retrieve implementation from Byterover session X and validate"
```

### Memory Tags
- `collaboration:plan:v{N}:{session-id}`
- `collaboration:review:v{N}:{session-id}`
- `collaboration:implementation:{session-id}`
- `collaboration:validation:{session-id}`
