# OpenClaw Multi-Agent System

A comprehensive multi-agent orchestration system built on OpenClaw. Manage teams of AI agents with intelligent task dispatch, conflict prevention, and standardized workflows.

## Features

- **Intelligent Task Dispatch**: Automatically route tasks to the most suitable agents based on their specializations
- **Conflict Prevention**: Built-in file ownership tracking prevents concurrent write conflicts
- **Standardized Workflows**: SOP-driven execution with intake, planning, execution, and reporting phases
- **Scalable Architecture**: From 3-agent dev teams to 16+ agent enterprises
- **Real-time Monitoring**: Track agent status, task progress, and system health
- **Flexible Configuration**: YAML-based config with persona definitions (SOUL.md) and capability mappings

## Quick Start (5 Minutes)

### Prerequisites

- Node.js 18+ and npm
- OpenClaw installed (`npm install -g openclaw`)
- API keys for your preferred LLM providers

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/openclaw-multi-agent-system.git
cd openclaw-multi-agent-system

# Run setup script
chmod +x scripts/setup.sh
./scripts/setup.sh

# Start with a 3-agent example
cd examples/3-agent-dev-team
openclaw gateway start
```

### Your First Task

```bash
# Send a task to your agent team
openclaw chat "Build a REST API for user authentication"
```

The system will automatically:
1. Analyze the task complexity
2. Break it into subtasks
3. Assign to appropriate agents (architect, developer, tester)
4. Monitor progress and handle conflicts
5. Report consolidated results

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Main Agent (Orchestrator)                │
│  - Task intake & complexity analysis                         │
│  - Subtask planning & agent assignment                       │
│  - Progress monitoring & conflict resolution                 │
│  - Result consolidation & reporting                          │
└────────────────┬────────────────────────────────────────────┘
                 │
        ┌────────┴────────┬────────────────┬──────────────┐
        │                 │                │              │
   ┌────▼─────┐     ┌────▼─────┐    ┌────▼─────┐   ┌───▼──────┐
   │ Dev Team │     │ Research │    │ Testing  │   │ Finance  │
   │          │     │   Team   │    │   Team   │   │   Team   │
   │ - Architect    │ - Analyst│    │ - QA     │   │ - Analyst│
   │ - Developer    │ - Scout  │    │ - Auto   │   │ - Trader │
   │ - Security     │ - Tracker│    │   Test   │   │          │
   └──────────┘     └──────────┘    └──────────┘   └──────────┘
```

## Core Concepts

### Agent Roles

Each agent has:
- **Specialization**: Specific domain expertise (dev, research, testing, etc.)
- **Persona (SOUL.md)**: Personality, communication style, and decision-making approach
- **Capabilities (TOOLS.md)**: Available tools, APIs, and system access
- **Constraints**: File ownership rules, resource limits, security boundaries

### Task Dispatch Flow

1. **Intake**: Main agent receives task, acknowledges within 30 seconds
2. **Planning**: Break into subtasks, assign owners, check for conflicts
3. **Execution**: Spawn sub-agents, monitor progress every 5-10 minutes
4. **Gate**: Consolidate results, report to user with standardized template

### Conflict Prevention

- **File Ownership**: One agent per file per time window
- **Pre-execution Check**: Validate no overlapping file access before dispatch
- **Lock Mechanism**: Agents declare file intentions before writing
- **Rollback Support**: Failed tasks don't corrupt shared state

## Use Cases

### Development Team (3 agents)
- Architect designs system structure
- Developer implements features
- Tester validates functionality

### Startup Team (5 agents)
- Product manager defines requirements
- Developer builds features
- Designer creates UI/UX
- Tester ensures quality
- Operations handles deployment

### Enterprise Team (16 agents)
- Command center (strategy, review, advisory)
- Development zone (architecture, coding, security, stability)
- Planning & product (requirements, design)
- Intelligence (research, competitive analysis, trends)
- Finance (analysis, trading)
- Testing (functional, automation)

## Configuration

### Gateway Config (`config/gateway-config.yaml`)

```yaml
agents:
  - id: task1
    name: architect
    model: claude-sonnet-4
    soul: config/souls/architect.md
    tools: config/tools/dev-tools.md
    
  - id: task2
    name: developer
    model: gpt-4
    soul: config/souls/developer.md
    tools: config/tools/dev-tools.md
```

### Agent Persona (`SOUL.md`)

```markdown
# Architect Agent

## Identity
Senior software architect with 10+ years experience.
INTJ personality, strategic thinker.

## Style
- Concise technical communication
- Focus on scalability and maintainability
- Proactive risk identification

## Responsibilities
- System design and architecture decisions
- Technology stack selection
- Code review and quality standards
```

## Examples

Explore complete working examples:

- **[3-Agent Dev Team](examples/3-agent-dev-team/)**: Minimal setup for small projects
- **[5-Agent Startup](examples/5-agent-startup/)**: Balanced team for growing companies
- **[16-Agent Enterprise](examples/16-agent-enterprise/)**: Full-scale orchestration for complex operations

## Documentation

- [Getting Started Guide](docs/getting-started.md)
- [Architecture Deep Dive](docs/architecture.md)
- [Agent Design Principles](docs/agent-design.md)
- [Dispatch SOP Reference](docs/dispatch-sop.md)
- [Best Practices](docs/best-practices.md)
- [Troubleshooting](docs/troubleshooting.md)

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Fork and clone
git clone https://github.com/yourusername/openclaw-multi-agent-system.git

# Install dependencies
npm install

# Run tests
npm test

# Submit PR
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Community

- **GitHub Issues**: Bug reports and feature requests
- **Discussions**: Questions and community support
- **Discord**: Real-time chat and collaboration (coming soon)

## Acknowledgments

Built on [OpenClaw](https://openclaw.ai) - the open-source AI agent orchestration platform.

Inspired by real-world multi-agent systems managing complex software development, research, and business operations.

---

**Star this repo** if you find it useful! 🌟
