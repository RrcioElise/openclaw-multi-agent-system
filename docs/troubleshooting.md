# Troubleshooting Guide

Common issues and solutions for OpenClaw Multi-Agent Systems.

## Gateway Issues

### Gateway Won't Start

**Symptoms**:
```
Error: Port 3000 already in use
```

**Diagnosis**:
```bash
# Check what's using the port
lsof -ti:3000

# Check gateway status
openclaw gateway status
```

**Solutions**:

1. **Kill existing process**:
```bash
lsof -ti:3000 | xargs kill -9
openclaw gateway start
```

2. **Use different port**:
```bash
openclaw gateway start --port 3001
```

3. **Check for zombie processes**:
```bash
ps aux | grep openclaw
kill -9 <pid>
```

### Gateway Crashes Repeatedly

**Symptoms**:
- Gateway starts then immediately exits
- "Segmentation fault" or "Out of memory" errors

**Diagnosis**:
```bash
# Check logs
tail -f ~/.openclaw/logs/gateway.log

# Check memory usage
free -h

# Check disk space
df -h ~/.openclaw
```

**Solutions**:

1. **Increase memory limit**:
```yaml
# gateway-config.yaml
system:
  max_memory: 4GB  # Increase from default
```

2. **Clear old sessions**:
```bash
rm -rf ~/.openclaw/sessions/*
```

3. **Check for corrupted config**:
```bash
# Validate YAML syntax
yamllint gateway-config.yaml
```

### Gateway Slow to Respond

**Symptoms**:
- Long delays between request and response
- Timeout errors

**Diagnosis**:
```bash
# Check agent load
openclaw agents list

# Check active sessions
openclaw sessions list

# Check system resources
top
```

**Solutions**:

1. **Kill idle sessions**:
```bash
openclaw sessions list | grep idle | awk '{print $1}' | xargs openclaw sessions kill
```

2. **Reduce concurrent agents**:
```yaml
# gateway-config.yaml
limits:
  max_concurrent_agents: 5  # Reduce from 10
```

3. **Optimize model selection**:
```yaml
# Use faster models for simple tasks
agents:
  - id: task1
    model: claude-haiku-3  # Faster than opus
```

## Agent Issues

### Agent Not Responding

**Symptoms**:
- Agent spawned but no output
- Task stuck in "running" state

**Diagnosis**:
```bash
# Check agent status
openclaw agents status task1

# View agent logs
openclaw logs task1 --tail 100

# Check session details
openclaw sessions log <session-id>
```

**Solutions**:

1. **Check agent configuration**:
```bash
# Verify SOUL.md and TOOLS.md exist
ls ~/.openclaw/workspaces/main/SOUL.md
ls ~/.openclaw/workspaces/main/TOOLS.md
```

2. **Restart agent**:
```bash
openclaw agents restart task1
```

3. **Check model API**:
```bash
# Test model connectivity
openclaw models test

# Check API key
echo $OPENAI_API_KEY
```

4. **Kill and respawn**:
```bash
openclaw sessions kill <session-id>
openclaw spawn task1 "retry task"
```

### Agent Produces Incorrect Output

**Symptoms**:
- Agent completes but output is wrong
- Agent misunderstands instructions

**Diagnosis**:
```bash
# Review agent's conversation
openclaw sessions log <session-id>

# Check agent's SOUL.md
cat ~/.openclaw/workspaces/main/SOUL.md
```

**Solutions**:

1. **Improve task description**:
```javascript
// ❌ Vague
"Fix the bug"

// ✅ Specific
"Fix the authentication bug in src/auth.ts where JWT tokens expire immediately. The issue is on line 45 where expiry is set to 0 instead of 3600."
```

2. **Adjust agent persona**:
```markdown
# SOUL.md

## Style
- Always ask for clarification when requirements are ambiguous
- Provide multiple options when trade-offs exist
- Explain reasoning for decisions
```

3. **Use better model**:
```yaml
# Upgrade to more capable model
agents:
  - id: task1
    model: claude-opus-4  # More capable than haiku
```

### Agent Timeout

**Symptoms**:
```
Error: Agent execution timeout after 30 minutes
```

**Diagnosis**:
```bash
# Check what agent was doing
openclaw sessions log <session-id> --tail 50
```

**Solutions**:

1. **Increase timeout**:
```yaml
# gateway-config.yaml
limits:
  max_execution_time: 60m  # Increase from 30m
```

2. **Break task into smaller pieces**:
```javascript
// Instead of:
"Implement entire authentication system"

// Do:
"1. Implement JWT generation"
"2. Implement JWT validation"
"3. Implement refresh token logic"
```

3. **Check for infinite loops**:
```bash
# Look for repeated patterns in logs
openclaw logs task1 | grep -A 5 "retry"
```

## Model API Issues

### API Key Invalid

**Symptoms**:
```
Error: Invalid API key
Error: 401 Unauthorized
```

**Diagnosis**:
```bash
# Check if key is set
echo $OPENAI_API_KEY

# Test API directly
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

**Solutions**:

1. **Verify API key**:
```bash
# Check .env file
cat .env | grep API_KEY

# Reload environment
source .env
```

2. **Update API key**:
```bash
# Edit .env
nano .env

# Restart gateway
openclaw gateway restart
```

### Rate Limit Exceeded

**Symptoms**:
```
Error: Rate limit exceeded
Error: 429 Too Many Requests
```

**Diagnosis**:
```bash
# Check request rate
openclaw metrics | grep requests_per_minute
```

**Solutions**:

1. **Implement rate limiting**:
```yaml
# gateway-config.yaml
rate_limits:
  openai:
    requests_per_minute: 50
    tokens_per_minute: 90000
```

2. **Add retry with backoff**:
```javascript
async function callWithRetry(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (error.status === 429 && i < maxRetries - 1) {
        const delay = Math.pow(2, i) * 1000;
        await sleep(delay);
      } else {
        throw error;
      }
    }
  }
}
```

3. **Use multiple API keys**:
```yaml
# gateway-config.yaml
models:
  - provider: openai
    api_keys:
      - ${OPENAI_API_KEY_1}
      - ${OPENAI_API_KEY_2}
    strategy: round_robin
```

### Model Unavailable

**Symptoms**:
```
Error: Model not found
Error: Service unavailable
```

**Diagnosis**:
```bash
# Test model availability
openclaw models test

# Check provider status
curl https://status.openai.com/api/v2/status.json
```

**Solutions**:

1. **Use fallback model**:
```yaml
# gateway-config.yaml
agents:
  - id: task1
    model: gpt-4
    fallback_model: gpt-3.5-turbo
```

2. **Switch provider**:
```yaml
# Use Anthropic instead of OpenAI
agents:
  - id: task1
    model: claude-sonnet-4
```

## File Conflict Issues

### Concurrent Write Conflict

**Symptoms**:
```
Error: File locked by another agent
Warning: Potential write conflict detected
```

**Diagnosis**:
```bash
# Check file ownership
openclaw files ownership src/auth.ts

# Check active sessions
openclaw sessions list | grep src/auth.ts
```

**Solutions**:

1. **Serialize tasks**:
```javascript
// Execute sequentially instead of parallel
await agent1.execute(task1);
await agent2.execute(task2);  // Wait for agent1
```

2. **Split files**:
```javascript
// Instead of both agents modifying auth.ts
// Agent 1: auth-jwt.ts
// Agent 2: auth-session.ts
```

3. **Implement file locking**:
```javascript
async function withFileLock(file, fn) {
  await acquireLock(file);
  try {
    return await fn();
  } finally {
    await releaseLock(file);
  }
}
```

### Lost Changes

**Symptoms**:
- Agent's changes overwritten by another agent
- File content doesn't match expected output

**Diagnosis**:
```bash
# Check file history
git log --oneline src/auth.ts

# Check who modified file
openclaw audit src/auth.ts
```

**Solutions**:

1. **Use version control**:
```bash
# Commit before each agent task
git commit -am "Before task1"

# Rollback if needed
git reset --hard HEAD~1
```

2. **Implement conflict detection**:
```javascript
function detectConflicts(tasks) {
  const fileMap = new Map();
  
  for (const task of tasks) {
    for (const file of task.files) {
      if (fileMap.has(file)) {
        console.warn(`Conflict: ${file} used by multiple tasks`);
      }
      fileMap.set(file, task.agent);
    }
  }
}
```

## Network Issues

### Proxy Connection Failed

**Symptoms**:
```
Error: ECONNREFUSED 127.0.0.1:7897
Error: Proxy connection timeout
```

**Diagnosis**:
```bash
# Check if proxy is running
curl -x socks5h://127.0.0.1:7897 https://api.openai.com

# Check proxy process
ps aux | grep proxy
```

**Solutions**:

1. **Start proxy**:
```bash
# Example for SSH tunnel
ssh -D 7897 -N user@proxy-server
```

2. **Update proxy settings**:
```bash
# TOOLS.md
export HTTPS_PROXY=socks5h://127.0.0.1:7897
export HTTP_PROXY=socks5h://127.0.0.1:7897
```

3. **Bypass proxy for local requests**:
```bash
export NO_PROXY=localhost,127.0.0.1
```

### DNS Resolution Failed

**Symptoms**:
```
Error: getaddrinfo ENOTFOUND api.openai.com
```

**Diagnosis**:
```bash
# Test DNS
nslookup api.openai.com

# Check /etc/resolv.conf
cat /etc/resolv.conf
```

**Solutions**:

1. **Use different DNS**:
```bash
# Add to /etc/resolv.conf
nameserver 8.8.8.8
nameserver 1.1.1.1
```

2. **Use IP address**:
```yaml
# gateway-config.yaml (not recommended)
models:
  - provider: openai
    endpoint: https://104.18.7.192/v1
```

## Performance Issues

### High Memory Usage

**Symptoms**:
- System becomes slow
- "Out of memory" errors
- Gateway crashes

**Diagnosis**:
```bash
# Check memory usage
free -h

# Check per-agent memory
ps aux | grep openclaw | awk '{print $4, $11}'

# Check for memory leaks
openclaw metrics memory
```

**Solutions**:

1. **Limit concurrent agents**:
```yaml
# gateway-config.yaml
limits:
  max_concurrent_agents: 3  # Reduce
```

2. **Clear session history**:
```bash
# Clear old sessions
find ~/.openclaw/sessions -mtime +7 -delete
```

3. **Reduce context size**:
```javascript
// Don't include entire codebase
const context = getRelevantFiles(task);  // Only what's needed
```

### High CPU Usage

**Symptoms**:
- System fans running loud
- Slow response times
- High load average

**Diagnosis**:
```bash
# Check CPU usage
top

# Check per-agent CPU
ps aux | grep openclaw | awk '{print $3, $11}'
```

**Solutions**:

1. **Limit agent concurrency**:
```yaml
limits:
  max_concurrent_agents: 2
```

2. **Use lighter models**:
```yaml
agents:
  - id: task1
    model: claude-haiku-3  # Lighter than opus
```

3. **Optimize task scheduling**:
```javascript
// Spread tasks over time
for (const task of tasks) {
  await agent.execute(task);
  await sleep(5000);  // 5 second pause
}
```

## Debugging Techniques

### Enable Debug Logging

```bash
# Set debug level
export OPENCLAW_LOG_LEVEL=debug

# Restart gateway
openclaw gateway restart

# View detailed logs
tail -f ~/.openclaw/logs/gateway.log
```

### Trace a Specific Task

```bash
# Start tracing
openclaw trace start

# Execute task
openclaw chat "test task"

# View trace
openclaw trace show

# Stop tracing
openclaw trace stop
```

### Inspect Agent State

```bash
# View agent configuration
openclaw inspect task1

# View active sessions
openclaw sessions list --agent task1

# View conversation history
openclaw sessions log <session-id>
```

### Test in Isolation

```bash
# Test single agent
openclaw spawn task1 "simple test task"

# Test without other agents
openclaw gateway start --agents task1

# Test with mock responses
openclaw test --mock-llm
```

## Recovery Procedures

### Complete System Reset

```bash
#!/bin/bash
# Full system reset (use with caution)

echo "Stopping gateway..."
openclaw gateway stop

echo "Killing all agent processes..."
pkill -f openclaw

echo "Clearing sessions..."
rm -rf ~/.openclaw/sessions/*

echo "Clearing logs..."
rm -rf ~/.openclaw/logs/*

echo "Restarting gateway..."
openclaw gateway start

echo "System reset complete"
```

### Restore from Backup

```bash
#!/bin/bash
# Restore configuration from backup

BACKUP_DIR=~/.openclaw/backups/$(date +%Y%m%d)

echo "Restoring from $BACKUP_DIR..."

cp $BACKUP_DIR/gateway-config.yaml ~/.openclaw/
cp $BACKUP_DIR/AGENTS.md ~/.openclaw/workspaces/main/
cp $BACKUP_DIR/SOUL.md ~/.openclaw/workspaces/main/
cp $BACKUP_DIR/TOOLS.md ~/.openclaw/workspaces/main/

echo "Restore complete. Restart gateway."
```

### Emergency Stop

```bash
#!/bin/bash
# Emergency stop all agents

echo "EMERGENCY STOP INITIATED"

# Stop gateway
openclaw gateway stop

# Kill all sessions
openclaw sessions list | awk '{print $1}' | xargs openclaw sessions kill

# Kill all processes
pkill -9 -f openclaw

echo "All agents stopped"
```

## Getting Help

### Collect Diagnostic Information

```bash
#!/bin/bash
# Collect info for bug reports

echo "=== OpenClaw Diagnostic Report ===" > diagnostic.txt
echo "" >> diagnostic.txt

echo "System Info:" >> diagnostic.txt
uname -a >> diagnostic.txt
echo "" >> diagnostic.txt

echo "OpenClaw Version:" >> diagnostic.txt
openclaw --version >> diagnostic.txt
echo "" >> diagnostic.txt

echo "Gateway Status:" >> diagnostic.txt
openclaw gateway status >> diagnostic.txt
echo "" >> diagnostic.txt

echo "Agent Status:" >> diagnostic.txt
openclaw agents list >> diagnostic.txt
echo "" >> diagnostic.txt

echo "Recent Errors:" >> diagnostic.txt
tail -100 ~/.openclaw/logs/gateway.log | grep ERROR >> diagnostic.txt
echo "" >> diagnostic.txt

echo "Active Sessions:" >> diagnostic.txt
openclaw sessions list >> diagnostic.txt

echo "Diagnostic report saved to diagnostic.txt"
```

### Where to Get Help

1. **Documentation**: Check `docs/` directory
2. **GitHub Issues**: Report bugs and request features
3. **Discord**: Real-time community support
4. **Stack Overflow**: Tag questions with `openclaw`

### Reporting Bugs

Include:
- OpenClaw version
- Operating system
- Gateway configuration (sanitized)
- Error messages and logs
- Steps to reproduce
- Expected vs actual behavior

---

**Still stuck?** Open an issue on GitHub with your diagnostic report.
