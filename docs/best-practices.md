# Best Practices

This guide covers proven strategies for building and operating effective multi-agent systems.

## Team Size and Composition

### Choosing the Right Number of Agents

| Team Size | Use Case | Complexity | Management Overhead |
|-----------|----------|------------|---------------------|
| **1 agent** | Personal assistant, simple automation | Low | Minimal |
| **3-5 agents** | Small projects, startups, focused teams | Medium | Low |
| **6-10 agents** | Medium projects, growing companies | Medium-High | Medium |
| **11-20 agents** | Large projects, enterprises | High | High |
| **20+ agents** | Complex operations, multi-domain | Very High | Very High |

**Recommendation**: Start small (3-5 agents), scale as needed.

### Optimal Team Compositions

**3-Agent Dev Team** (Minimum Viable Team):
```
- Architect: Design and planning
- Developer: Implementation
- Tester: Quality assurance
```

**5-Agent Startup Team** (Balanced):
```
- Product Manager: Requirements and priorities
- Developer: Implementation
- Designer: UI/UX
- Tester: Quality assurance
- DevOps: Deployment and infrastructure
```

**8-Agent Full-Stack Team** (Comprehensive):
```
Command:
- Advisor: Strategic guidance
- Reviewer: Quality gatekeeper

Development:
- Backend Developer
- Frontend Developer
- Database Specialist

Quality:
- Functional Tester
- Automation Tester

Operations:
- DevOps Engineer
```

## Task Decomposition

### Principles

1. **Independence**: Subtasks should be executable independently
2. **Clarity**: Each subtask has clear inputs and outputs
3. **Testability**: Results can be verified objectively
4. **Right-Sizing**: 15-60 minutes per subtask (sweet spot)

### Good Decomposition Example

**Task**: "Build a blog system"

```markdown
✅ Good Breakdown:

1. Design database schema (Architect, 20 min)
   - Input: Requirements
   - Output: schema.sql
   
2. Create API endpoints (Developer, 45 min)
   - Input: schema.sql
   - Output: src/api/posts.ts
   
3. Build frontend UI (Developer, 60 min)
   - Input: API contract
   - Output: src/components/Blog.tsx
   
4. Write tests (Tester, 30 min)
   - Input: API + UI
   - Output: tests/blog.test.ts
```

### Bad Decomposition Example

```markdown
❌ Bad Breakdown:

1. "Do the backend stuff" (too vague)
2. "Make it work" (no clear deliverable)
3. "Fix any bugs" (open-ended)
4. "Deploy everything" (too broad)
```

### Decomposition Strategies

**By Layer**:
```
1. Database layer
2. Business logic layer
3. API layer
4. Frontend layer
5. Testing layer
```

**By Feature**:
```
1. User authentication
2. Post creation
3. Comment system
4. Search functionality
5. Admin dashboard
```

**By Priority**:
```
1. MVP features (must-have)
2. Enhanced features (should-have)
3. Nice-to-have features (could-have)
```

## Parallel vs Serial Execution

### When to Execute in Parallel

✅ **Safe for parallel**:
- Tasks operate on different files
- Tasks in different domains (research + development)
- Independent features
- Read-only operations

**Example**:
```
┌─────────────────┐  ┌─────────────────┐
│ Research API    │  │ Design UI       │  ← Parallel
│ options         │  │ mockups         │
└─────────────────┘  └─────────────────┘
```

### When to Execute Serially

⚠️ **Must be serial**:
- Tasks modify the same files
- Later task depends on earlier output
- Shared state modifications
- Sequential workflow stages

**Example**:
```
Design Schema → Implement API → Write Tests → Deploy
```

### Hybrid Approach

```
Phase 1: Design (Serial)
    ↓
Phase 2: Implementation (Parallel)
┌──────────────┬──────────────┬──────────────┐
│ Backend API  │ Frontend UI  │ Documentation│
└──────────────┴──────────────┴──────────────┘
    ↓
Phase 3: Integration (Serial)
    ↓
Phase 4: Testing (Parallel)
┌──────────────┬──────────────┐
│ Unit Tests   │ E2E Tests    │
└──────────────┴──────────────┘
```

## Error Handling

### Graceful Degradation

```javascript
// Pseudo-code
async function executeTask(task) {
  try {
    return await primaryAgent.execute(task);
  } catch (error) {
    // Fallback to backup agent
    try {
      return await backupAgent.execute(task);
    } catch (backupError) {
      // Fallback to manual mode
      return await requestUserIntervention(task, error);
    }
  }
}
```

### Retry Strategies

**Exponential Backoff**:
```javascript
async function retryWithBackoff(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      
      const delay = Math.pow(2, i) * 1000; // 1s, 2s, 4s
      await sleep(delay);
    }
  }
}
```

**Circuit Breaker**:
```javascript
class CircuitBreaker {
  constructor(threshold = 5, timeout = 60000) {
    this.failureCount = 0;
    this.threshold = threshold;
    this.timeout = timeout;
    this.state = 'CLOSED'; // CLOSED, OPEN, HALF_OPEN
  }
  
  async execute(fn) {
    if (this.state === 'OPEN') {
      throw new Error('Circuit breaker is OPEN');
    }
    
    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
  
  onSuccess() {
    this.failureCount = 0;
    this.state = 'CLOSED';
  }
  
  onFailure() {
    this.failureCount++;
    if (this.failureCount >= this.threshold) {
      this.state = 'OPEN';
      setTimeout(() => {
        this.state = 'HALF_OPEN';
      }, this.timeout);
    }
  }
}
```

### Error Recovery Patterns

**Checkpoint and Resume**:
```markdown
Task: Process 1000 files

Checkpoint 1: Files 1-250 ✅
Checkpoint 2: Files 251-500 ✅
Checkpoint 3: Files 501-750 ❌ (failed)

Recovery:
- Resume from checkpoint 3
- Process files 501-750 again
- Continue to checkpoint 4
```

**Compensating Transactions**:
```markdown
Task: Deploy new version

Steps:
1. Backup database ✅
2. Run migrations ✅
3. Deploy code ❌ (failed)

Compensation:
1. Rollback code deployment
2. Restore database from backup
3. Notify team of failure
```

## Performance Optimization

### Agent Pooling

Pre-spawn idle agents for faster response:

```yaml
# gateway-config.yaml
agent_pool:
  task1:
    min_idle: 1
    max_idle: 3
  task2:
    min_idle: 2
    max_idle: 5
```

**Benefits**:
- Faster task startup (no spawn delay)
- Predictable response times
- Better resource utilization

**Trade-offs**:
- Higher memory usage
- Idle agent costs

### Batch Processing

Group similar tasks for efficiency:

```javascript
// Instead of:
for (const file of files) {
  await agent.process(file); // 100 spawns
}

// Do this:
await agent.processBatch(files); // 1 spawn
```

### Caching

Cache expensive operations:

```javascript
// Cache research results
const cache = new Map();

async function research(topic) {
  if (cache.has(topic)) {
    return cache.get(topic);
  }
  
  const result = await agent.research(topic);
  cache.set(topic, result);
  return result;
}
```

### Resource Limits

Set appropriate limits to prevent resource exhaustion:

```yaml
# Per-agent limits
limits:
  max_execution_time: 30m
  max_memory: 2GB
  max_file_size: 100MB
  max_concurrent_tasks: 5
```

## Security Best Practices

### Principle of Least Privilege

Give agents only the permissions they need:

```yaml
# Developer agent
permissions:
  filesystem:
    read: ["src/**", "tests/**"]
    write: ["src/**", "tests/**"]
  commands:
    allowed: ["npm", "git", "node"]
    denied: ["rm -rf", "sudo", "curl"]
  network:
    allowed_domains: ["github.com", "npmjs.com"]
```

### Input Validation

Always validate user input before passing to agents:

```javascript
function validateTask(task) {
  // Check for command injection
  if (task.includes('$(') || task.includes('`')) {
    throw new Error('Potential command injection detected');
  }
  
  // Check for path traversal
  if (task.includes('../') || task.includes('..\\')) {
    throw new Error('Path traversal attempt detected');
  }
  
  // Check for SQL injection
  if (/DROP|DELETE|TRUNCATE/i.test(task)) {
    throw new Error('Potentially dangerous SQL detected');
  }
  
  return true;
}
```

### Secrets Management

Never hardcode secrets:

```bash
# ❌ Bad
OPENAI_API_KEY=sk-abc123...

# ✅ Good
OPENAI_API_KEY=${OPENAI_API_KEY}  # From environment
```

Use secret management tools:
- **Development**: `.env` files (gitignored)
- **Production**: AWS Secrets Manager, HashiCorp Vault, etc.

### Audit Logging

Log all agent actions:

```json
{
  "timestamp": "2024-03-10T14:23:45Z",
  "agent": "task1",
  "action": "file_write",
  "target": "src/auth.ts",
  "user": "your-username",
  "session": "abc123",
  "success": true
}
```

## Monitoring and Observability

### Key Metrics

**System Health**:
- Gateway uptime
- Agent availability
- Model API latency
- Error rate

**Performance**:
- Task completion time
- Agent utilization
- Queue depth
- Throughput (tasks/hour)

**Quality**:
- Task success rate
- Rework rate
- User satisfaction
- Code quality metrics

### Alerting Rules

```yaml
alerts:
  - name: high_error_rate
    condition: error_rate > 10%
    duration: 5m
    action: notify_admin
    
  - name: agent_unavailable
    condition: agent_status == 'down'
    duration: 1m
    action: restart_agent
    
  - name: queue_backlog
    condition: queue_depth > 50
    duration: 10m
    action: scale_up_agents
```

### Health Check Script

```bash
#!/bin/bash
# scripts/health-check.sh

echo "=== OpenClaw Multi-Agent System Health Check ==="

# Check gateway
if openclaw gateway status | grep -q "running"; then
  echo "✅ Gateway: Running"
else
  echo "❌ Gateway: Down"
fi

# Check agents
for agent in task1 task2 task3; do
  if openclaw agents status $agent | grep -q "available"; then
    echo "✅ Agent $agent: Available"
  else
    echo "⚠️  Agent $agent: Unavailable"
  fi
done

# Check models
openclaw models test | grep -q "success" && \
  echo "✅ Models: Reachable" || \
  echo "❌ Models: Unreachable"

# Check disk space
DISK_USAGE=$(df -h ~/.openclaw | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -lt 80 ]; then
  echo "✅ Disk: ${DISK_USAGE}% used"
else
  echo "⚠️  Disk: ${DISK_USAGE}% used (high)"
fi

# Check memory
MEM_USAGE=$(ps aux | grep openclaw | awk '{sum+=$4} END {print sum}')
echo "📊 Memory: ${MEM_USAGE}% used"

echo "=== Health Check Complete ==="
```

## Cost Optimization

### Model Selection

Choose cost-effective models for each agent:

```yaml
agents:
  # High-stakes decisions: Premium model
  - id: architect
    model: claude-opus-4  # $15/1M tokens
    
  # Routine tasks: Mid-tier model
  - id: developer
    model: gpt-4  # $10/1M tokens
    
  # Simple tasks: Budget model
  - id: tester
    model: claude-haiku-3  # $0.25/1M tokens
```

### Token Optimization

Reduce token usage:

```javascript
// ❌ Wasteful: Include entire codebase
const context = readEntireCodebase();

// ✅ Efficient: Include only relevant files
const context = readRelevantFiles(task);
```

### Caching Strategies

Cache expensive LLM calls:

```javascript
// Cache prompt responses
const promptCache = new LRUCache({ max: 1000 });

async function callLLM(prompt) {
  const cacheKey = hash(prompt);
  
  if (promptCache.has(cacheKey)) {
    return promptCache.get(cacheKey);
  }
  
  const response = await llm.complete(prompt);
  promptCache.set(cacheKey, response);
  return response;
}
```

### Usage Monitoring

Track costs per agent:

```javascript
const costs = {
  task1: { tokens: 1500000, cost: 22.50 },
  task2: { tokens: 3200000, cost: 32.00 },
  task3: { tokens: 800000, cost: 0.20 }
};

console.log(`Total cost: $${Object.values(costs).reduce((sum, c) => sum + c.cost, 0)}`);
```

## Testing Strategies

### Unit Testing Agents

Test individual agent behaviors:

```javascript
describe('Developer Agent', () => {
  it('should implement a function correctly', async () => {
    const task = 'Write a function to add two numbers';
    const result = await developerAgent.execute(task);
    
    expect(result).toContain('function add(a, b)');
    expect(result).toContain('return a + b');
  });
  
  it('should include tests', async () => {
    const task = 'Write a function to add two numbers';
    const result = await developerAgent.execute(task);
    
    expect(result).toContain('test(');
    expect(result).toContain('expect(');
  });
});
```

### Integration Testing

Test agent collaboration:

```javascript
describe('Multi-Agent Workflow', () => {
  it('should complete a full development cycle', async () => {
    // Architect designs
    const design = await architectAgent.execute('Design a REST API');
    expect(design).toContain('endpoints');
    
    // Developer implements
    const code = await developerAgent.execute(`Implement: ${design}`);
    expect(code).toContain('app.get');
    
    // Tester validates
    const tests = await testerAgent.execute(`Test: ${code}`);
    expect(tests).toContain('pass');
  });
});
```

### Load Testing

Test system under load:

```javascript
async function loadTest() {
  const tasks = Array(100).fill('Simple task');
  const start = Date.now();
  
  await Promise.all(
    tasks.map(task => mainAgent.execute(task))
  );
  
  const duration = Date.now() - start;
  console.log(`Completed 100 tasks in ${duration}ms`);
  console.log(`Throughput: ${100 / (duration / 1000)} tasks/sec`);
}
```

## Documentation

### Essential Documentation

1. **README.md**: Project overview and quick start
2. **AGENTS.md**: Agent registry and dispatch rules
3. **SOUL.md**: Agent personalities
4. **TOOLS.md**: Environment and capabilities
5. **CHANGELOG.md**: Version history
6. **CONTRIBUTING.md**: How to contribute

### Code Documentation

```javascript
/**
 * Spawns a sub-agent to execute a task
 * 
 * @param {string} agentId - Agent identifier (e.g., 'task1')
 * @param {string} task - Task description
 * @param {Object} options - Additional options
 * @param {string} options.label - Task label for tracking
 * @param {number} options.timeout - Max execution time in ms
 * @returns {Promise<string>} Session key for tracking
 * 
 * @example
 * const sessionKey = await spawnAgent('task1', 'Design API', {
 *   label: 'api-design',
 *   timeout: 1800000 // 30 minutes
 * });
 */
async function spawnAgent(agentId, task, options = {}) {
  // Implementation
}
```

### Runbooks

Document common procedures:

```markdown
# Runbook: Handling Agent Failures

## Symptoms
- Agent not responding
- Tasks timing out
- Error rate > 10%

## Diagnosis
1. Check agent logs: `openclaw logs <agent-id>`
2. Check gateway status: `openclaw gateway status`
3. Check model API: `openclaw models test`

## Resolution
1. Restart agent: `openclaw agents restart <agent-id>`
2. If persists, restart gateway: `openclaw gateway restart`
3. If still failing, check API keys and network

## Prevention
- Monitor agent health regularly
- Set up alerting for high error rates
- Keep gateway and agents updated
```

---

Next: [Troubleshooting](troubleshooting.md)
