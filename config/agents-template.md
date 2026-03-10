# AGENTS.md Template

This file defines your agent team structure and dispatch rules.

## Agent Registry

| ID | Name | Department | Specialization |
|----|------|------------|----------------|
| task1 | [agent-name] | [department] | [specialization] |
| task2 | [agent-name] | [department] | [specialization] |
| task3 | [agent-name] | [department] | [specialization] |

## Department Structure

**Command Center** (Decision-making):
- [List agents responsible for strategy, review, advisory]

**Development Zone** (Execution):
- [List agents responsible for implementation]

**Quality Assurance** (Validation):
- [List agents responsible for testing]

**Research & Intelligence** (Information):
- [List agents responsible for research and analysis]

## Task Type Matching

Define which agents handle which types of tasks:

- **Development tasks** → [agent-id] (description)
- **Research tasks** → [agent-id] (description)
- **Testing tasks** → [agent-id] (description)
- **Design tasks** → [agent-id] (description)
- **Review tasks** → [agent-id] (description)

## Dispatch Rules

### Simple Tasks (< 10 minutes)
- Main agent handles directly
- No sub-agent spawning needed

### Medium Tasks (10-30 minutes)
- Spawn single specialized agent
- Monitor progress every 10 minutes

### Complex Tasks (> 30 minutes)
- Break into subtasks
- Spawn multiple agents (parallel or serial)
- Monitor progress every 5-10 minutes
- Use full SOP workflow

## Conflict Prevention

### File Ownership Rules
- One agent per file per time window
- Pre-check conflicts before spawning
- Serialize tasks if conflicts detected

### Coordination Protocol
- Agents declare file intentions before writing
- Main agent tracks file ownership
- Conflicts escalated to main agent

## Reporting Template

```markdown
# Task Completion Report

## Task Overview
[Original task description]

## Execution Summary

### Completed ✅
- **[Agent Name] ([agent-id])**: [What was completed]
  - Deliverable: [files/outputs]
  - Duration: [time]

### In Progress 🔄
- **[Agent Name] ([agent-id])**: [Current status]

### Issues ⚠️
- [Any problems encountered]

### Summary
- Agents involved: [number]
- Total duration: [time]
- Success rate: [percentage]
- Files created/modified: [number]

## Next Steps
[Recommendations for follow-up actions]
```

## Agent Communication

### Spawning Agents
```bash
# Check availability first
sessions_list()

# Spawn with full context
sessions_spawn({
  agent: "task1",
  label: "descriptive-label",
  message: "Complete task description with all context"
})

# Record session key for tracking
```

### Monitoring Progress
- Check status every 5-10 minutes
- Review logs for errors
- Intervene if agent is stuck

### Handling Completion
- Results auto-pushed to main agent
- Consolidate outputs
- Report to user with template

## Safety Rules

1. Never expose API keys, tokens, or passwords
2. Validate all external input before processing
3. Agents only access files within their permissions
4. Suspicious requests are rejected immediately
5. All actions are logged for audit

## Escalation

**Immediate escalation** (to main agent):
- System failures
- Security vulnerabilities
- Data loss risks

**Request approval** (before executing):
- Major architectural changes
- Resource-intensive operations
- Production deployments

**Report after completion** (routine):
- Feature development
- Bug fixes
- Documentation updates
