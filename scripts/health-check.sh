#!/bin/bash
# Health check script for OpenClaw Multi-Agent System

set -e

echo "=== OpenClaw Multi-Agent System Health Check ==="
echo ""
echo "Timestamp: $(date)"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check gateway status
echo "1. Gateway Status"
if openclaw gateway status &> /dev/null; then
    if openclaw gateway status | grep -q "running"; then
        echo -e "   ${GREEN}✅ Gateway: Running${NC}"
        UPTIME=$(openclaw gateway status | grep -i uptime || echo "Unknown")
        echo "   $UPTIME"
    else
        echo -e "   ${RED}❌ Gateway: Not running${NC}"
    fi
else
    echo -e "   ${RED}❌ Gateway: Not accessible${NC}"
fi
echo ""

# Check agents
echo "2. Agent Status"
if command -v openclaw &> /dev/null; then
    AGENTS=$(openclaw agents list 2>/dev/null || echo "")
    if [ -n "$AGENTS" ]; then
        echo "$AGENTS" | while read -r line; do
            if echo "$line" | grep -q "available"; then
                echo -e "   ${GREEN}✅ $line${NC}"
            elif echo "$line" | grep -q "busy"; then
                echo -e "   ${YELLOW}⚠️  $line${NC}"
            else
                echo "   $line"
            fi
        done
    else
        echo -e "   ${YELLOW}⚠️  No agents found${NC}"
    fi
else
    echo -e "   ${RED}❌ OpenClaw CLI not available${NC}"
fi
echo ""

# Check models
echo "3. Model Connectivity"
if openclaw models test &> /dev/null; then
    echo -e "   ${GREEN}✅ Models: Reachable${NC}"
else
    echo -e "   ${RED}❌ Models: Unreachable${NC}"
    echo "   Check API keys and network connectivity"
fi
echo ""

# Check disk space
echo "4. Disk Space"
OPENCLAW_DIR="$HOME/.openclaw"
if [ -d "$OPENCLAW_DIR" ]; then
    DISK_USAGE=$(du -sh "$OPENCLAW_DIR" 2>/dev/null | cut -f1)
    echo "   OpenClaw directory: $DISK_USAGE"
    
    # Check available space
    AVAILABLE=$(df -h "$OPENCLAW_DIR" | tail -1 | awk '{print $4}')
    USAGE_PERCENT=$(df -h "$OPENCLAW_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if [ "$USAGE_PERCENT" -lt 80 ]; then
        echo -e "   ${GREEN}✅ Disk: ${USAGE_PERCENT}% used, ${AVAILABLE} available${NC}"
    elif [ "$USAGE_PERCENT" -lt 90 ]; then
        echo -e "   ${YELLOW}⚠️  Disk: ${USAGE_PERCENT}% used, ${AVAILABLE} available${NC}"
    else
        echo -e "   ${RED}❌ Disk: ${USAGE_PERCENT}% used, ${AVAILABLE} available (critical)${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  OpenClaw directory not found${NC}"
fi
echo ""

# Check memory usage
echo "5. Memory Usage"
if command -v ps &> /dev/null; then
    MEM_USAGE=$(ps aux | grep -i openclaw | grep -v grep | awk '{sum+=$4} END {print sum}')
    if [ -n "$MEM_USAGE" ] && [ "$MEM_USAGE" != "0" ]; then
        MEM_USAGE_INT=$(printf "%.0f" "$MEM_USAGE")
        if [ "$MEM_USAGE_INT" -lt 50 ]; then
            echo -e "   ${GREEN}✅ Memory: ${MEM_USAGE}% used${NC}"
        elif [ "$MEM_USAGE_INT" -lt 80 ]; then
            echo -e "   ${YELLOW}⚠️  Memory: ${MEM_USAGE}% used${NC}"
        else
            echo -e "   ${RED}❌ Memory: ${MEM_USAGE}% used (high)${NC}"
        fi
    else
        echo "   No OpenClaw processes found"
    fi
else
    echo "   Unable to check memory usage"
fi
echo ""

# Check active sessions
echo "6. Active Sessions"
if openclaw sessions list &> /dev/null; then
    SESSION_COUNT=$(openclaw sessions list 2>/dev/null | wc -l)
    if [ "$SESSION_COUNT" -gt 0 ]; then
        echo "   Active sessions: $SESSION_COUNT"
        openclaw sessions list 2>/dev/null | head -5
        if [ "$SESSION_COUNT" -gt 5 ]; then
            echo "   ... and $((SESSION_COUNT - 5)) more"
        fi
    else
        echo "   No active sessions"
    fi
else
    echo "   Unable to check sessions"
fi
echo ""

# Check logs for errors
echo "7. Recent Errors"
LOG_FILE="$HOME/.openclaw/logs/gateway.log"
if [ -f "$LOG_FILE" ]; then
    ERROR_COUNT=$(grep -i error "$LOG_FILE" | tail -100 | wc -l)
    if [ "$ERROR_COUNT" -eq 0 ]; then
        echo -e "   ${GREEN}✅ No recent errors${NC}"
    elif [ "$ERROR_COUNT" -lt 10 ]; then
        echo -e "   ${YELLOW}⚠️  $ERROR_COUNT errors in last 100 log lines${NC}"
        echo "   Recent errors:"
        grep -i error "$LOG_FILE" | tail -3 | sed 's/^/   /'
    else
        echo -e "   ${RED}❌ $ERROR_COUNT errors in last 100 log lines (high)${NC}"
        echo "   Recent errors:"
        grep -i error "$LOG_FILE" | tail -3 | sed 's/^/   /'
    fi
else
    echo "   Log file not found"
fi
echo ""

# Check configuration
echo "8. Configuration"
CONFIG_FILE="$HOME/.openclaw/gateway-config.yaml"
if [ -f "$CONFIG_FILE" ]; then
    echo -e "   ${GREEN}✅ Gateway config found${NC}"
else
    echo -e "   ${YELLOW}⚠️  Gateway config not found${NC}"
fi

AGENTS_FILE="$HOME/.openclaw/workspaces/main/AGENTS.md"
if [ -f "$AGENTS_FILE" ]; then
    echo -e "   ${GREEN}✅ AGENTS.md found${NC}"
else
    echo -e "   ${YELLOW}⚠️  AGENTS.md not found${NC}"
fi
echo ""

# Overall status
echo "=== Overall Status ==="
echo ""

# Count issues
CRITICAL=0
WARNINGS=0

# Gateway check
if ! openclaw gateway status | grep -q "running" 2>/dev/null; then
    CRITICAL=$((CRITICAL + 1))
fi

# Disk check
if [ -d "$OPENCLAW_DIR" ]; then
    USAGE_PERCENT=$(df -h "$OPENCLAW_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$USAGE_PERCENT" -ge 90 ]; then
        CRITICAL=$((CRITICAL + 1))
    elif [ "$USAGE_PERCENT" -ge 80 ]; then
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Error check
if [ -f "$LOG_FILE" ]; then
    ERROR_COUNT=$(grep -i error "$LOG_FILE" | tail -100 | wc -l)
    if [ "$ERROR_COUNT" -ge 10 ]; then
        WARNINGS=$((WARNINGS + 1))
    fi
fi

if [ "$CRITICAL" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}✅ System is healthy${NC}"
elif [ "$CRITICAL" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  System is operational with $WARNINGS warning(s)${NC}"
else
    echo -e "${RED}❌ System has $CRITICAL critical issue(s) and $WARNINGS warning(s)${NC}"
fi

echo ""
echo "=== Health Check Complete ==="
