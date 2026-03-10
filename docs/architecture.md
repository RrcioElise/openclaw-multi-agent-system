# Architecture Deep Dive

This document explains the internal architecture of the OpenClaw Multi-Agent System.

## System Overview

The system follows a hierarchical orchestration pattern with a main coordinator agent and specialized worker agents.

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Interface                           │
│                  (CLI, Telegram, Web, API)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                      OpenClaw Gateway                            │
│  - Request routing                                               │
│  - Session management                                            │
│  - Model provider abstraction                                    │
│  - Tool execution sandbox                                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                    Main Agent (Orchestrator)                     │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Intake     │→ │   Planning   │→ │  Execution   │→ Gate   │
│  │              │  │              │  │              │         │
│  │ - Receive    │  │ - Decompose  │  │ - Spawn      │  - Consolidate │
│  │ - Acknowledge│  │ - Assign     │  │ - Monitor    │  - Report │
│  │ - Analyze    │  │ - Check      │  │ - Coordinate │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└────────────────────────────┬────────────────────────────────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
┌─────────────▼──┐  ┌───────▼────────┐  ┌─▼──────────────┐
│  Sub-Agent 1   │  │  Sub-Agent 2   │  │  Sub-Agent N   │
│                │  │                │  │                │
│ - Specialized  │  │ - Specialized  │  │ - Specialized  │
│ - Isolated     │  │ - Isolated     │  │ - Isolated     │
│ - Stateless    │  │ - Stateless    │  │ - Stateless    │
└────────────────┘  └────────────────┘  └────────────────┘
```

## Core Components

### 1. OpenClaw Gateway

The gateway is the runtime environment that manages all agents.

**Responsibilities**:
- HTTP/WebSocket server for external communication
- Agent session lifecycle management
- Model provider API abstraction (OpenAI, Anthropic, etc.)
- Tool execution in sandboxed environment
- Rate limiting and quota management
- Logging and monitoring

**Configuration** (`gateway-config.yaml`):
```yaml
server:
  port: 3000
  host: 0.0.0.0

agents:
  - id: main
    model: claude-sonnet-4
    workspace: ~/.openclaw/workspaces/main
    
  - id: task1
    model: gpt-4
    workspace: ~/.openclaw/workspaces/main
    parent: main

models:
  - provider: openai
    api_key: ${OPENAI_API_KEY}
    
  - provider: anthropic
    api_key: ${ANTHROPIC_API_KEY}
```

### 2. Main Agent (Orchestrator)

The main agent is the entry point for all user requests.

**Responsibilities**:
- Task intake and complexity analysis
- Subtask decomposition and planning
- Agent selection and assignment
- Conflict detection and prevention
- Progress monitoring
- Result consolidation and reporting

**Key Files**:
- **AGENTS.md**: Agent registry and dispatch rules
- **SOUL.md**: Orchestrator personality and decision-making style
- **TOOLS.md**: Environment configuration

**Decision Logic**:
```
User Request
    ↓
Complexity Analysis
    ↓
Simple? → Handle directly
    ↓
Complex? → Decompose
    ↓
For each subtask:
    - Match to agent specialization
    - Check file conflicts
    - Assign owner
    ↓
Spawn sub-agents in parallel/serial
    ↓
Monitor progress (5-10 min intervals)
    ↓
Consolidate results
    ↓
Report to user
```

### 3. Sub-Agents (Workers)

Specialized agents that execute specific tasks.

**Characteristics**:
- **Ephemeral**: Created for a task, terminated after completion
- **Isolated**: No access to main agent's conversation history
- **Specialized**: Focused expertise (dev, test, research, etc.)
- **Stateless**: Results pushed back to main agent automatically

**Lifecycle**:
```
1. Spawn: Main agent calls sessions_spawn with task context
2. Initialize: Load SOUL.md and TOOLS.md
3. Execute: Perform assigned task
4. Report: Return results (auto-pushed to main agent)
5. Terminate: Session ends, resources released
```

## Agent Communication

### Spawn Mechanism

```javascript
// Main agent spawns sub-agent
sessions_spawn({
  agent: "task1",
  label: "design-api-schema",
  message: `Design a REST API schema for user authentication.
  
  Requirements:
  - JWT-based auth
  - User registration and login
  - Password reset flow
  
  Deliverable: OpenAPI 3.0 spec file`
})

// Returns: { sessionKey: "agent:task1:subagent:abc123" }
```

### Result Push

Sub-agent completion automatically triggers a message to the main agent:

```
[Sub-agent task1 completed]

Task: design-api-schema
Status: Success

Results:
- Created: api-spec.yaml
- Endpoints: 5 (register, login, logout, refresh, reset)
- Authentication: JWT with refresh tokens
- Validation: JSON Schema included

Next steps: Ready for implementation
```

### Conflict Prevention

Before spawning, the main agent checks for file conflicts:

```javascript
// Conflict check logic
function canAssignTask(agent, files, timeWindow) {
  for (const file of files) {
    const owner = fileOwnership.get(file, timeWindow);
    if (owner && owner !== agent) {
      return false; // Conflict detected
    }
  }
  return true; // Safe to assign
}

// Example
canAssignTask("task1", ["src/auth.ts"], "2024-03-10T14:00-15:00")
// → false if task2 already owns src/auth.ts in that window
```

## State Management

### Session State

Each agent session maintains:
- **Conversation history**: Messages exchanged with user/main agent
- **Tool call log**: All tool invocations and results
- **File ownership**: Files currently locked by this agent
- **Progress markers**: Checkpoints for long-running tasks

### Shared State

Managed by the gateway:
- **Agent registry**: All available agents and their status
- **File ownership map**: Current file locks across all agents
- **Task queue**: Pending tasks waiting for agent availability
- **Metrics**: Performance data, error rates, resource usage

### Persistence

```
~/.openclaw/
├── workspaces/
│   └── main/
│       ├── AGENTS.md          # Agent definitions
│       ├── SOUL.md            # Main agent personality
│       ├── TOOLS.md           # Environment config
│       └── memory/            # Persistent memory
│           ├── active-context.md
│           └── runbooks/
├── sessions/
│   └── <session-id>/
│       ├── messages.jsonl     # Conversation log
│       ├── tools.jsonl        # Tool execution log
│       └── state.json         # Session state
└── logs/
    ├── gateway.log            # Gateway events
    └── agents/
        ├── main.log
        ├── task1.log
        └── task2.log
```

## Scalability

### Horizontal Scaling

Multiple gateway instances can run behind a load balancer:

```
                    ┌─────────────┐
                    │ Load Balancer│
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼─────┐      ┌────▼─────┐      ┌────▼─────┐
   │ Gateway 1│      │ Gateway 2│      │ Gateway 3│
   └────┬─────┘      └────┬─────┘      └────┬─────┘
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                    ┌──────▼──────┐
                    │ Shared Redis│
                    │  (State)    │
                    └─────────────┘
```

### Vertical Scaling

Agent limits per gateway instance:

| Agents | RAM  | CPU  | Concurrent Tasks |
|--------|------|------|------------------|
| 1-5    | 4GB  | 2    | 5                |
| 6-10   | 8GB  | 4    | 10               |
| 11-20  | 16GB | 8    | 20               |
| 21+    | 32GB | 16   | 40               |

### Performance Optimization

**Agent Pooling**:
```javascript
// Pre-spawn idle agents for faster response
agentPool.maintain({
  task1: 2,  // Keep 2 idle task1 agents ready
  task2: 1,
  task3: 1
});
```

**Batch Processing**:
```javascript
// Group similar tasks for parallel execution
const tasks = [
  { type: "test", file: "auth.test.ts" },
  { type: "test", file: "user.test.ts" },
  { type: "test", file: "api.test.ts" }
];

// Spawn all at once
tasks.forEach(task => 
  sessions_spawn({ agent: "task3", message: task })
);
```

## Security Architecture

### Isolation Layers

1. **Process Isolation**: Each agent runs in a separate process
2. **Filesystem Isolation**: Agents can only access their workspace
3. **Network Isolation**: Outbound requests go through proxy
4. **Credential Isolation**: Each agent has its own .env file

### Access Control

```yaml
# Agent permissions
agents:
  - id: task1
    permissions:
      filesystem:
        read: ["src/**", "docs/**"]
        write: ["src/**"]
      network:
        allowed_domains: ["api.github.com", "npmjs.com"]
      tools:
        allowed: ["read", "write", "exec"]
        denied: ["exec:rm", "exec:sudo"]
```

### Audit Trail

All agent actions are logged:

```json
{
  "timestamp": "2024-03-10T14:23:45Z",
  "agent": "task1",
  "session": "abc123",
  "action": "write",
  "target": "src/auth.ts",
  "size": 2048,
  "hash": "sha256:..."
}
```

## Error Handling

### Failure Modes

1. **Agent Timeout**: Task exceeds time limit
2. **Tool Failure**: File operation or command fails
3. **Model Error**: LLM API returns error
4. **Conflict**: Multiple agents try to access same file

### Recovery Strategies

```javascript
// Retry with exponential backoff
async function executeWithRetry(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await sleep(Math.pow(2, i) * 1000);
    }
  }
}

// Fallback to different agent
if (task1Failed) {
  sessions_spawn({ agent: "task2", message: originalTask });
}

// Graceful degradation
if (allAgentsBusy) {
  return "System at capacity. Task queued for execution.";
}
```

## Monitoring & Observability

### Metrics

- **Agent utilization**: % of time agents are busy
- **Task completion rate**: Successful vs failed tasks
- **Response time**: Time from request to completion
- **Resource usage**: CPU, memory, disk per agent
- **Error rate**: Failures per agent per hour

### Health Checks

```bash
# System health
openclaw health-check

# Output:
# ✓ Gateway: Running (uptime 2d 5h)
# ✓ Agents: 16/16 available
# ✓ Models: 3/3 reachable
# ✓ Disk: 45% used
# ✓ Memory: 8.2GB / 16GB
# ⚠ task3: High error rate (12% last hour)
```

### Debugging

```bash
# View agent logs
openclaw logs task1 --tail 100

# Trace a specific task
openclaw trace <session-id>

# Inspect agent state
openclaw inspect task1
```

## Extension Points

### Custom Tools

Add new capabilities to agents:

```javascript
// tools/custom-api.js
module.exports = {
  name: "custom_api",
  description: "Call internal API",
  parameters: {
    endpoint: "string",
    method: "string",
    body: "object"
  },
  execute: async ({ endpoint, method, body }) => {
    // Implementation
  }
};
```

### Custom Skills

Package reusable workflows:

```bash
skills/
└── my-skill/
    ├── SKILL.md           # Skill documentation
    ├── scripts/
    │   └── execute.sh     # Execution logic
    └── references/
        └── examples.md    # Usage examples
```

### Webhooks

React to agent events:

```yaml
webhooks:
  - event: task.completed
    url: https://api.example.com/webhook
    headers:
      Authorization: Bearer ${WEBHOOK_TOKEN}
```

---

This architecture enables scalable, reliable, and maintainable multi-agent systems. Next: [Agent Design Principles](agent-design.md)
