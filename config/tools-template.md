# TOOLS.md Template

This file defines the environment, tools, and capabilities available to your agents.

## Environment Configuration

### Working Directory
```
/path/to/your/project
```

### Timezone
```
UTC+0 (or your timezone)
```

### Proxy Settings
```bash
# If using a proxy
export HTTPS_PROXY=socks5h://127.0.0.1:7897
export HTTP_PROXY=socks5h://127.0.0.1:7897
export NO_PROXY=localhost,127.0.0.1
```

### Environment Variables
```bash
# API Keys (use environment variables, never hardcode)
OPENAI_API_KEY=${OPENAI_API_KEY}
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

# Database
DATABASE_URL=${DATABASE_URL}

# Other services
REDIS_URL=${REDIS_URL}
```

## File System Access

### Read Permissions
```
- src/**
- tests/**
- docs/**
- config/**
- README.md
- package.json (read-only)
```

### Write Permissions
```
- src/**
- tests/**
- docs/**
- logs/**
```

### Restricted Paths
```
- .env (no access)
- .git/** (read-only)
- node_modules/** (no write)
- dist/** (build output only)
```

## Available Commands

### Development Tools
```bash
# Package management
npm install [package]
npm run [script]
npm test

# Version control
git status
git add [files]
git commit -m "[message]"
git push
git pull

# Code execution
node [file]
python [file]
```

### System Commands
```bash
# File operations
ls, cat, grep, find, head, tail

# Text processing
sed, awk, cut, sort, uniq

# Utilities
curl, wget, jq
```

### Prohibited Commands
```bash
# Never allow these
rm -rf /
sudo [anything]
chmod 777
dd if=/dev/zero

# Dangerous operations
DROP DATABASE
TRUNCATE TABLE
DELETE FROM [without WHERE]
```

## External APIs

### Allowed Services

**GitHub API**:
- Access level: Read/Write
- Endpoints: repos, issues, pull requests
- Rate limit: 5000 requests/hour

**npm Registry**:
- Access level: Read-only
- Purpose: Package information lookup

**Documentation Sites**:
- Access level: Read-only
- Purpose: Reference and learning

### Restricted Services

**Production Databases**:
- No direct access
- Use staging/development only

**Payment APIs**:
- Requires explicit approval
- Must be audited

**Email/SMS Services**:
- Requires explicit approval
- Must validate recipients

## Resource Limits

### Execution Limits
```yaml
max_execution_time: 30m      # Maximum time per task
max_memory: 2GB              # Memory limit per agent
max_file_size: 100MB         # Maximum file size to process
max_concurrent_tasks: 5      # Parallel task limit
```

### Rate Limits
```yaml
api_calls_per_hour: 1000     # External API calls
file_operations_per_min: 100 # File read/write operations
llm_tokens_per_hour: 100000  # LLM token usage
```

## Project-Specific Tools

### Custom Scripts
```bash
# Project setup
./scripts/setup.sh

# Database migrations
./scripts/migrate.sh

# Testing
./scripts/test.sh

# Deployment
./scripts/deploy.sh [environment]
```

### Project Structure
```
project/
├── src/              # Source code
├── tests/            # Test files
├── docs/             # Documentation
├── config/           # Configuration files
├── scripts/          # Utility scripts
├── public/           # Static assets
└── dist/             # Build output
```

## Skills and Capabilities

### Installed Skills

**dispatch-sop-v2**:
- Purpose: Task orchestration and conflict prevention
- Usage: Automatically loaded for multi-agent tasks

**[Other skills]**:
- Purpose: [Description]
- Usage: [When to use]

### Available Models

```yaml
models:
  - name: gpt-4
    provider: openai
    use_for: Complex reasoning, architecture
    
  - name: gpt-3.5-turbo
    provider: openai
    use_for: Simple tasks, fast responses
    
  - name: claude-sonnet-4
    provider: anthropic
    use_for: Code generation, analysis
    
  - name: claude-haiku-3
    provider: anthropic
    use_for: Quick tasks, low cost
```

## Security Constraints

### Data Handling
- Never log sensitive information (passwords, tokens, PII)
- Sanitize all user input before processing
- Use parameterized queries for database operations
- Validate file paths to prevent traversal attacks

### Network Security
- All external requests go through proxy (if configured)
- Validate SSL certificates
- Whitelist allowed domains
- No requests to internal IP ranges (unless explicitly allowed)

### Code Execution
- Sandbox all user-provided code
- Timeout long-running processes
- Limit resource consumption
- No eval() or exec() on untrusted input

## Monitoring and Logging

### Log Locations
```
~/.openclaw/logs/gateway.log    # Gateway logs
~/.openclaw/logs/agents/        # Per-agent logs
~/.openclaw/sessions/           # Session history
```

### Metrics Collected
- Task completion time
- Success/failure rate
- Resource usage (CPU, memory)
- API call counts
- Error rates

### Audit Trail
All agent actions are logged:
- File operations (read, write, delete)
- Command executions
- API calls
- Agent spawns and completions

## Troubleshooting

### Common Issues

**Issue**: Command not found
**Solution**: Check if tool is installed, verify PATH

**Issue**: Permission denied
**Solution**: Check file permissions, verify agent has access

**Issue**: API rate limit exceeded
**Solution**: Implement backoff, use caching, spread requests

**Issue**: Out of memory
**Solution**: Reduce concurrent tasks, optimize data structures

### Debug Mode

Enable debug logging:
```bash
export OPENCLAW_LOG_LEVEL=debug
openclaw gateway restart
```

View detailed logs:
```bash
tail -f ~/.openclaw/logs/gateway.log
```

## Customization

### Adding New Tools

1. Install the tool:
```bash
npm install -g [tool-name]
```

2. Update TOOLS.md:
```markdown
### [Tool Name]
- Purpose: [Description]
- Usage: [Command examples]
- Permissions: [Access level]
```

3. Restart gateway:
```bash
openclaw gateway restart
```

### Modifying Permissions

Edit this file and restart the gateway. Changes take effect immediately for new sessions.

### Environment-Specific Configuration

**Development**:
```bash
NODE_ENV=development
DEBUG=true
```

**Staging**:
```bash
NODE_ENV=staging
DEBUG=false
```

**Production**:
```bash
NODE_ENV=production
DEBUG=false
STRICT_MODE=true
```

## Notes

- Keep this file updated as your project evolves
- Document all custom tools and scripts
- Review permissions regularly
- Test changes in development before production
