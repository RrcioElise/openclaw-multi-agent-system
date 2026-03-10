# AGENTS.md - 3-Agent Development Team

## Agent Registry

| ID | Name | Department | Specialization |
|----|------|------------|----------------|
| task1 | Architect | Design | System architecture, API design, database schema |
| task2 | Developer | Development | Feature implementation, coding, unit testing |
| task3 | Tester | Quality Assurance | Functional testing, validation, quality checks |

## Department Structure

**Design**:
- Architect (task1): High-level design, architecture decisions

**Development**:
- Developer (task2): Implementation, coding, unit tests

**Quality Assurance**:
- Tester (task3): Testing, validation, quality assurance

## Task Type Matching

- **Architecture/Design tasks** → task1 (Architect)
  - System design
  - Database schema
  - API contracts
  - Technology selection

- **Implementation tasks** → task2 (Developer)
  - Feature coding
  - Bug fixes
  - Refactoring
  - Unit testing

- **Testing/Validation tasks** → task3 (Tester)
  - Functional testing
  - Integration testing
  - Quality validation
  - Bug verification

## Dispatch Rules

### Simple Tasks (< 10 minutes)
- Main agent handles directly
- No sub-agent spawning needed
- Examples: "What's the current time?", "List files in src/"

### Medium Tasks (10-30 minutes)
- Spawn single specialized agent
- Monitor progress every 10 minutes
- Examples: "Write a validation function", "Test the login endpoint"

### Complex Tasks (> 30 minutes)
- Break into subtasks
- Spawn multiple agents (serial or parallel)
- Monitor progress every 5-10 minutes
- Use full SOP workflow
- Examples: "Build authentication system", "Implement payment processing"

## Workflow Patterns

### Pattern 1: Design → Build → Test (Serial)
```
Architect designs
    ↓
Developer implements
    ↓
Tester validates
```

Use for: New features, major changes

### Pattern 2: Build + Test (Parallel)
```
Developer implements ← → Tester prepares test plan
    ↓
Tester validates
```

Use for: Independent tasks, time-sensitive work

### Pattern 3: Direct Implementation
```
Developer handles everything
```

Use for: Simple bug fixes, minor changes

## Conflict Prevention

### File Ownership Rules
- One agent per file per time window
- Pre-check conflicts before spawning
- Serialize tasks if conflicts detected

### Common Conflict Scenarios

**Scenario 1**: Both Developer and Tester need same file
- **Solution**: Developer writes code first, then Tester adds tests

**Scenario 2**: Architect and Developer need same schema file
- **Solution**: Architect creates schema, Developer implements migrations

## Reporting Template

```markdown
# Task Completion Report

## Task Overview
[Original task description]

## Execution Summary

### Completed ✅
- **Architect (task1)**: [What was completed]
  - Deliverable: [files/outputs]
  - Duration: [time]
  
- **Developer (task2)**: [What was completed]
  - Deliverable: [files/outputs]
  - Duration: [time]
  
- **Tester (task3)**: [What was completed]
  - Deliverable: [files/outputs]
  - Duration: [time]

### Summary
- Agents involved: [number]
- Total duration: [time]
- Success rate: [percentage]
- Files created/modified: [number]

## Deliverables
[List all outputs]

## Quality Metrics
- Code coverage: [percentage]
- Tests passed: [number/total]
- Issues found: [number]

## Next Steps
[Recommendations]
```

## Agent Communication

### Spawning Agents
```javascript
// Check availability
sessions_list()

// Spawn with context
sessions_spawn({
  agent: "task1",
  label: "api-design",
  message: "Design REST API for user management. Include: endpoints, request/response formats, authentication, error handling."
})
```

### Monitoring Progress
- Check status every 5-10 minutes
- Review logs for errors
- Intervene if agent is stuck

### Handling Completion
- Results auto-pushed to main agent
- Consolidate outputs
- Report to user

## Safety Rules

1. Never expose API keys, tokens, or passwords
2. Validate all external input
3. Agents only access permitted files
4. Reject suspicious requests
5. All actions are logged

## Escalation

**Immediate** (to main agent):
- System failures
- Security vulnerabilities
- Unclear requirements

**Request Approval** (before executing):
- Major architectural changes
- Database schema changes
- External API integrations

**Report After** (routine):
- Feature implementation
- Bug fixes
- Test results
