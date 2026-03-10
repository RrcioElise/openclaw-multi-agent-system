# 3-Agent Development Team

A minimal but complete development team with architect, developer, and tester.

## Team Composition

| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task1 | Architect | Design | System architecture, API design, database schema |
| task2 | Developer | Implementation | Feature coding, bug fixes, refactoring |
| task3 | Tester | Quality Assurance | Testing, validation, quality checks |

## Use Cases

Perfect for:
- Small to medium projects
- Startups and MVPs
- Focused development teams
- Learning multi-agent systems

## Workflow

```
User Request
    ↓
Main Agent (Orchestrator)
    ↓
┌───────────┬────────────┬───────────┐
│ Architect │ Developer  │  Tester   │
│ (Design)  │ (Build)    │ (Verify)  │
└───────────┴────────────┴───────────┘
    ↓
Consolidated Result
```

## Example Tasks

### Simple Task (Single Agent)
```
User: "Write a function to validate email addresses"
→ Developer handles directly
→ 5-10 minutes
```

### Medium Task (Two Agents)
```
User: "Create a REST API endpoint for user registration"
→ Developer implements
→ Tester validates
→ 20-30 minutes
```

### Complex Task (All Three Agents)
```
User: "Build a complete authentication system"
→ Architect designs (schema, API contracts, security)
→ Developer implements (code, tests)
→ Tester validates (functional, security, edge cases)
→ 1-2 hours
```

## Setup

### 1. Copy Configuration

```bash
cd examples/3-agent-dev-team
cp .env.example .env
```

### 2. Edit .env

```bash
# Add your API keys
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

### 3. Start Gateway

```bash
openclaw gateway start --config gateway-config.yaml
```

### 4. Test the Team

```bash
openclaw chat "Design and implement a simple TODO API"
```

## Configuration Files

### AGENTS.md
Defines the three agents and their responsibilities.

### gateway-config.yaml
Gateway configuration with agent definitions.

### souls/
Individual personality files for each agent:
- `architect.md` - Strategic, design-focused
- `developer.md` - Pragmatic, implementation-focused
- `tester.md` - Thorough, quality-focused

## Expected Behavior

**For a typical task** ("Build user authentication"):

1. **Architect** (15-20 min):
   - Designs database schema
   - Defines API contracts
   - Documents security considerations

2. **Developer** (30-45 min):
   - Implements authentication logic
   - Creates API endpoints
   - Writes unit tests

3. **Tester** (20-30 min):
   - Validates functionality
   - Tests edge cases
   - Verifies security

**Total**: ~1-1.5 hours

## Scaling Up

When you outgrow this team:
- Add frontend developer for UI work
- Add DevOps for deployment
- Add product manager for requirements
- See `5-agent-startup` example

## Troubleshooting

**Issue**: Agents conflict on same file
**Solution**: Tasks are automatically serialized by dispatch SOP

**Issue**: One agent is slow
**Solution**: Check model selection, consider faster model for simple tasks

**Issue**: Quality issues
**Solution**: Enhance Tester's SOUL.md with stricter validation rules

## Cost Estimate

Based on typical usage:

| Agent | Model | Cost/Hour |
|-------|-------|-----------|
| Architect | Claude Sonnet 4 | ~$0.50 |
| Developer | GPT-4 | ~$1.00 |
| Tester | Claude Haiku 3 | ~$0.05 |

**Total**: ~$1.55/hour for active development

## Next Steps

1. Try the example tasks above
2. Customize agent personalities in `souls/`
3. Add project-specific tools in `TOOLS.md`
4. Scale to 5-agent team when ready
