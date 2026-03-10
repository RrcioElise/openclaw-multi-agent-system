#!/bin/bash
# Setup script for OpenClaw Multi-Agent System

set -e

echo "=== OpenClaw Multi-Agent System Setup ==="
echo ""

# Check Node.js
echo "Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+ first."
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version must be 18 or higher. Current: $(node --version)"
    exit 1
fi
echo "✅ Node.js $(node --version)"

# Check npm
echo "Checking npm..."
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install npm first."
    exit 1
fi
echo "✅ npm $(npm --version)"

# Check OpenClaw
echo "Checking OpenClaw..."
if ! command -v openclaw &> /dev/null; then
    echo "⚠️  OpenClaw not found. Installing..."
    npm install -g openclaw
    echo "✅ OpenClaw installed"
else
    echo "✅ OpenClaw $(openclaw --version)"
fi

# Create workspace directory
echo ""
echo "Setting up workspace..."
WORKSPACE_DIR="$HOME/.openclaw/workspaces/multi-agent"
mkdir -p "$WORKSPACE_DIR"
echo "✅ Workspace created at $WORKSPACE_DIR"

# Copy configuration files
echo ""
echo "Copying configuration files..."
cp config/agents-template.md "$WORKSPACE_DIR/AGENTS.md"
cp config/soul-template.md "$WORKSPACE_DIR/SOUL.md"
cp config/tools-template.md "$WORKSPACE_DIR/TOOLS.md"
echo "✅ Configuration files copied"

# Create .env file
echo ""
echo "Creating .env file..."
if [ ! -f .env ]; then
    cat > .env << 'EOF'
# OpenAI API Key
OPENAI_API_KEY=

# Anthropic API Key
ANTHROPIC_API_KEY=

# Google API Key (optional)
# GOOGLE_API_KEY=

# Proxy settings (optional)
# HTTPS_PROXY=socks5h://127.0.0.1:7897
# HTTP_PROXY=socks5h://127.0.0.1:7897

# Database (optional)
# DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# Redis (optional)
# REDIS_URL=redis://localhost:6379
EOF
    echo "✅ .env file created"
    echo "⚠️  Please edit .env and add your API keys"
else
    echo "✅ .env file already exists"
fi

# Check API keys
echo ""
echo "Checking API keys..."
if [ -f .env ]; then
    source .env
    
    if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
        echo "⚠️  No API keys found in .env"
        echo "   Please add at least one API key (OpenAI or Anthropic)"
    else
        [ -n "$OPENAI_API_KEY" ] && echo "✅ OpenAI API key found"
        [ -n "$ANTHROPIC_API_KEY" ] && echo "✅ Anthropic API key found"
    fi
fi

# Install skills
echo ""
echo "Installing skills..."
SKILLS_DIR="$HOME/.openclaw/skills"
mkdir -p "$SKILLS_DIR"

if [ -d "skills/dispatch-sop-v2" ]; then
    cp -r skills/dispatch-sop-v2 "$SKILLS_DIR/"
    echo "✅ dispatch-sop-v2 skill installed"
fi

# Create logs directory
echo ""
echo "Creating logs directory..."
mkdir -p "$HOME/.openclaw/logs"
echo "✅ Logs directory created"

# Summary
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Edit .env and add your API keys"
echo "2. Choose an example configuration:"
echo "   - cd examples/3-agent-dev-team"
echo "   - cd examples/5-agent-startup"
echo "   - cd examples/16-agent-enterprise"
echo "3. Start the gateway:"
echo "   openclaw gateway start"
echo "4. Send your first task:"
echo "   openclaw chat 'Hello, team!'"
echo ""
echo "Documentation: docs/"
echo "Troubleshooting: docs/troubleshooting.md"
echo ""
