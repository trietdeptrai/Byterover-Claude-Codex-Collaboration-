# Claude-Codex Collaboration Skill

**Bridge context between Claude Code and Codex CLI using Byterover as shared memory.**

## What This Skill Does

Enables seamless collaboration between two AI agents:
- **Claude Code**: Creates plans and implementations
- **Codex CLI**: Provides architectural reviews and validation
- **Byterover MCP**: Shared memory layer for persistent context

## Why Use This?

**Problem**: Switching between Claude Code and Codex means losing context. You have to manually copy-paste information between agents.

**Solution**: Both agents store and retrieve knowledge from Byterover, creating a shared workspace where context persists across agent switches.

## Quick Start

### 1. User Requests Feature

```
"I need to add user authentication to my app"
```

### 2. Claude Creates Plan & Stores in Byterover

Claude will:
- Design the implementation approach
- Store plan in Byterover with unique session ID
- Provide Codex command for you to run

```
Session ID: SESSION-20251027-A7F3K2M9

Run this command:
codex exec "Retrieve plan SESSION-20251027-A7F3K2M9 from Byterover and review"
```

### 3. You Run Codex Review

```bash
codex exec "Retrieve plan SESSION-20251027-A7F3K2M9 from Byterover and provide architectural review. Store feedback in Byterover."
```

Codex will:
- Retrieve Claude's plan
- Provide expert review
- Store feedback back in Byterover

### 4. Return to Claude for Implementation

```
"Codex has reviewed. Please retrieve feedback and implement."
```

Claude will:
- Retrieve Codex's review
- Address feedback
- Implement the feature
- Store implementation summary

### 5. Codex Validates (Optional)

```bash
codex exec "Retrieve implementation SESSION-20251027-A7F3K2M9 from Byterover and validate code quality"
```

## Installation

### Prerequisites

**Both agents need Byterover MCP configured:**

#### Claude Code
Already has Byterover if you can run:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge
```

#### Codex CLI
Check configuration:
```bash
codex mcp list
# Should show: byterover-mcp
```

### Install This Skill

```bash
# Clone to Claude Code skills directory
cd ~/.claude/skills
git clone <your-repo-url> claude-codex-collaboration
```

Or copy the directory to `~/.claude/skills/claude-codex-collaboration`

## How It Works

### Workflow Diagram

```
User Request
     ↓
Claude Creates Plan
     ↓
Store in Byterover ──────┐
     ↓                   │
User Runs Codex          │
     ↓                   │
Codex Retrieves ←────────┘
     ↓
Codex Reviews
     ↓
Store in Byterover ──────┐
     ↓                   │
Return to Claude         │
     ↓                   │
Claude Retrieves ←───────┘
     ↓
Claude Implements
     ↓
✅ Done (with optional validation step)
```

### Key Features

✅ **Persistent Context**: All knowledge stored in Byterover
✅ **Semantic Search**: Find relevant memories by meaning
✅ **Cross-Agent**: Both Claude and Codex access same memories
✅ **Pattern Library**: Build reusable validated patterns
✅ **Quality Assurance**: Plans reviewed before implementation

## Example Session

```bash
# User to Claude Code:
"Add rate limiting to my Express API"

# Claude creates plan and stores:
# SESSION-20251027-A7F3K2M9 created

# User runs Codex:
$ codex exec "Retrieve SESSION-20251027-A7F3K2M9 and review"
# Codex: "IP-based limiting problematic, recommend hybrid approach..."

# User to Claude Code:
"Retrieve Codex feedback and implement"

# Claude implements with improvements:
# ✅ Hybrid user/IP identification
# ✅ Redis with fallback
# ✅ Comprehensive tests

# User runs Codex validation:
$ codex exec "Validate SESSION-20251027-A7F3K2M9 implementation"
# Codex: "Production-ready, 9/10 quality score"
```

## Benefits

### 1. Better Quality
Plans get expert review before implementation, catching issues early.

### 2. Efficiency
No manual context transfer. Both agents share knowledge automatically.

### 3. Knowledge Base
Validated patterns stored for future reuse across projects.

### 4. Transparency
Full history of decisions and reasoning available in Byterover.

### 5. Team Collaboration
Other developers can query sessions to understand architectural decisions.

## File Structure

```
claude-codex-collaboration/
├── README.md        # This file
├── SKILL.md         # Complete workflow documentation
├── ANALYSIS.md      # Technical analysis of Byterover capabilities
├── LICENSE          # MIT License
└── references/
    └── (examples coming soon)
```

## Usage Tips

### 1. Unique Session IDs
Always use unique, random session IDs:
```
✅ SESSION-20251027-A7F3K2M9-rate-limiting
❌ session-1
```

### 2. Rich Context
Include full context in stored memories for better semantic search.

### 3. Descriptive Queries
Query with multiple identifying terms:
```typescript
query: "SESSION-20251027-A7F3K2M9 Codex review feedback rate limiting"
```

### 4. Wait for Processing
Byterover processes memories asynchronously. Wait 20-30 seconds after storing before retrieving.

## Limitations

### No Tags/Labels
Byterover uses semantic search, not metadata tags. Workaround: Embed session IDs in content.

### No Exact Versioning
Can't reliably distinguish "plan v1" from "v2". Workaround: Use different session IDs for iterations.

### Semantic Search Uncertainty
May retrieve similar but wrong memory. Workaround: Use highly unique session IDs.

See `SKILL.md` for detailed workarounds and best practices.

## Documentation

- **README.md** (this file): Quick overview and installation
- **SKILL.md**: Complete workflow guide with examples
- **ANALYSIS.md**: Technical analysis of Byterover capabilities and limitations

## Use Cases

### Feature Development
Get architectural review before building new features.

### Refactoring
Validate refactoring approach with Codex before making changes.

### Code Review
Have Codex validate Claude's implementations.

### Pattern Library
Build collection of validated, production-ready patterns.

### Team Knowledge
Share architectural decisions across team members.

## Troubleshooting

### Can't Retrieve Memory
- Use more descriptive query terms
- Increase limit parameter (try 3-5)
- Wait 30 seconds after storing
- Verify session ID is correct

### Retrieved Wrong Memory
- Use more unique session IDs
- Add more context to stored memories
- Include task description in query

### Codex Can't Access Byterover
- Check: `codex mcp list` should show `byterover-mcp`
- Add Byterover to Codex config if missing

## Contributing

Improvements welcome! To contribute:
1. Try the workflow with real projects
2. Document successful patterns
3. Share feedback on what works well
4. Suggest workflow enhancements

## License

MIT License - See LICENSE file

## Learn More

For complete workflow documentation with examples, see **SKILL.md**.

---

**Start collaborating with context!** 🤝

Invoke this skill in Claude Code when you want to leverage Codex's review capabilities while maintaining full context through Byterover.
