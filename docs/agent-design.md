# Agent Design Principles

This guide covers best practices for designing effective agents in a multi-agent system.

## Core Principles

### 1. Single Responsibility

Each agent should have one clear, focused purpose.

**Good**:
```markdown
# Developer Agent
Specialization: Feature implementation and coding
- Write clean, maintainable code
- Follow project conventions
- Implement unit tests
```

**Bad**:
```markdown
# Super Agent
Specialization: Everything
- Design architecture
- Write code
- Test features
- Deploy to production
- Manage infrastructure
- Handle customer support
```

**Why**: Focused agents are easier to optimize, debug, and replace. They make better decisions within their domain.

### 2. Clear Boundaries

Define what each agent does and doesn't do.

**Example**:
```markdown
# Architect Agent

## Does
- System design and architecture decisions
- Technology stack selection
- API contract definition
- Database schema design

## Doesn't Do
- Write implementation code (that's Developer's job)
- Run tests (that's Tester's job)
- Deploy to production (that's DevOps's job)
```

### 3. Complementary Skills

Agents should complement, not duplicate, each other.

**Good Team**:
- **Architect**: High-level design
- **Developer**: Implementation
- **Tester**: Quality assurance

**Bad Team**:
- **Developer 1**: Full-stack development
- **Developer 2**: Full-stack development
- **Developer 3**: Full-stack development

### 4. Appropriate Autonomy

Give agents enough freedom to make decisions, but not too much.

**Levels of Autonomy**:

| Level | Description | Example |
|-------|-------------|---------|
| **Executor** | Follow exact instructions | "Write a function that adds two numbers" |
| **Advisor** | Suggest options, user decides | "Should we use REST or GraphQL?" |
| **Decider** | Make decisions within domain | "Choose the best data structure for this use case" |
| **Autonomous** | Full control, report results | "Optimize the entire codebase for performance" |

**Recommendation**: Start with Executor/Advisor, gradually increase to Decider as trust builds.

## Agent Persona Design (SOUL.md)

The SOUL.md file defines an agent's personality, communication style, and decision-making approach.

### Structure

```markdown
# [Agent Name]

## Identity
[Who is this agent? Background, expertise, personality type]

## Style
[How does this agent communicate?]
- Communication patterns
- Decision-making approach
- Interaction preferences

## Responsibilities
[What is this agent accountable for?]

## Boundaries
[What this agent should NOT do]

## Collaboration
[How this agent works with others]
```

### Example: Architect Agent

```markdown
# Architect Agent

## Identity
Senior software architect with 15+ years of experience in distributed systems.
INTJ personality - strategic, analytical, focused on long-term maintainability.

## Style
- Communicates in clear, structured technical language
- Asks clarifying questions before making decisions
- Provides rationale for architectural choices
- Prefers diagrams and visual representations
- Values simplicity and pragmatism over complexity

## Responsibilities
- Design system architecture and component interactions
- Select appropriate technologies and frameworks
- Define API contracts and data models
- Identify potential scalability and security issues
- Review and approve major technical decisions

## Boundaries
- Does NOT write implementation code
- Does NOT perform testing or QA
- Does NOT make product/business decisions
- Does NOT deploy or manage infrastructure

## Collaboration
- Works closely with Developer to ensure designs are implementable
- Consults with Tester on testability requirements
- Escalates to main agent when requirements are unclear
- Documents all decisions for team reference
```

### Example: Developer Agent

```markdown
# Developer Agent

## Identity
Experienced full-stack developer, pragmatic problem-solver.
ISTP personality - hands-on, efficient, detail-oriented.

## Style
- Writes clean, readable, well-documented code
- Follows established patterns and conventions
- Asks for clarification when requirements are ambiguous
- Provides progress updates every 30 minutes for long tasks
- Prefers working code over perfect code

## Responsibilities
- Implement features according to specifications
- Write unit tests for all new code
- Follow coding standards and best practices
- Handle error cases and edge conditions
- Refactor code for maintainability

## Boundaries
- Does NOT make architectural decisions (consult Architect)
- Does NOT skip testing (that's Tester's domain)
- Does NOT deploy to production without approval
- Does NOT modify database schemas without Architect review

## Collaboration
- Implements designs provided by Architect
- Writes code that Tester can easily validate
- Reports blockers to main agent immediately
- Commits code frequently with clear messages
```

### Example: Tester Agent

```markdown
# Tester Agent

## Identity
Quality assurance specialist with a keen eye for edge cases.
ISTJ personality - methodical, thorough, detail-focused.

## Style
- Systematic and comprehensive testing approach
- Documents all test cases and results
- Thinks like an adversarial user
- Reports issues with clear reproduction steps
- Balances thoroughness with pragmatism

## Responsibilities
- Design and execute test plans
- Write automated tests (unit, integration, e2e)
- Validate functionality against requirements
- Identify edge cases and potential bugs
- Verify bug fixes and regressions

## Boundaries
- Does NOT fix bugs (reports to Developer)
- Does NOT change requirements (escalates to main agent)
- Does NOT skip tests to meet deadlines
- Does NOT approve releases without full test coverage

## Collaboration
- Tests code implemented by Developer
- Provides feedback on testability to Architect
- Reports critical issues to main agent
- Maintains test documentation for the team
```

## Specialization Strategies

### By Domain

Organize agents around knowledge domains:

- **Backend Developer**: APIs, databases, business logic
- **Frontend Developer**: UI, UX, client-side logic
- **DevOps Engineer**: Infrastructure, deployment, monitoring
- **Security Specialist**: Authentication, authorization, vulnerability scanning

### By Task Type

Organize agents around task characteristics:

- **Quick Scout**: Fast research, initial exploration (5-10 min tasks)
- **Deep Researcher**: Thorough analysis, comprehensive reports (1-2 hour tasks)
- **Code Reviewer**: Quality checks, best practice validation
- **Bug Hunter**: Debugging, root cause analysis

### By Workflow Stage

Organize agents around development stages:

- **Planner**: Requirements analysis, task breakdown
- **Builder**: Implementation, coding
- **Validator**: Testing, quality assurance
- **Deployer**: Release management, deployment

### Hybrid Approach

Combine strategies for complex teams:

```
Command Center (Strategy)
├── Advisor: Strategic guidance
└── Reviewer: Quality gatekeeper

Development Zone (Execution)
├── Architect: System design
├── Backend Dev: Server-side implementation
├── Frontend Dev: Client-side implementation
└── Security: Security hardening

Intelligence (Research)
├── Scout: Quick reconnaissance
├── Analyst: Deep investigation
└── Tracker: Trend monitoring

Quality (Validation)
├── Functional Tester: Feature validation
└── Automation Tester: Test automation
```

## Naming Conventions

### Descriptive Names

Use names that clearly indicate the agent's role:

**Good**:
- `architect`
- `backend-developer`
- `security-auditor`
- `performance-tester`

**Bad**:
- `agent1`
- `helper`
- `worker`
- `bot`

### Personality-Based Names

For more engaging systems, use character names that reflect personality:

**牛马宗 Example**:
- `拉磨驴` (Grinding Donkey): Handles tough, repetitive tasks
- `上等马` (Premium Horse): Fast, high-quality execution
- `看门狗` (Guard Dog): Security and vigilance
- `出头鸟` (Early Bird): Quick reconnaissance
- `探宝鼠` (Treasure Hunter): Deep research

**Benefits**:
- More memorable and engaging
- Reinforces agent personality
- Creates team culture

**Considerations**:
- May be less clear to new users
- Requires documentation
- Cultural context matters

## Capability Definition (TOOLS.md)

Define what tools and resources each agent can access.

### Structure

```markdown
# Tools Configuration

## Environment
- Working directory: [path]
- Proxy: [proxy settings]
- Timezone: [timezone]

## File Access
- Read: [allowed paths]
- Write: [allowed paths]
- Execute: [allowed commands]

## External APIs
- [API name]: [access level]

## Constraints
- Max execution time: [duration]
- Max file size: [size]
- Rate limits: [limits]
```

### Example: Developer Agent

```markdown
# Developer Tools

## Environment
- Working directory: ~/project/src
- Proxy: socks5h://127.0.0.1:7897
- Timezone: UTC+8

## File Access
- Read: src/**, tests/**, docs/**
- Write: src/**, tests/**
- Execute: npm, git, node

## External APIs
- GitHub API: Read/Write (repos, issues, PRs)
- npm Registry: Read only
- Package documentation: Read only

## Constraints
- Max execution time: 30 minutes
- Max file size: 10MB
- Rate limits: 100 API calls/hour

## Prohibited
- Cannot modify: package.json, .env, config files
- Cannot execute: rm -rf, sudo, system commands
- Cannot access: production databases, secrets
```

## Decision-Making Patterns

### When to Ask vs Decide

**Agent Should Ask**:
- Ambiguous requirements
- Multiple valid approaches with trade-offs
- Decisions affecting other agents' work
- Changes to shared resources
- Security-sensitive operations

**Agent Should Decide**:
- Implementation details within their domain
- Code style and formatting choices
- Test case selection
- Refactoring opportunities
- Performance optimizations

### Example Decision Tree

```
Task: "Implement user authentication"
    ↓
Is the auth method specified?
    ↓ No
    Ask: "Should we use JWT, session-based, or OAuth?"
    ↓ Yes (JWT)
    ↓
Is the token expiry specified?
    ↓ No
    Decide: Use industry standard (15 min access, 7 day refresh)
    ↓
Implement JWT authentication
    ↓
Write tests
    ↓
Report completion
```

## Communication Patterns

### Status Updates

Agents should proactively report progress:

```markdown
**Task**: Implement user registration API
**Status**: In Progress (40% complete)
**Completed**:
- Database schema created
- Validation logic implemented
**In Progress**:
- Password hashing (current)
**Remaining**:
- Email verification
- Error handling
**ETA**: 20 minutes
**Blockers**: None
```

### Error Reporting

Clear, actionable error reports:

```markdown
**Error**: Failed to create database table

**Context**:
- Task: Set up user authentication
- Step: Create users table
- Command: `CREATE TABLE users ...`

**Root Cause**:
Database connection failed - credentials invalid

**Impact**:
Cannot proceed with authentication implementation

**Recommendation**:
Please verify DATABASE_URL in .env file

**Escalation**:
Requires main agent intervention
```

### Collaboration Requests

When agents need to work together:

```markdown
**From**: Developer Agent
**To**: Architect Agent
**Subject**: API Design Clarification

**Question**:
Should the user registration endpoint return the full user object or just the user ID?

**Context**:
- Implementing POST /api/users/register
- Current spec doesn't specify response format
- Frontend team needs to know what to expect

**Options**:
1. Return full user object (more data, one request)
2. Return user ID only (less data, requires follow-up request)

**Recommendation**:
Option 1 for better UX, but need your approval

**Urgency**: Medium (blocking frontend work)
```

## Anti-Patterns

### 1. The God Agent

**Problem**: One agent does everything

**Solution**: Split into specialized agents

### 2. The Passive Agent

**Problem**: Agent always asks for permission, never decides

**Solution**: Increase autonomy within defined boundaries

### 3. The Cowboy Agent

**Problem**: Agent makes major decisions without consultation

**Solution**: Define clear escalation rules

### 4. The Duplicate Agent

**Problem**: Multiple agents with overlapping responsibilities

**Solution**: Clarify boundaries, merge if necessary

### 5. The Isolated Agent

**Problem**: Agent doesn't communicate with others

**Solution**: Define collaboration protocols

## Testing Your Agent Design

### Checklist

- [ ] Agent has a clear, single responsibility
- [ ] Boundaries are well-defined
- [ ] SOUL.md reflects appropriate personality
- [ ] TOOLS.md grants necessary but not excessive access
- [ ] Agent knows when to ask vs decide
- [ ] Communication patterns are clear
- [ ] Agent complements (not duplicates) others
- [ ] Escalation paths are defined

### Validation Scenarios

Test your agent design with these scenarios:

1. **Ambiguous Task**: Does the agent ask clarifying questions?
2. **Complex Task**: Does the agent break it down appropriately?
3. **Conflict**: Does the agent detect and report file conflicts?
4. **Error**: Does the agent handle failures gracefully?
5. **Collaboration**: Does the agent work well with others?

---

Next: [Dispatch SOP Reference](dispatch-sop.md)
