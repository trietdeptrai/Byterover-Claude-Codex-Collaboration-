---
name: claude-codex-collaboration
description: Enable collaboration between Claude Code and Codex CLI using Byterover as shared memory. This skill should be used when architectural review or code validation from Codex is desired before or after implementation. Claude creates plans and implementations while Codex provides expert reviews and validation, with all context persisting in Byterover.
allowed-tools:
  - mcp__byterover-mcp__byterover-store-knowledge
  - mcp__byterover-mcp__byterover-retrieve-knowledge
  - Bash
  - Read
  - Write
---

# Claude-Codex Collaboration

Transfer context between Claude Code and Codex CLI using Byterover as shared memory for collaborative development workflows.

## Purpose

Enable seamless collaboration between two AI agents by using Byterover MCP as a persistent shared memory layer. Claude Code creates architectural plans and implementations, while Codex CLI provides expert architectural review and code validation. All knowledge persists in Byterover, allowing both agents to access the same context without manual information transfer.

## When to Use This Skill

Invoke this skill when:

- Architectural review from Codex is desired before implementing a feature
- Code validation from Codex is needed after implementation
- Complex features benefit from multi-agent review before coding
- Building a knowledge base of validated implementation patterns
- Working on projects where quality assurance through peer review is valuable

## Workflow

### Phase 1: Planning & Review

#### Step 1: Create Architectural Plan

When the user requests a feature, create a comprehensive architectural plan that includes:

- Context about the problem being solved
- Proposed technical approach with code examples
- Key architectural decisions and rationale
- Open questions or areas where Codex's expertise would be valuable
- Technologies and libraries being considered

Structure the plan clearly with markdown sections for easy review.

#### Step 2: Store Plan in Byterover

Store the plan using the Byterover MCP tool with rich, searchable content:

```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**ARCHITECTURAL PLAN: [Feature Name]**
Collaboration between Claude Code and Codex CLI
Status: AWAITING_REVIEW

## Problem Statement
[Clear description of what needs to be built and why]

## Proposed Solution

### Technical Approach
[Detailed technical design with code examples]

### Key Decisions
[Important architectural choices and their rationale]

### Technologies
[Libraries, frameworks, and tools being used]

## Questions for Review
1. [Specific question for Codex to address]
2. [Another area where expert feedback is valuable]

## Implementation Plan
[Step-by-step breakdown of how this will be built]

---
Task: [Feature name/description for search retrieval]
Agent: Claude Code
Date: [Current date]
`
})
```

**Key principles:**
- Include rich context for semantic search retrieval
- Use clear section headers for easy parsing
- Make the content self-contained and understandable
- Include specific questions to guide Codex's review

#### Step 3: Instruct User to Invoke Codex

Provide the user with a clear Codex command to run:

```
I've stored the architectural plan in Byterover.

To get Codex's review, run this command:

codex exec "Use the byterover-retrieve-knowledge tool to search for the latest architectural plan about [feature description]. Review the technical approach, identify potential issues, and provide detailed feedback. Store your review in Byterover using byterover-store-knowledge."

Alternatively, use the helper script:
./collaborate.sh codex-review [identifier]
```

#### Step 4: Codex Retrieves and Reviews

The user runs Codex with the provided command. Codex will:

1. Use `byterover-retrieve-knowledge` to find the plan
2. Analyze the architectural approach
3. Identify concerns, risks, and improvement opportunities
4. Store comprehensive feedback in Byterover

Codex's review typically includes:
- Strengths of the proposed approach
- Potential issues or risks identified
- Specific recommendations for improvement
- Answers to the open questions
- Overall verdict (approve, iterate, or reconsider)

### Phase 2: Implementation

#### Step 5: Retrieve Codex's Feedback

When the user returns after Codex's review, retrieve the feedback:

```typescript
mcp__byterover-mcp__byterover-retrieve-knowledge({
  query: "[feature description] Codex review architectural feedback",
  limit: 3
})
```

Use a descriptive query that combines:
- The feature/task being worked on
- Keywords like "Codex review" or "feedback"
- Any identifying terms from the original plan

Byterover uses semantic search, so conceptually similar queries will find related memories.

#### Step 6: Implement with Improvements

Analyze Codex's feedback and implement the feature incorporating:

- Recommended architectural improvements
- Solutions to identified risks
- Answers to open questions
- Best practices suggested by Codex

Create clean, well-tested code that addresses all concerns raised in the review.

#### Step 7: Store Implementation Summary

After implementation, store a summary in Byterover:

```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**IMPLEMENTATION COMPLETE: [Feature Name]**
Collaboration between Claude Code and Codex CLI
Status: READY_FOR_VALIDATION

## What Was Built
[Overview of the implementation]

## Files Created/Modified
- path/to/file1.ts - [Description]
- path/to/file2.ts - [Description]
- path/to/test.ts - [Description]

## Codex Feedback Addressed
✅ [Specific concern from review] - [How it was addressed]
✅ [Another concern] - [Solution implemented]
✅ [Recommendation] - [How it was incorporated]

## Key Implementation Details
[Important technical decisions made during implementation]

## Testing
[Test coverage and approach]

---
Task: [Feature name/description for search retrieval]
Agent: Claude Code
Date: [Current date]
`
})
```

### Phase 3: Validation (Optional)

#### Step 8: Request Codex Validation

Provide the user with a validation command:

```
Implementation complete! For final validation from Codex, run:

codex exec "Use the byterover-retrieve-knowledge tool to search for the completed implementation of [feature description]. Review the actual code files listed and validate the implementation quality. Store validation results in Byterover using byterover-store-knowledge."

Alternatively, use the helper script:
./collaborate.sh codex-validate [identifier]
```

#### Step 9: Codex Validates Implementation

Codex will:
1. Retrieve the implementation summary from Byterover
2. Read the actual code files listed
3. Validate code quality, patterns, and best practices
4. Verify that review feedback was properly addressed
5. Store validation results in Byterover

#### Step 10: Address Validation Feedback (If Needed)

If Codex identifies issues during validation:

1. Retrieve validation feedback from Byterover
2. Address any remaining concerns
3. Update the implementation
4. Store a final summary noting all improvements

### Phase 4: Knowledge Extraction

#### Step 11: Extract Reusable Patterns (Optional)

After successful collaboration, extract validated patterns for future reuse:

```typescript
mcp__byterover-mcp__byterover-store-knowledge({
  messages: `
**VALIDATED PATTERN: [Pattern Name]**
Production-Ready Implementation Pattern
Validated through Claude-Codex Collaboration

## Pattern Overview
[Description of the reusable pattern]

## Implementation Code
\`\`\`typescript
[Complete, working code example]
\`\`\`

## Key Decisions
- [Important architectural decision]
- [Best practice applied]
- [Performance consideration]

## Use Cases
- [When to use this pattern]
- [What problems it solves]

## Lessons Learned
[Important insights from the collaboration]

---
Pattern validated by: Codex architectural review
Implemented by: Claude Code
Date: [Current date]
`
})
```

These patterns become searchable knowledge for future projects.

## Best Practices

### Writing Plans for Review

Create plans that are:
- **Self-contained** - Include all necessary context
- **Specific** - Provide concrete code examples
- **Questionable** - Identify areas where expert input is valuable
- **Structured** - Use clear sections and headers

### Querying Byterover

Construct queries that:
- **Combine multiple terms** - Use feature name + keywords like "plan" or "review"
- **Are descriptive** - Include enough context for semantic matching
- **Are flexible** - Try variations if initial query doesn't return expected results

Examples:
```typescript
// Good queries
query: "rate limiting Express API architectural plan"
query: "Codex review authentication implementation"
query: "validated pattern Redis caching"

// Less effective queries
query: "plan"  // Too generic
query: "auth"  // Too vague
```

### Storing in Byterover

Store memories that are:
- **Rich in context** - Include enough information for semantic search
- **Clearly labeled** - Use descriptive titles and sections
- **Self-documenting** - Readable without external context
- **Searchable** - Include keywords relevant to future retrieval

### Handling Retrieval Issues

If Byterover doesn't return expected results:

1. **Broaden the query** - Use more general terms
2. **Increase the limit** - Try `limit: 5` or `limit: 10`
3. **Wait for processing** - Memories are indexed asynchronously (20-30 seconds)
4. **Try alternative keywords** - Use synonyms or related concepts

### Working with Codex

When instructing the user to invoke Codex:

1. **Provide complete commands** - Include full syntax with MCP tool names
2. **Explain what will happen** - Set expectations about Codex's process
3. **Guide next steps** - Tell user what to do after Codex completes
4. **Use helper script** - Reference `collaborate.sh` when available

## Bundled Resources

### scripts/collaborate.sh

Helper script that simplifies the workflow by providing:

- **Unique identifier generation** - Creates identifiers for tracking collaboration
- **Command templates** - Generates ready-to-run Codex commands
- **Workflow guidance** - Explains next steps at each phase

Usage examples:

```bash
# Generate unique identifier
./collaborate.sh session

# Get Codex review command
./collaborate.sh codex-review [identifier]

# Get Codex validation command
./collaborate.sh codex-validate [identifier]

# Show help
./collaborate.sh help
```

Reference this script when providing Codex commands to users for a better experience.

### references/example-session.md

Complete walkthrough of a realistic collaboration session implementing rate limiting for an Express API. Review this file to see:

- How to structure plans for effective review
- What kind of feedback Codex typically provides
- How to incorporate review feedback into implementation
- Complete flow from planning through validation
- Example of extracting reusable patterns

Load this reference when users need concrete examples of the collaboration workflow.

## Troubleshooting

### Cannot Retrieve Previous Memory

**Symptoms:** Byterover query returns no results or wrong results

**Solutions:**
1. Use more descriptive query terms combining feature name with keywords
2. Increase the `limit` parameter to see more results
3. Wait 30 seconds after storing for indexing to complete
4. Try alternative query terms or broader concepts

### Codex Cannot Access Byterover

**Symptoms:** Codex reports inability to use Byterover tools

**Solutions:**
1. Verify Codex has Byterover MCP configured: `codex mcp list`
2. Explicitly instruct Codex to use MCP tools in the command
3. Check Byterover credentials are configured in Codex

### Semantic Search Returns Unexpected Results

**Symptoms:** Query returns memories from different projects or tasks

**Solutions:**
1. Make stored memories more distinctive with unique identifying information
2. Use very specific query terms
3. Include more context in queries
4. Store richer, more detailed content in Byterover

## Limitations

### No Metadata Tagging

Byterover uses semantic search without metadata tags or labels. Work around this by:
- Embedding identifying information directly in content
- Using consistent formatting and section headers
- Including rich context in every stored memory
- Creating unique, descriptive content that stands out semantically

### Semantic Search Uncertainty

Semantic matching may return similar but unintended memories. Mitigate this by:
- Using highly specific, distinctive content
- Including multiple identifying terms in queries
- Verifying retrieved content matches expectations
- Storing detailed, unique information for each task

### Asynchronous Processing

Memories take 20-30 seconds to become searchable after storage. Handle this by:
- Waiting briefly after storing before attempting retrieval
- Informing users about the processing delay
- Using the time to provide context to users about next steps

## Value Delivered

This skill enables:

- **Higher quality implementations** - Plans reviewed before coding catches issues early
- **Learning from expertise** - Codex's architectural insights improve decision-making
- **Persistent knowledge** - All decisions and patterns stored for future reference
- **Cross-agent collaboration** - Leverage strengths of both Claude and Codex
- **Pattern library building** - Validated implementations become reusable assets

The collaboration workflow consistently produces better outcomes than either agent working alone, with the added benefit of building a searchable knowledge base of validated architectural decisions and implementation patterns.
