# Claude-Codex Collaboration Skill

**Automated AI-to-AI code review using Byterover as shared memory.**

Bridge context between Claude Code and Codex CLI for expert architectural review and validation—completely automated, no manual intervention required.

---

## What This Does

Enables seamless collaboration between two AI agents:
- **Claude Code**: Creates plans and implementations
- **Codex CLI**: Provides architectural reviews and code validation
- **Byterover MCP**: Shared memory layer for persistent context

**The key difference:** Claude Code directly invokes Codex via Bash—no manual copy-pasting or context switching required. The entire workflow is automated.

---

## Why Use This?

**Problem**: Getting expert code review typically means:
- Manually copying context between agents
- Losing context when switching tools
- Missing architectural issues until implementation
- Repeating the same mistakes across projects

**Solution**: Claude Code creates a plan, automatically runs Codex for review via Bash, retrieves feedback from shared memory, and implements with improvements—all in one continuous workflow.

---

## Quick Start

### Prerequisites

Both agents need Byterover MCP configured:

**Claude Code**
- Already has Byterover if you can run: `mcp__byterover-mcp__byterover-retrieve-knowledge`

**Codex CLI**
- Check configuration: `codex mcp list`
- Should show `byterover-mcp` in the list
- If missing, install following [Byterover MCP docs](https://github.com/byterover/mcp-server)

### Basic Usage

1. **Request a feature:**
   ```
   "I need to add rate limiting to my Express API"
   ```

2. **Claude automatically:**
   - Creates architectural plan
   - Stores plan in Byterover
   - **Invokes Codex directly via Bash** for review (waits 30s for indexing)
   - Waits for Codex to complete
   - Retrieves Codex's feedback (waits another 30s)
   - Implements with improvements
   - Stores implementation summary

3. **Optional validation:**
   ```
   "Have Codex validate the implementation"
   ```
   - Claude invokes Codex again for code validation
   - Addresses any final feedback

That's it. No manual commands, no context switching.

---

## How It Works

### Phase 1: Planning & Review

#### Claude Creates Plan
When you request a feature, Claude creates a comprehensive architectural plan:
- Problem statement and context
- Technical approach with code examples
- Key architectural decisions
- Specific questions for Codex
- Implementation roadmap

#### Claude Stores Plan in Byterover
Uses `byterover-store-knowledge` with rich, searchable content:
```
ARCHITECTURAL PLAN: Rate Limiting API
Status: AWAITING_REVIEW

Problem Statement: ...
Proposed Solution: ...
Technologies: Express, Redis, rate-limiter-flexible
Questions for Review: ...
```

#### Claude Invokes Codex Automatically
**Key automation:** Claude uses Bash to run Codex directly:
```typescript
Bash({
  command: `codex exec "Use byterover-retrieve-knowledge to search for the latest architectural plan about rate limiting. Review the technical approach and store feedback using byterover-store-knowledge."`,
  timeout: 300000  // 5 minutes
})
```

**Important:** Claude waits 30 seconds after storing the plan before invoking Codex (Byterover needs time to index).

#### Codex Reviews Automatically
Codex (running in background):
1. Retrieves plan from Byterover
2. Analyzes architectural approach
3. Identifies risks and improvements
4. Stores comprehensive feedback in Byterover

### Phase 2: Implementation

#### Claude Retrieves Feedback
After Codex completes (wait 30s for indexing), Claude retrieves feedback:
```typescript
byterover-retrieve-knowledge({
  query: "rate limiting Codex review architectural feedback",
  limit: 3
})
```

#### Claude Implements with Improvements
Analyzes Codex's feedback and implements incorporating:
- Recommended architectural improvements
- Solutions to identified risks
- Best practices suggested by Codex

#### Claude Stores Implementation Summary
Documents what was built and how feedback was addressed:
```
IMPLEMENTATION COMPLETE: Rate Limiting API
Status: READY_FOR_VALIDATION

What Was Built: ...
Files Created/Modified: ...
Codex Feedback Addressed:
✅ Redis connection pooling concern - Implemented connection reuse
✅ Error handling recommendation - Added circuit breaker pattern
```

### Phase 3: Validation (Optional)

#### Claude Invokes Codex for Validation
```typescript
Bash({
  command: `codex exec "Use byterover-retrieve-knowledge to search for the completed implementation of rate limiting. Review the actual code files and validate quality. Store results using byterover-store-knowledge."`,
  timeout: 300000
})
```

#### Codex Validates Code
Automatically:
- Retrieves implementation summary
- Reads actual code files
- Validates quality and patterns
- Verifies feedback was addressed
- Stores validation results

---

## Workflow Timeline

```
User: "Add rate limiting to my API"
  ↓
[Claude] Create plan → Store in Byterover
  ↓
[Wait 30s for Byterover indexing]
  ↓
[Claude] Invoke Codex via Bash →
  ↓
[Codex] Retrieve plan → Review → Store feedback
  ↓
[Wait 30s for Byterover indexing]
  ↓
[Claude] Retrieve feedback → Implement → Store summary
  ↓
User (optional): "Validate implementation"
  ↓
[Claude] Invoke Codex via Bash →
  ↓
[Codex] Retrieve summary → Validate code → Store results
  ↓
[Claude] Retrieve results → Address any issues
```

Total time: ~5-10 minutes for complete review cycle (including wait times)

---

## Best Practices

### For Users

**Let Claude handle automation:**
- Just request features naturally
- Trust the automated workflow
- Claude will inform you when Codex is running
- No need to manually run commands

**When to request validation:**
- Complex features with security implications
- Performance-critical implementations
- When extra confidence is needed

### For Claude Code

**Writing plans for review:**
- Be specific with code examples
- Ask targeted questions for Codex
- Include all relevant context
- Structure clearly with sections

**Querying Byterover:**
- Combine feature name + keywords ("rate limiting Codex review")
- Use descriptive terms for semantic matching
- Try variations if initial query fails

**Invoking Codex via Bash:**
- Always wait 30s after storing before invoking
- Use 5-minute timeout (300000ms)
- Provide complete, self-contained commands
- Inform user that Codex is running

**Storing in Byterover:**
- Include rich context for semantic search
- Use clear section headers
- Make content self-documenting
- Add searchable keywords

---

## Bundled Resources

### `collaborate.sh` (Optional)
Helper script for manual workflows or debugging:
```bash
# Generate unique session ID
./collaborate.sh session

# Get manual Codex commands (if automation fails)
./collaborate.sh codex-review SESSION-ID
./collaborate.sh codex-validate SESSION-ID

# Show help
./collaborate.sh help
```

**Note:** No longer required for normal operation since Claude invokes Codex directly.

### `references/example-session.md`
Complete walkthrough of implementing rate limiting with:
- Full plan structure
- Example Codex feedback
- Implementation with improvements
- Validation results
- Pattern extraction

Review this file to see a realistic collaboration session.

---

## Troubleshooting

### Byterover Query Returns Nothing

**Cause:** Memory not indexed yet or query too vague

**Fix:**
- Wait 30 seconds after storing
- Use more descriptive query terms
- Increase `limit` parameter
- Try broader concepts

### Codex Cannot Access Byterover

**Cause:** Byterover MCP not configured in Codex

**Fix:**
```bash
# Check MCP servers
codex mcp list

# Should show: byterover-mcp
# If missing, configure following Byterover docs
```

### Codex Invocation Times Out

**Cause:** Complex review taking longer than expected

**Fix:**
- Increase timeout to 600000ms (10 minutes)
- Simplify the plan or break into smaller chunks
- Check Codex error output

### Retrieved Memory is Wrong

**Cause:** Semantic search found similar but unintended content

**Fix:**
- Make stored memories more distinctive
- Use very specific identifying terms
- Include unique context in content
- Verify retrieved content matches expectations

---

## Limitations

### Byterover Processing Delay
- Memories take 20-30 seconds to index
- Claude waits appropriately between operations
- Users see brief pauses during workflow

### No Metadata Tags
- Byterover uses semantic search only
- Work around by embedding identifying info in content
- Use consistent formatting and unique descriptions

### Semantic Search Uncertainty
- May return similar but unintended memories
- Mitigate with specific, distinctive content
- Always verify retrieved results match expectations

---

## Value Delivered

This skill provides:

- **Higher quality code** - Issues caught in planning phase, not production
- **Expert-level review** - Codex's architectural insights on every feature
- **Zero manual overhead** - Fully automated, no context switching
- **Persistent knowledge** - All decisions stored for future reference
- **Pattern library** - Validated implementations become reusable assets
- **Continuous learning** - Build knowledge base of best practices

**Bottom line:** Expert code review on every feature, automatically, with all context preserved for future use.

---

## Installation

1. **Ensure Byterover MCP is configured** in both Claude Code and Codex CLI

2. **Place skill in Claude Code skills directory:**
   ```
   ~/.claude/skills/claude-codex-collaboration/
   ```

3. **Make collaborate.sh executable (optional):**
   ```bash
   chmod +x collaborate.sh
   ```

4. **Verify setup:**
   ```
   Ask Claude: "Do I have the claude-codex-collaboration skill available?"
   ```

That's it. Start collaborating.

---

## License

MIT License - See LICENSE file for details

---

## Contributing

This skill demonstrates automated AI-to-AI collaboration using shared memory. Contributions welcome:

- Improved query strategies for Byterover
- Additional validation patterns
- Error handling enhancements
- Documentation improvements

Submit issues or PRs to improve the collaboration workflow.
