# OpenClaw Multi-Agent System

A comprehensive multi-agent orchestration system for OpenClaw. Deploy teams of AI agents with intelligent task dispatch, conflict prevention, and standardized workflows.

## When to Use

Use this skill when you need to:
- Orchestrate multiple AI agents working on complex projects
- Implement team-based task distribution with role specialization
- Prevent concurrent file access conflicts in multi-agent environments
- Standardize agent workflows with SOP-driven execution
- Scale from small dev teams (3 agents) to enterprise operations (16+ agents)
- Monitor and coordinate parallel agent tasks with progress tracking

NOT for:
- Single-agent tasks (use regular OpenClaw agents)
- Simple sequential workflows (overkill for basic automation)
- Real-time collaborative editing (designed for task-based dispatch)

## Prerequisites

- OpenClaw installed (`npm install -g openclaw`)
- Node.js 18+
- API keys for LLM providers (OpenAI, Anthropic, etc.)
- Basic understanding of YAML configuration

## Quick Start

### 1. Install the Skill

```bash
clawhub install openclaw-multi-agent-system
cd ~/.openclaw/skills/openclaw-multi-agent-system
```

### 2. Choose Your Team Size

```bash
# Small dev team (3 agents)
cp -r examples/3-agent-dev-team/* ~/.openclaw/workspaces/my-project/

# Startup team (5 agents)
cp -r examples/5-agent-startup/* ~/.openclaw/workspaces/my-project/

# Enterprise team (16 agents)
cp -r examples/16-agent-enterprise/* ~/.openclaw/workspaces/my-project/
```

### 3. Configure Your Agents

Edit `config/gateway-config.yaml`:

```yaml
agents:
  - id: task1
    name: architect
    model: claude-sonnet-4
    soul: config/souls/architect.md
    tools: config/tools/dev-tools.md
```

### 4. Start the Gateway

```bash
cd ~/.openclaw/workspaces/my-project
openclaw gateway start
```

### 5. Dispatch Your First Task

```bash
openclaw chat "Build a REST API for user authentication with JWT tokens"
```

The main agent will:
1. Analyze task complexity
2. Break into subtasks (design, implement, test)
3. Assign to specialized agents
4. Monitor progress and prevent conflicts
5. Report consolidated results

## Core Components

### 1. Main Agent (Orchestrator)

The main agent coordinates all operations:
- Receives tasks from users
- Performs complexity analysis
- Creates execution plans
- Spawns sub-agents via `sessions_spawn`
- Monitors progress and handles conflicts
- Consolidates and reports results

### 2. Specialized Sub-Agents

Each sub-agent has:
- **SOUL.md**: Persona, communication style, decision-making approach
- **TOOLS.md**: Available tools, APIs, system access
- **AGENTS.md**: Role definition, specialization, department

Example roles:
- Development: Architect, Developer, Security, Stability
- Research: Analyst, Scout, Trend Tracker
- Testing: QA Engineer, Automation Tester
- Finance: Analyst, Trader
- Product: Manager, Designer

### 3. Dispatch SOP (Standard Operating Procedure)

The `dispatch-sop-v2` skill provides:
- **Intake Phase**: 30-second acknowledgment, complexity assessment
- **Planning Phase**: Task breakdown, agent assignment, conflict check
- **Execution Phase**: Parallel dispatch, progress monitoring (5-10 min intervals)
- **Gate Phase**: Result consolidation, standardized reporting

### 4. Conflict Prevention

Built-in mechanisms:
- **File Ownership**: One agent per file per time window
- **Pre-execution Check**: Validate no overlapping access
- **Lock Declaration**: Agents declare file intentions before writing
- **Rollback Support**: Failed tasks don't corrupt shared state

## Configuration Reference

### Gateway Config (`config/gateway-config.yaml`)

```yaml
workspace: /path/to/workspace
agents:
  - id: task1
    name: architect
    model: claude-sonnet-4
    soul: config/souls/architect.md
    tools: config/tools/dev-tools.md
    capabilities:
      - system-design
      - code-review
      - architecture-decisions
```

### Agent Persona (`SOUL.md`)

```markdown
# Architect Agent

## Identity
Senior software architect, INTJ, strategic thinker.

## Style
- Concise technical communication
- Focus on scalability and maintainability
- Proactive risk identification

## Responsibilities
- System design and architecture decisions
- Technology stack selection
- Code review and quality standards
```

### Agent Capabilities (`TOOLS.md`)

```markdown
# Tools Available

- read/write: File system access
- exec: Shell command execution
- web_fetch: Documentation lookup
- Project paths: /path/to/project
```

### Agent Registry (`AGENTS.md`)

```markdown
| ID | Name | Department | Specialization |
|----|------|------------|----------------|
| task1 | Architect | Development | System design |
| task2 | Developer | Development | Feature implementation |
| task3 | Tester | Quality | Functional testing |
```

## Usage Examples

### Example 1: Feature Development

```bash
openclaw chat "Implement user authentication with OAuth2 and JWT"
```

Main agent will:
1. Assign architect to design auth flow
2. Assign developer to implement endpoints
3. Assign security agent to review code
4. Assign tester to validate functionality
5. Report consolidated results with code, tests, and security review

### Example 2: Research Task

```bash
openclaw chat "Research best practices for microservices deployment on Kubernetes"
```

Main agent will:
1. Assign scout to find relevant documentation
2. Assign analyst to compare approaches
3. Assign trend tracker to identify industry standards
4. Consolidate findings into actionable recommendations

### Example 3: Bug Fix

```bash
openclaw chat "Fix memory leak in user session management"
```

Main agent will:
1. Assign developer to investigate and fix
2. Assign tester to verify fix
3. Assign security to check for vulnerabilities
4. Report fix details and test results

## Advanced Features

### Custom Agent Roles

Create new agent types by adding:

1. `config/souls/custom-agent.md` (persona)
2. `config/tools/custom-tools.md` (capabilities)
3. Entry in `AGENTS.md` (registry)
4. Entry in `config/gateway-config.yaml` (configuration)

### Progress Monitoring

Main agent checks sub-agent status every 5-10 minutes:

```bash
# Manual status check
openclaw sessions list
```

### Task Recovery

If gateway restarts, use `task-recovery` skill:

```bash
openclaw chat "Check for interrupted tasks and resume"
```

### Parallel vs Sequential Dispatch

Main agent automatically decides:
- **Parallel**: Independent tasks, different domains
- **Sequential**: Dependent tasks, requires previous output

## Troubleshooting

### Issue: Agents Not Spawning

**Cause**: Gateway not running or config error

**Solution**:
```bash
openclaw gateway status
openclaw gateway restart
# Check logs
tail -f ~/.openclaw/logs/gateway.log
```

### Issue: File Conflicts

**Cause**: Multiple agents writing to same file

**Solution**: Main agent should enforce file ownership rules. Check `AGENTS.md` for ownership tracking.

### Issue: Slow Response

**Cause**: Too many parallel agents or API rate limits

**Solution**: Reduce concurrent agents in config or add delays between spawns.

### Issue: Agent Not Following Instructions

**Cause**: Unclear SOUL.md or missing context

**Solution**: Refine agent persona and ensure all context is passed during spawn.

## Best Practices

1. **Start Small**: Begin with 3-agent team, scale as needed
2. **Clear Personas**: Define distinct roles and communication styles
3. **Explicit Ownership**: Assign file ownership before execution
4. **Regular Monitoring**: Check progress every 5-10 minutes
5. **Standardized Reporting**: Use consistent templates for results
6. **Conflict Prevention**: Pre-check file access before dispatch
7. **Context Passing**: Include all necessary context when spawning agents
8. **Error Handling**: Implement rollback for failed tasks

## Integration

### With Other Skills

- **feishu-tasks**: Task tracking and management
- **github**: Code review and PR automation
- **task-recovery**: Resume interrupted work after restarts
- **healthcheck**: Monitor system health and security

### With External Tools

- CI/CD pipelines (GitHub Actions, GitLab CI)
- Project management (Jira, Linear, Notion)
- Communication (Slack, Discord, Telegram)
- Monitoring (Prometheus, Grafana)

## Performance

- **Startup Time**: 2-5 seconds per agent
- **Task Dispatch**: < 1 second overhead
- **Progress Check**: 100-200ms per agent
- **Conflict Detection**: < 50ms per file check
- **Recommended Max Agents**: 16 concurrent (hardware dependent)

## Security

- Agents run in isolated contexts
- No credential sharing between agents
- File access controlled by ownership rules
- External content (URLs, pastes) treated as untrusted
- Sensitive data (tokens, keys) never logged

## Resources

- [GitHub Repository](https://github.com/RrcioElise/openclaw-multi-agent-system)
- [Documentation](https://github.com/RrcioElise/openclaw-multi-agent-system/tree/main/docs)
- [Examples](https://github.com/RrcioElise/openclaw-multi-agent-system/tree/main/examples)
- [Contributing Guide](https://github.com/RrcioElise/openclaw-multi-agent-system/blob/main/CONTRIBUTING.md)

## License

MIT License - see LICENSE file for details.

## Support

- GitHub Issues: Bug reports and feature requests
- Discussions: Questions and community support
- ClawHub: Skill updates and announcements
