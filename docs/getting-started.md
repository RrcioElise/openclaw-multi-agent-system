# Getting Started with OpenClaw Multi-Agent System

This guide will help you set up and run your first multi-agent system in under 10 minutes.

## Prerequisites

### System Requirements

- **Operating System**: macOS, Linux, or Windows (WSL2)
- **Node.js**: Version 18.0 or higher
- **Memory**: Minimum 4GB RAM (8GB+ recommended for 5+ agents)
- **Disk Space**: 500MB for installation and logs

### Required Software

```bash
# Check Node.js version
node --version  # Should be v18.0.0 or higher

# Install OpenClaw globally
npm install -g openclaw

# Verify installation
openclaw --version
```

### API Keys

You'll need API keys for at least one LLM provider:

- **OpenAI**: GPT-4, GPT-3.5-turbo
- **Anthropic**: Claude 3 (Opus, Sonnet, Haiku)
- **Google**: Gemini Pro
- **Local**: Ollama (no API key needed)

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/openclaw-multi-agent-system.git
cd openclaw-multi-agent-system
```

### Step 2: Run Setup Script

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

The setup script will:
- Check system dependencies
- Create configuration directories
- Set up environment variables
- Install required npm packages
- Validate your API keys

### Step 3: Configure Environment

Create a `.env` file in your chosen example directory:

```bash
cd examples/3-agent-dev-team
cp .env.example .env
```

Edit `.env` with your API keys:

```bash
# OpenAI
OPENAI_API_KEY=sk-...

# Anthropic
ANTHROPIC_API_KEY=sk-ant-...

# Optional: Proxy settings
HTTPS_PROXY=http://127.0.0.1:7890
```

## Your First Agent

Let's create a simple single-agent setup to understand the basics.

### Step 1: Create Agent Directory

```bash
mkdir -p ~/my-first-agent
cd ~/my-first-agent
```

### Step 2: Create Configuration Files

**AGENTS.md** - Define your agent:

```markdown
# My First Agent

## Agent Definition

| ID | Name | Department | Specialization |
|----|------|------------|----------------|
| task1 | helper | general | General assistance |

## Dispatch Rules

- All tasks go to helper agent
- No conflict checking needed (single agent)
```

**SOUL.md** - Define personality:

```markdown
# Helper Agent

## Identity
A friendly and helpful AI assistant.

## Style
- Clear and concise communication
- Proactive problem-solving
- Always confirm before taking action

## Responsibilities
- Answer questions
- Execute tasks
- Provide recommendations
```

**TOOLS.md** - Define available tools:

```markdown
# Tools Configuration

## Environment
- Working directory: ~/my-first-agent
- Proxy: none

## Available Tools
- File operations (read, write, edit)
- Shell commands (exec)
- Web search
```

### Step 3: Start the Gateway

```bash
openclaw gateway start
```

### Step 4: Send Your First Task

```bash
openclaw chat "Create a hello.txt file with 'Hello, World!'"
```

You should see:
1. Agent acknowledges the task
2. Agent creates the file
3. Agent reports completion

### Step 5: Verify the Result

```bash
cat hello.txt
# Output: Hello, World!
```

## Your First Multi-Agent Team

Now let's set up a 3-agent development team.

### Step 1: Use the Example Configuration

```bash
cd examples/3-agent-dev-team
```

### Step 2: Review the Configuration

**AGENTS.md** defines three agents:

- **task1 (Architect)**: System design and architecture
- **task2 (Developer)**: Feature implementation
- **task3 (Tester)**: Quality assurance and testing

### Step 3: Start the Gateway

```bash
openclaw gateway start
```

### Step 4: Send a Complex Task

```bash
openclaw chat "Build a simple REST API with user authentication"
```

Watch as the system:
1. **Main agent** analyzes the task
2. **Architect** designs the API structure
3. **Developer** implements the code
4. **Tester** validates functionality
5. **Main agent** consolidates and reports results

## Your First Dispatch

Let's understand how task dispatch works.

### Manual Dispatch Example

```bash
# Check agent status
openclaw agents list

# Spawn a specific agent for a task
openclaw spawn task1 "Design a database schema for user management"

# Monitor progress
openclaw sessions list

# View agent output
openclaw sessions log <session-id>
```

### Automatic Dispatch Example

The main agent automatically dispatches based on task type:

```bash
# This goes to Architect (design task)
openclaw chat "Design a microservices architecture"

# This goes to Developer (coding task)
openclaw chat "Implement user login endpoint"

# This goes to Tester (testing task)
openclaw chat "Write integration tests for the API"
```

## Common First-Time Issues

### Issue 1: API Key Not Found

**Error**: `OPENAI_API_KEY not found in environment`

**Solution**:
```bash
# Add to .env file
echo "OPENAI_API_KEY=sk-..." >> .env

# Or export directly
export OPENAI_API_KEY=sk-...
```

### Issue 2: Gateway Won't Start

**Error**: `Port 3000 already in use`

**Solution**:
```bash
# Find and kill the process
lsof -ti:3000 | xargs kill -9

# Or use a different port
openclaw gateway start --port 3001
```

### Issue 3: Agent Not Responding

**Error**: Agent spawned but no output

**Solution**:
```bash
# Check agent logs
openclaw logs task1

# Verify model availability
openclaw models test

# Restart gateway
openclaw gateway restart
```

### Issue 4: File Permission Errors

**Error**: `EACCES: permission denied`

**Solution**:
```bash
# Fix permissions
chmod -R 755 ~/my-first-agent

# Or run with sudo (not recommended)
sudo openclaw gateway start
```

## Next Steps

Now that you have a working setup:

1. **Explore Examples**: Try the 5-agent and 16-agent configurations
2. **Read Architecture**: Understand how the system works internally
3. **Design Your Team**: Create agents for your specific use case
4. **Implement SOP**: Add the dispatch-sop-v2 skill for advanced workflows
5. **Monitor Performance**: Use health-check script to track system metrics

## Quick Reference

### Essential Commands

```bash
# Gateway management
openclaw gateway start
openclaw gateway stop
openclaw gateway restart
openclaw gateway status

# Agent operations
openclaw agents list
openclaw spawn <agent-id> "<task>"
openclaw sessions list
openclaw sessions kill <session-id>

# Debugging
openclaw logs <agent-id>
openclaw models test
openclaw health-check
```

### Configuration Files

- **AGENTS.md**: Agent definitions and dispatch rules
- **SOUL.md**: Agent personality and behavior
- **TOOLS.md**: Available tools and environment
- **.env**: API keys and secrets
- **gateway-config.yaml**: OpenClaw gateway settings

### Getting Help

- **Documentation**: Check `docs/` directory
- **Examples**: Review `examples/` for working configurations
- **Issues**: Report bugs on GitHub
- **Community**: Join Discord for real-time help

---

**Congratulations!** You've successfully set up your first multi-agent system. Ready to build something amazing? 🚀
