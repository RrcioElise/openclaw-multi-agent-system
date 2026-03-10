#!/bin/bash
# Create a new agent configuration

set -e

echo "=== Create New Agent ==="
echo ""

# Get agent details
read -p "Agent ID (e.g., task4): " AGENT_ID
read -p "Agent Name (e.g., designer): " AGENT_NAME
read -p "Department (e.g., Design): " DEPARTMENT
read -p "Specialization (e.g., UI/UX design): " SPECIALIZATION
read -p "Model (e.g., claude-sonnet-4): " MODEL

# Validate inputs
if [ -z "$AGENT_ID" ] || [ -z "$AGENT_NAME" ] || [ -z "$DEPARTMENT" ] || [ -z "$SPECIALIZATION" ] || [ -z "$MODEL" ]; then
    echo "❌ All fields are required"
    exit 1
fi

# Create agent directory
AGENT_DIR="$HOME/.openclaw/workspaces/main/agents/$AGENT_ID"
mkdir -p "$AGENT_DIR"

# Create SOUL.md
cat > "$AGENT_DIR/SOUL.md" << EOF
# $AGENT_NAME Agent

## Identity
$AGENT_NAME agent specializing in $SPECIALIZATION.

## Style
- Clear and professional communication
- Proactive problem-solving
- Collaborative approach

## Responsibilities
- $SPECIALIZATION
- Collaborate with other agents
- Report progress regularly

## Boundaries
- Focus on $DEPARTMENT tasks
- Escalate complex decisions to main agent
- Request approval for major changes

## Collaboration
- Works with other agents in the team
- Reports to main orchestrator agent
- Follows dispatch SOP for task execution
EOF

# Create TOOLS.md
cat > "$AGENT_DIR/TOOLS.md" << EOF
# $AGENT_NAME Tools

## Environment
- Working directory: ~/project
- Model: $MODEL

## File Access
- Read: src/**, docs/**
- Write: src/**, docs/**

## Available Commands
- Standard development tools
- Version control (git)
- Package management (npm)

## Constraints
- Max execution time: 30 minutes
- Follow security best practices
- Log all actions
EOF

# Add to AGENTS.md
AGENTS_FILE="$HOME/.openclaw/workspaces/main/AGENTS.md"
if [ -f "$AGENTS_FILE" ]; then
    echo "" >> "$AGENTS_FILE"
    echo "| $AGENT_ID | $AGENT_NAME | $DEPARTMENT | $SPECIALIZATION |" >> "$AGENTS_FILE"
    echo "✅ Added to AGENTS.md"
fi

# Add to gateway config
GATEWAY_CONFIG="$HOME/.openclaw/gateway-config.yaml"
if [ -f "$GATEWAY_CONFIG" ]; then
    cat >> "$GATEWAY_CONFIG" << EOF

  - id: $AGENT_ID
    name: $AGENT_NAME
    model: $MODEL
    workspace: main
    parent: main
    files:
      soul: agents/$AGENT_ID/SOUL.md
      tools: agents/$AGENT_ID/TOOLS.md
EOF
    echo "✅ Added to gateway-config.yaml"
fi

echo ""
echo "=== Agent Created Successfully ==="
echo ""
echo "Agent ID: $AGENT_ID"
echo "Name: $AGENT_NAME"
echo "Department: $DEPARTMENT"
echo "Specialization: $SPECIALIZATION"
echo "Model: $MODEL"
echo ""
echo "Configuration files:"
echo "- $AGENT_DIR/SOUL.md"
echo "- $AGENT_DIR/TOOLS.md"
echo ""
echo "Next steps:"
echo "1. Review and customize $AGENT_DIR/SOUL.md"
echo "2. Review and customize $AGENT_DIR/TOOLS.md"
echo "3. Restart gateway: openclaw gateway restart"
echo "4. Test agent: openclaw spawn $AGENT_ID 'test task'"
echo ""
