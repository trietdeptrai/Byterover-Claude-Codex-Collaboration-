---
name: claude-codex-collaboration
description: Transfer context between Claude Code and Codex CLI using Byterover as shared memory. Claude creates plans and implementations while Codex provides reviews and validation. Enables cross-agent collaboration with persistent context.
allowed-tools:
  - mcp__byterover-mcp__byterover-store-knowledge
  - mcp__byterover-mcp__byterover-retrieve-knowledge
  - Bash
  - Read
  - Write
---

# Claude-Codex Collaboration Skill

**Context Transfer Between AI Agents Using Byterover**

This skill enables collaboration between Claude Code and Codex CLI by using Byterover as a shared memory layer. Claude creates plans and implementations, Codex provides reviews and validation, and all context persists for both agents to access.

## Core Value Proposition

**Problem**: When working with both Claude Code and Codex, context doesn't transfer between agents. You have to manually copy-paste information, losing efficiency and context.

**Solution**: Use Byterover MCP as shared memory. Both agents can store and retrieve knowledge, enabling true collaboration workflows.

## When to Use This Skill

Use this skill when you want to:
- Get Codex's architectural review on Claude's plans before implementation
- Have Codex validate Claude's implementation quality
- Leverage both agents' strengths in a single workflow
- Maintain persistent context across agent switches
- Build a knowledge base of validated patterns

## Workflow Overview

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│   Claude    │ ──────► │   Byterover  │ ◄────── │    Codex    │
│    Code     │         │    Memory    │         │     CLI     │
│  (Plans &   │         │   (Shared    │         │  (Review &  │
│  Implement) │         │   Context)   │         │  Validate)  │
└─────────────┘         └──────────────┘         └─────────────┘
```

**Simple 4-Step Process:**

1. **Claude Creates Plan** → Stores in Byterover with unique session ID
2. **Codex Reviews Plan** → Retrieves from Byterover, provides feedback
3. **Claude Implements** → Based on validated plan
4. **Codex Validates** → Reviews actual code, final approval

## Understanding Byterover's Capabilities

### What Byterover Provides

Byterover uses **semantic search** over stored memories:

```typescript
// Store knowledge - only parameter: messages (string)
mcp__byterover-mcp__byterover-store-knowledge({
  messages: "Your content here..."
})

// Retrieve knowledge - semantic search
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "search query",
  limit: 5
})
```

**Key characteristics:**
- ✅ Semantic search (finds by meaning, not just keywords)
- ✅ Persistent across sessions
- ✅ Accessible by both Claude Code and Codex
- ❌ No tags/labels (use unique IDs in content instead)
- ❌ No exact versioning (semantic matching only)

### Working Within Constraints

**Use unique session IDs in content** to make memories retrievable:

```markdown
**[SESSION-ABC123-XYZ789] Claude Plan: User Authentication**

Generate a random, unique session ID and include it in EVERY stored artifact.
This makes retrieval more reliable via semantic search.
```

## Practical Workflow

### Step 1: Claude Creates Plan

When the user requests a feature:

1. **Generate unique session ID**: Use timestamp + random string
   ```
   SESSION-20251027-A7F3K2M9
   ```

2. **Create detailed plan**

3. **Store in Byterover** with session ID embedded:

```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**[SESSION-20251027-A7F3K2M9] CLAUDE PLAN: Rate Limiting for Express API**

## Context
User wants to add rate limiting to Express API to prevent abuse.
API serves both web and mobile clients.

## Proposed Approach

### 1. Library Selection
Use express-rate-limit with Redis backend
- Production-ready, 10M+ downloads/week
- Supports distributed systems via Redis

### 2. Implementation Strategy
\`\`\`typescript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per window
  standardHeaders: true,
  store: new RedisStore({
    client: redisClient,
    prefix: 'rate_limit:'
  })
});

app.use(limiter);
\`\`\`

### 3. Configuration
- Global limit: 100 req/15min
- Auth endpoints: 20 req/15min (stricter)
- Monitoring via logging

## Open Questions for Codex Review
1. Should we use IP-based or user-based rate limiting?
2. What about users behind corporate NAT?
3. Redis failure handling strategy?

## Status
AWAITING_CODEX_REVIEW

Session ID for retrieval: SESSION-20251027-A7F3K2M9
`
})
```

4. **Tell user to invoke Codex**:
   ```
   "I've stored the plan in Byterover with session ID: SESSION-20251027-A7F3K2M9

   Please run Codex with this command:

   codex exec \"Retrieve the plan with session ID SESSION-20251027-A7F3K2M9 from Byterover memory and provide architectural review. Store your feedback in Byterover with the same session ID.\"
   ```

### Step 2: Codex Reviews Plan

**User runs Codex command** (from Claude's instruction).

**Codex will:**

1. Retrieve plan from Byterover:
   ```typescript
   mcp__byterover-mcp__byterover-retrieve-knowledge({
     query: "SESSION-20251027-A7F3K2M9 Claude plan rate limiting",
     limit: 1
   })
   ```

2. Analyze and provide review

3. Store feedback in Byterover:
   ```typescript
   mcp__byterover-mcp__byterover-store-knowledge({
     messages: `
**[SESSION-20251027-A7F3K2M9] CODEX REVIEW: Rate Limiting Plan**

## Strengths
- Solid library choice
- Redis for distributed systems is correct

## Concerns
1. **IP-based limiting problematic**: Users behind corporate NAT share IPs
2. **Missing**: Hybrid approach (user ID when authenticated, IP as fallback)
3. **Redis failure handling**: Need fallback strategy

## Recommendations
\`\`\`typescript
const keyGenerator = (req) => {
  return req.user?.id || req.ip; // Hybrid approach
};
\`\`\`

Add Redis error handling with memory fallback.

## Verdict
✅ APPROVE with modifications above

Session ID: SESSION-20251027-A7F3K2M9
`
   })
   ```

### Step 3: Claude Retrieves Feedback & Implements

**User returns to Claude Code** and says:
```
"Codex has reviewed the plan. Please retrieve the feedback and implement."
```

**Claude will:**

1. Retrieve Codex's review:
   ```typescript
   mcp__byterover-mcp__byterover-retrieve-knowledge({
     query: "SESSION-20251027-A7F3K2M9 Codex review feedback",
     limit: 2
   })
   ```

2. Address feedback in implementation

3. Implement the feature with improvements

4. Store implementation summary:
   ```typescript
   mcp__byterover-mcp__byterover-store-knowledge({
     messages: `
**[SESSION-20251027-A7F3K2M9] IMPLEMENTATION COMPLETE: Rate Limiting**

## What Was Built
Rate limiting system with Codex's recommended improvements:
- Hybrid key generator (user ID + IP fallback)
- Redis with memory store fallback
- Comprehensive error handling

## Files Created/Modified
- src/middleware/rateLimiter.ts (147 lines)
- src/config/redis.ts (45 lines)
- src/middleware/__tests__/rateLimiter.test.ts (218 lines)

## Changes from Plan
✅ Added hybrid user/IP identification (Codex recommendation)
✅ Added Redis error handling with fallback
✅ Enhanced monitoring

## Status
READY_FOR_CODEX_VALIDATION

Session ID: SESSION-20251027-A7F3K2M9
`
   })
   ```

### Step 4: Codex Validates Implementation

**User invokes Codex for validation**:
```bash
codex exec "Retrieve implementation with session ID SESSION-20251027-A7F3K2M9 from Byterover. Review the actual code files and validate quality. Store validation results."
```

**Codex will:**

1. Retrieve implementation summary
2. Review actual code files listed
3. Validate against best practices
4. Store validation results in Byterover

## Best Practices

### 1. Always Use Unique Session IDs

```
✅ Good: SESSION-20251027-A7F3K2M9-rate-limiting
✅ Good: SESSION-20251027-X9K2LP41-auth-system

❌ Bad: session-1 (too generic)
❌ Bad: rate-limiting (no uniqueness)
```

**Generate using**: Timestamp + random alphanumeric string + task description

### 2. Embed Session ID Everywhere

Every memory you store should include the session ID in:
- The title/header (for visibility)
- The content (for semantic search)
- At the end (for reference)

### 3. Use Clear Status Markers

```markdown
## Status
AWAITING_CODEX_REVIEW
READY_FOR_IMPLEMENTATION
READY_FOR_CODEX_VALIDATION
COMPLETE
```

This helps both agents understand where in the workflow you are.

### 4. Include Context in Every Store

Don't assume agents remember. Each stored artifact should be **self-contained**:

```markdown
✅ Good:
"[SESSION-X] Plan for rate limiting Express API. User wants to prevent abuse..."

❌ Bad:
"[SESSION-X] Here's the plan." (missing context)
```

### 5. Query with Multiple Terms

Semantic search works best with descriptive queries:

```typescript
✅ Good:
query: "SESSION-20251027-A7F3K2M9 Codex review rate limiting feedback"

❌ Bad:
query: "SESSION-20251027-A7F3K2M9" (too narrow)
```

## Troubleshooting

### Issue: Can't Retrieve Previous Memory

**Cause**: Semantic search didn't find it or returned wrong result

**Fix**:
1. Use more specific query with multiple identifying terms
2. Increase limit parameter (try limit: 5 instead of 1)
3. Include task description in query, not just session ID

```typescript
// Better retrieval
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "SESSION-20251027-A7F3K2M9 Claude plan rate limiting Express API",
  limit: 3  // Get top 3 matches
})
```

### Issue: Retrieved Wrong Session's Memory

**Cause**: Session IDs too similar or insufficient context

**Fix**:
1. Use more random characters in session ID
2. Include task description in session ID
3. Add more context in stored content

### Issue: Codex Doesn't Have MCP Tools

**Cause**: Codex may not have Byterover MCP configured

**Fix**:
```bash
# Check Codex MCP configuration
codex mcp list

# Should show: byterover-mcp
```

If not configured, user needs to add Byterover MCP to Codex config.

### Issue: Memory Takes Time to Be Searchable

**Cause**: Byterover processes memories asynchronously

**Fix**: Wait 20-30 seconds after storing before retrieving

## Limitations & Workarounds

### Limitation 1: No Exact Versioning

**What this means**: Can't reliably store "plan v1" vs "plan v2"

**Workaround**: Single-pass workflow (one plan, one review, implement)

**OR**: Use different session IDs for iterations:
```
SESSION-20251027-A7F3K2M9-ITERATION1
SESSION-20251027-B8G4N3P0-ITERATION2
```

### Limitation 2: No Tags/Labels

**What this means**: Can't filter by metadata

**Workaround**: Embed all filterable info in content:
```markdown
**[SESSION-X] [TYPE: PLAN] [AGENT: CLAUDE] [STATUS: REVIEW] ...**
```

### Limitation 3: Semantic Search Uncertainty

**What this means**: May retrieve similar but wrong memory

**Workaround**:
- Use highly unique session IDs
- Include retrieval verification in workflow
- Store rich context to improve matching

## Advanced: Extracting Reusable Patterns

After successful collaboration, extract the validated pattern:

```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**VALIDATED PATTERN: Express Rate Limiting with Redis**

Source: Claude-Codex collaboration SESSION-20251027-A7F3K2M9

## Production-Ready Pattern

\`\`\`typescript
// Complete working code...
\`\`\`

## Key Decisions
- Hybrid user/IP identification (avoids NAT issues)
- Redis with memory fallback (handles failures)
- Tiered limits by endpoint type

## Performance
Handles 10K req/sec with <5ms overhead

## Use For
Any Express API needing distributed rate limiting

Validated by: Codex architectural review
Implemented by: Claude Code
Status: Production-ready
`
})
```

Now this pattern is available for future projects!

## Real-World Example

See `references/example-session.md` for a complete walkthrough of implementing rate limiting using this workflow.

## Quick Reference Card

```bash
# 1. Claude creates plan with unique session ID
SESSION-{timestamp}-{random}-{task}

# 2. Claude stores plan in Byterover
mcp__byterover-mcp__byterover-store-knowledge({
  messages: "[SESSION-X] Plan content..."
})

# 3. User runs Codex review
codex exec "Retrieve SESSION-X plan from Byterover and review"

# 4. Claude retrieves feedback
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "SESSION-X Codex review",
  limit: 2
})

# 5. Claude implements & stores summary

# 6. User runs Codex validation
codex exec "Retrieve SESSION-X implementation and validate"

# 7. Extract reusable pattern (optional)
```

## Summary

This skill demonstrates **the power of Byterover as a bridge between AI agents**:

✅ Claude and Codex share context seamlessly
✅ Plans get expert review before implementation
✅ Implementations get validated before deployment
✅ Knowledge persists for future use
✅ Patterns become reusable team assets

The key is working **with** Byterover's strengths (semantic search, persistence) while compensating for limitations (no tags) through unique IDs and rich context.
