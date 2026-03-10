# 5-Agent Startup Team

A balanced team for growing startups with product, development, design, testing, and operations.

## Team Composition

| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task1 | Product Manager | Product | Requirements, priorities, roadmap |
| task2 | Developer | Development | Full-stack implementation |
| task3 | Designer | Design | UI/UX, user experience |
| task4 | Tester | Quality Assurance | Testing, validation |
| task5 | DevOps | Operations | Deployment, infrastructure |

## Use Cases

Perfect for:
- Growing startups
- Product-focused teams
- Full-cycle development
- MVP to production

## Workflow

```
User Request
    ↓
Main Agent (Orchestrator)
    ↓
┌─────────┬──────────┬──────────┬─────────┬─────────┐
│ Product │Developer │ Designer │ Tester  │ DevOps  │
│ Manager │          │          │         │         │
└─────────┴──────────┴──────────┴─────────┴─────────┘
    ↓
Consolidated Result
```

## Example Tasks

### Product Feature
```
User: "Add user profile page"
→ Product Manager: Define requirements
→ Designer: Create UI mockups
→ Developer: Implement frontend + backend
→ Tester: Validate functionality
→ DevOps: Deploy to staging
→ 2-4 hours
```

### Bug Fix
```
User: "Fix login issue"
→ Developer: Investigate and fix
→ Tester: Verify fix
→ DevOps: Deploy hotfix
→ 30-60 minutes
```

### Infrastructure Change
```
User: "Set up Redis caching"
→ Product Manager: Confirm requirements
→ Developer: Integrate Redis client
→ DevOps: Deploy Redis, configure
→ Tester: Validate performance
→ 1-2 hours
```

## Setup

### 1. Copy Configuration

```bash
cd examples/5-agent-startup
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
openclaw chat "Build a user dashboard with profile, settings, and activity feed"
```

## Configuration Files

### AGENTS.md
Defines the five agents and their responsibilities.

### gateway-config.yaml
Gateway configuration with agent definitions.

### souls/
Individual personality files for each agent:
- `product-manager.md` - User-focused, prioritization
- `developer.md` - Implementation-focused
- `designer.md` - UX-focused, visual design
- `tester.md` - Quality-focused
- `devops.md` - Infrastructure-focused

## Expected Behavior

**For a typical feature** ("Add user profile page"):

1. **Product Manager** (15 min):
   - Define user stories
   - Prioritize features
   - Acceptance criteria

2. **Designer** (30 min):
   - Create wireframes
   - Design UI components
   - Define interactions

3. **Developer** (60 min):
   - Implement backend API
   - Build frontend UI
   - Integrate with design

4. **Tester** (30 min):
   - Functional testing
   - UI/UX validation
   - Cross-browser testing

5. **DevOps** (20 min):
   - Deploy to staging
   - Configure monitoring
   - Verify deployment

**Total**: ~2.5 hours

## Scaling

### Scale Down (to 3 agents)
- Merge Product Manager + Designer → Architect
- Keep Developer, Tester
- DevOps handled manually

### Scale Up (to 8+ agents)
- Split Developer → Backend + Frontend
- Add Database Specialist
- Add Security Specialist
- See `16-agent-enterprise` example

## Cost Estimate

Based on typical usage:

| Agent | Model | Cost/Hour |
|-------|-------|-----------|
| Product Manager | GPT-4 | ~$0.80 |
| Developer | GPT-4 | ~$1.00 |
| Designer | Claude Sonnet 4 | ~$0.50 |
| Tester | Claude Haiku 3 | ~$0.05 |
| DevOps | Claude Sonnet 4 | ~$0.40 |

**Total**: ~$2.75/hour for active development

## Team Dynamics

### Collaboration Patterns

**Product → Design → Dev**:
- Product defines requirements
- Design creates mockups
- Dev implements

**Dev → Test → DevOps**:
- Dev implements feature
- Test validates quality
- DevOps deploys

**Product ↔ All**:
- Product Manager coordinates with all agents
- Ensures alignment with business goals

## Next Steps

1. Try the example tasks above
2. Customize agent personalities in `souls/`
3. Add project-specific workflows
4. Scale to 8+ agents when ready
