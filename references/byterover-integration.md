# Byterover MCP Integration Guide

## How Byterover Enables Claude-Codex Collaboration

This document explains how Byterover MCP acts as the shared memory layer between Claude Code and Codex CLI.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Byterover Cloud Memory                   │
│  (Persistent, Semantic Search, Conflict Detection)          │
└─────────────────────────────────────────────────────────────┘
                          ▲           ▲
                          │           │
         MCP Tool Calls   │           │   MCP Tool Calls
                          │           │
                ┌─────────┴───┐   ┌───┴─────────┐
                │  Claude Code │   │ Codex CLI   │
                │  (Planning,  │   │ (Review,    │
                │   Implement) │   │  Validate)  │
                └──────────────┘   └─────────────┘
```

## Configuration Verification

### Claude Code

Check if Byterover MCP is available:
```typescript
// Try retrieving knowledge
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "test",
  limit: 1
})
```

If this works, Byterover is configured ✅

### Codex CLI

Check configuration:
```bash
codex mcp list
```

Should show:
```
Name           Command  Args
byterover-mcp  npx      -y mcp-remote https://mcp.byterover.dev/v2/mcp --header Authorization: Bearer [token]
```

Test in Codex:
```bash
codex exec "Use the byterover-retrieve-knowledge tool to search for 'test'"
```

## Data Flow in Collaboration Workflow

### Phase 1: Planning Iteration

**Step 1: Claude creates plan**
```typescript
// Claude Code stores plan
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**COLLABORATION PLAN v1**
Session: collab-20251026-feature-flags
Task: Implement feature flag system

## Context
Need a feature flag system for gradual rollouts...

## Proposed Approach
1. Use database to store flags
2. Cache in Redis for performance
3. Evaluate flags per user/tenant
...
`
})
```

**Result in Byterover**:
- Memory created with semantic embedding
- Searchable by session ID, keywords, concepts
- Tagged: `collaboration:plan:v1:collab-20251026-feature-flags`

---

**Step 2: Codex retrieves and reviews**
```bash
# Codex CLI command
codex exec "Use byterover-retrieve-knowledge to search for 'collaboration plan v1 collab-20251026-feature-flags'. Review the architecture and store feedback using byterover-store-knowledge with tag 'collaboration:review:v1:collab-20251026-feature-flags'"
```

**What Codex does**:
1. Calls `byterover-retrieve-knowledge` → gets Claude's plan
2. Analyzes the plan
3. Calls `byterover-store-knowledge` → saves review

**Result in Byterover**:
- Now contains both plan AND review
- Both searchable and linked by session ID

---

**Step 3: Claude retrieves feedback**
```typescript
// Claude Code retrieves review
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collaboration review v1 collab-20251026-feature-flags",
  limit: 1
})
```

**Claude receives**: Full review from Codex with concerns, recommendations, verdict

**Claude improves plan** and stores v2:
```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**COLLABORATION PLAN v2**
Session: collab-20251026-feature-flags

## Changes from v1
- Addressed Codex concern about database load
- Added flag evaluation caching strategy
- Clarified tenant-level vs user-level flags
...
`
})
```

---

### Phase 2: Implementation

**Claude stores implementation summary**:
```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**IMPLEMENTATION SUMMARY**
Session: collab-20251026-feature-flags
Based on: Plan v3 (validated)

## Key Files
- src/services/FeatureFlagService.ts
- src/models/FeatureFlag.ts
- src/middleware/featureFlag.ts

## Implementation Highlights
...
`
})
```

---

### Phase 3: Validation

**Codex retrieves and validates**:
```bash
codex resume --last "Use byterover-retrieve-knowledge to get the implementation summary for 'collab-20251026-feature-flags'. Review the code files listed. Store validation results."
```

## Memory Tagging Strategy

### Tag Hierarchy

```
collaboration:{phase}:v{N}:{session-id}
   │           │      │        │
   │           │      │        └── Unique session identifier
   │           │      └─────────── Version number (for iterations)
   │           └────────────────── Phase: plan, review, implementation, validation
   └────────────────────────────── Namespace for collaboration memories
```

### Examples

```
collaboration:plan:v1:collab-20251026-feature-flags
collaboration:plan:v2:collab-20251026-feature-flags
collaboration:plan:v3:collab-20251026-feature-flags
collaboration:review:v1:collab-20251026-feature-flags
collaboration:review:v2:collab-20251026-feature-flags
collaboration:review:v3:collab-20251026-feature-flags
collaboration:implementation:collab-20251026-feature-flags
collaboration:validation:collab-20251026-feature-flags
```

### Querying Strategies

**Get all artifacts from a session**:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collab-20251026-feature-flags",
  limit: 20
})
```

**Get only reviews**:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collaboration review collab-20251026-feature-flags",
  limit: 10
})
```

**Get latest plan version**:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collaboration plan v3 collab-20251026-feature-flags",
  limit: 1
})
```

**Find similar past collaborations**:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "feature flag system collaboration implementation",
  limit: 5
})
```

## Semantic Search Power

Byterover uses semantic embeddings, so you can search by concept, not just exact matches:

**Query**: "rate limiting pattern"
**Finds**: Memories about "API throttling", "request limiting", "DDoS prevention"

**Query**: "authentication refresh token"
**Finds**: Memories about "JWT rotation", "session renewal", "token expiry handling"

This makes past collaborations discoverable even if you don't remember exact wording.

## Conflict Detection

If two collaboration sessions arrive at different solutions for the same problem, Byterover detects conflicts:

```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "feature flag storage strategy",
  limit: 3
})
```

**Response may include**:
```
Memory 1 (relevance: 0.89): Use database storage for flags...
Memory 2 (relevance: 0.87): Use configuration files for flags...

⚠️ CONFLICT DETECTED: View resolution at https://byterover.dev/conflicts/abc123
```

**Action**: Present conflict URL to user for human decision

## Best Practices

### 1. Consistent Session IDs

Use descriptive, unique session IDs:
```
✅ collab-20251026-feature-flags
✅ collab-20251026-payment-integration
✅ collab-20251026-auth-refactor

❌ collab-feature
❌ session-1
❌ test
```

### 2. Structured Message Format

Store information in structured markdown format:

```markdown
**[TYPE] v[N]**
Session: [session-id]
[Related info]

## [Section 1]
...

## [Section 2]
...
```

This makes retrieval and parsing easier.

### 3. Include Context

Always include enough context for future retrieval:

```typescript
// ❌ Too vague
mcp__byterover-mcp__byterover-store-knowledge({
  messages: "Use Redis for caching"
})

// ✅ Includes context
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
For feature flag evaluation, use Redis caching with 5-minute TTL:

\`\`\`typescript
const cachedFlag = await redis.get(\`flag:\${flagKey}:\${userId}\`);
if (cachedFlag !== null) return JSON.parse(cachedFlag);

const flag = await db.getFlag(flagKey, userId);
await redis.setex(\`flag:\${flagKey}:\${userId}\`, 300, JSON.stringify(flag));
\`\`\`

This reduces database load from 1000 req/s to 50 req/s while maintaining freshness.
Session: collab-20251026-feature-flags
`
})
```

### 4. Version Tracking

Always track what changed between versions:

```markdown
**COLLABORATION PLAN v2**
Session: collab-xyz

## Changes from v1
- Added Redis caching (addressed performance concern from Codex review v1)
- Changed flag evaluation to per-tenant instead of global (Codex recommendation)
- Added rollout percentage support (user requirement clarification)

[Rest of plan...]
```

### 5. Store Final Patterns

After collaboration completes, extract reusable patterns:

```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
## Feature Flag System - Production Pattern

Complete implementation pattern validated through Claude-Codex collaboration:

\`\`\`typescript
// [Full, reusable code pattern]
\`\`\`

**Key Decisions**:
- Database: PostgreSQL with flag definitions
- Cache: Redis with 5-min TTL
- Evaluation: Per-tenant with percentage rollout support
- API: REST endpoint + middleware for route protection

**Performance**: Handles 10K evaluations/sec with 50ms p95 latency

**Source**: collab-20251026-feature-flags (validated by Codex)
`
})
```

## Troubleshooting

### Issue: Codex can't retrieve from Byterover

**Symptoms**: Codex says "no memories found" or doesn't use MCP tool

**Fix 1**: Explicitly instruct Codex to use MCP tool
```bash
codex exec "Use the byterover-retrieve-knowledge MCP tool (not a bash command) to search for 'collab-xyz'"
```

**Fix 2**: Check Codex MCP config
```bash
codex mcp get byterover-mcp
```

### Issue: Memories not persisting

**Symptoms**: Can't retrieve what was just stored

**Fix**: Wait for processing (can take 15-30 seconds)
```
Memory creation has been queued for processing. Estimated time: 25s
```

**Fix**: Verify storage succeeded before proceeding

### Issue: Retrieving wrong memories

**Symptoms**: Getting unrelated memories in search results

**Fix**: Use more specific queries with session ID
```typescript
// ❌ Too broad
query: "plan"

// ✅ Specific
query: "collaboration plan v2 collab-20251026-feature-flags"
```

## Advanced: Team Collaboration

### Scenario: Team member joins mid-collaboration

**New developer**: "What decisions have been made about feature flags?"

**Query**:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "collab-20251026-feature-flags",
  limit: 20
})
```

**Result**: Full history of plans, reviews, decisions, implementation

### Scenario: Similar task in different project

**Developer**: "We implemented feature flags before, how did we do it?"

**Query**:
```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "feature flag implementation pattern production validated",
  limit: 5
})
```

**Result**: Finds validated patterns from past collaborations, even from different projects

## Summary

Byterover MCP enables Claude-Codex collaboration by:

1. **Persistent Storage**: All plans, reviews, implementations stored permanently
2. **Semantic Search**: Find relevant knowledge by concept, not just keywords
3. **Context Continuity**: Both agents access the same shared memory
4. **Conflict Detection**: Identifies competing approaches for resolution
5. **Team Knowledge**: Collaboration artifacts become team-wide knowledge base
6. **Pattern Reuse**: Validated patterns discoverable for future projects

Without Byterover: Manual copy/paste, fragmented context, lost knowledge
With Byterover: Automated collaboration, persistent context, accumulated wisdom
