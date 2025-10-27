# Quick Start Guide - 5 Minutes

## The Simplest Way to Use This Skill

### For Claude Code Users:

Just tell Claude what you want to build with collaboration:

```
"I want to implement a payment processing feature.
Let's use the Claude-Codex collaboration workflow."
```

Claude will automatically:
1. Create a plan and store in Byterover
2. Guide you to invoke Codex for review
3. Iterate based on feedback
4. Implement the validated solution
5. Have Codex validate the final implementation

---

## Three Ways to Start

### 1. Automated Script (Easiest)

```bash
cd ~/.claude/skills/claude-codex-collaboration
./collaborate.sh payment-processing 3
```

Follow the prompts. The script handles everything.

### 2. Manual with Skill

Tell Claude:
```
"Use the claude-codex-collaboration skill for implementing [feature]"
```

### 3. Pure Manual

**Step 1**: Claude creates plan
```typescript
// In Claude Code
// 1. Create your plan
// 2. Store in Byterover:
mcp__byterover-mcp__byterover-store-knowledge({
  messages: "COLLABORATION PLAN v1\nSession: collab-...\n[your plan]"
})
```

**Step 2**: Codex reviews
```bash
codex exec "Retrieve collaboration plan v1 from Byterover for session X and review. Store feedback in Byterover."
```

**Step 3**: Repeat iteration
- Claude retrieves feedback, improves plan
- Codex reviews again
- Continue until validated

**Step 4**: Claude implements
**Step 5**: Codex validates

---

## What You Need

✅ Claude Code (you have this)
✅ Codex CLI installed: `which codex`
✅ Byterover MCP in both agents: `codex mcp list`

---

## Example Session (2 minutes)

```bash
# Start collaboration
./collaborate.sh user-auth 2

# When prompted, tell Claude:
"Plan a JWT authentication system for Express API"

# Claude creates plan → stores in Byterover
# Script invokes Codex → Codex reviews → stores feedback
# Claude improves plan based on feedback
# Iterate once more
# Claude implements
# Codex validates
# Done! ✓
```

---

## Session Output

After completion, all of this is stored in Byterover:
- ✓ Plan iterations (v1, v2, v3...)
- ✓ Codex reviews
- ✓ Implementation summary
- ✓ Validation results
- ✓ Reusable patterns

Query anytime:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collab-20251026-user-auth",
  limit: 10
})
```

---

## Pro Tips

**Tip 1**: Be specific with task names
- Good: `jwt-auth-refresh-tokens`
- Bad: `auth`

**Tip 2**: Let Codex say when ready
- Don't rush to implementation
- Iterate until Codex says "proceed to implementation"

**Tip 3**: Store final patterns
- Extract reusable patterns after validation
- Store in Byterover for future projects
- Tag appropriately for easy discovery

---

## Common Use Cases

| Use Case | Iterations | Time |
|----------|-----------|------|
| New API endpoint | 2 | 30 min |
| Auth system | 3 | 1 hour |
| Database refactor | 4 | 2 hours |
| Microservice design | 5 | 3 hours |

---

## Troubleshooting in 30 Seconds

**Problem**: Codex can't find plan
**Fix**: Make sure you used the right session ID when storing

**Problem**: Context not persisting
**Fix**: Use `codex resume --last` to continue same session

**Problem**: Too many iterations
**Fix**: Make architectural decisions yourself, store in Byterover, proceed

---

## That's It!

You now know everything you need to start collaborating.

**Next steps**:
1. Try the script: `./collaborate.sh test-feature 2`
2. Read `SKILL.md` for detailed docs
3. Check `references/example-session.md` for full example

**Questions?** Check `README.md` or ask Claude!

---

**Ready? Let's build something! 🚀**
