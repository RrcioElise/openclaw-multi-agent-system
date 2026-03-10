# Dispatch SOP (Standard Operating Procedure)

This document details the complete Standard Operating Procedure for task dispatch in multi-agent systems.

## Overview

The Dispatch SOP is a four-phase workflow that ensures reliable, conflict-free task execution across multiple agents:

1. **Intake**: Receive and acknowledge tasks
2. **Planning**: Decompose and assign work
3. **Execution**: Monitor and coordinate
4. **Gate**: Consolidate and report

## Phase 1: Intake

### Objective
Quickly acknowledge receipt and assess task complexity.

### Timeline
**30 seconds** from task receipt to acknowledgment.

### Process

```
User Request
    ↓
[Main Agent Receives]
    ↓
Acknowledge Receipt (< 30s)
    ↓
Initial Complexity Assessment
    ↓
Simple? → Handle Directly
Complex? → Proceed to Planning
```

### Acknowledgment Template

```markdown
收到任务：[简短描述]

初步评估：
- 复杂度：[简单/中等/复杂]
- 预计耗时：[时间估算]
- 涉及领域：[开发/测试/调研/...]

处理方式：
- [自己处理 / 派发给弟子]

[如果派发] 准备拆解任务...
```

**English Version**:
```markdown
Task received: [brief description]

Initial assessment:
- Complexity: [simple/medium/complex]
- Estimated time: [time estimate]
- Domains: [dev/test/research/...]

Approach:
- [handle directly / dispatch to agents]

[If dispatching] Preparing task breakdown...
```

### Complexity Assessment

| Complexity | Criteria | Example | Action |
|------------|----------|---------|--------|
| **Simple** | Single domain, < 10 min, no dependencies | "Check current time" | Handle directly |
| **Medium** | Single domain, 10-30 min, few dependencies | "Write a REST endpoint" | Consider dispatch |
| **Complex** | Multiple domains, > 30 min, many dependencies | "Build authentication system" | Must dispatch |

## Phase 2: Planning

### Objective
Break down complex tasks into independent, conflict-free subtasks.

### Timeline
**5 minutes** for planning and conflict checking.

### Process

```
Complex Task
    ↓
Decompose into Subtasks
    ↓
For each subtask:
    ├─ Identify required skills
    ├─ Match to agent specialization
    ├─ List file dependencies
    └─ Estimate duration
    ↓
Conflict Pre-Check
    ↓
Assign Owners
    ↓
Determine Execution Order
    ↓
Proceed to Execution
```

### Task Decomposition

**Example**: "Build user authentication system"

```markdown
## Task Breakdown

### Subtask 1: Architecture Design
- Owner: task1 (Architect)
- Duration: 20 min
- Files: docs/auth-design.md
- Dependencies: None
- Deliverable: Architecture document

### Subtask 2: Database Schema
- Owner: task1 (Architect)
- Duration: 15 min
- Files: migrations/001_users.sql
- Dependencies: Subtask 1
- Deliverable: Migration file

### Subtask 3: API Implementation
- Owner: task2 (Developer)
- Duration: 45 min
- Files: src/auth/*, src/api/auth.ts
- Dependencies: Subtask 2
- Deliverable: Working API endpoints

### Subtask 4: Unit Tests
- Owner: task2 (Developer)
- Duration: 30 min
- Files: tests/auth.test.ts
- Dependencies: Subtask 3
- Deliverable: Test suite

### Subtask 5: Integration Testing
- Owner: task3 (Tester)
- Duration: 30 min
- Files: tests/integration/auth.test.ts
- Dependencies: Subtask 4
- Deliverable: Test report
```

### Conflict Pre-Check

Before assigning, verify no file conflicts:

```javascript
// Pseudo-code for conflict checking
function checkConflicts(subtasks) {
  const fileOwnership = new Map();
  const conflicts = [];
  
  for (const task of subtasks) {
    for (const file of task.files) {
      const existingOwner = fileOwnership.get(file);
      
      if (existingOwner && existingOwner !== task.owner) {
        conflicts.push({
          file,
          task1: existingOwner,
          task2: task.owner
        });
      } else {
        fileOwnership.set(file, task.owner);
      }
    }
  }
  
  return conflicts;
}
```

**Conflict Resolution Strategies**:

1. **Serialize**: Execute conflicting tasks sequentially
2. **Split Files**: Divide file into non-overlapping sections
3. **Reassign**: Give all related files to one agent
4. **Coordinate**: Agents communicate before writing

### Execution Order

**Parallel Execution** (when safe):
```
Subtask 1 (Architect: Design)
    ↓
Subtask 2 (Architect: Schema)
    ↓
┌─────────────┬─────────────┐
│ Subtask 3   │ Subtask 4   │  ← Parallel
│ (Dev: API)  │ (Dev: Tests)│
└─────────────┴─────────────┘
    ↓
Subtask 5 (Tester: Integration)
```

**Serial Execution** (when dependencies exist):
```
Subtask 1 → Subtask 2 → Subtask 3 → Subtask 4 → Subtask 5
```

## Phase 3: Execution

### Objective
Spawn agents, monitor progress, handle issues.

### Timeline
**5-10 minute intervals** for progress checks.

### Process

```
For each subtask:
    ↓
Check Agent Availability
    ↓
Spawn Sub-Agent
    ↓
Record Session Key
    ↓
Monitor Progress (every 5-10 min)
    ↓
Handle Issues if Any
    ↓
Wait for Completion
```

### Agent Spawning

**Step 1: Check Availability**

```bash
# Use sessions_list to check agent status
sessions_list()

# Output shows:
# task1: idle
# task2: busy (session: abc123)
# task3: idle
```

**Step 2: Spawn with Full Context**

```javascript
sessions_spawn({
  agent: "task1",
  label: "auth-architecture-design",
  message: `Design the architecture for a user authentication system.

Requirements:
- JWT-based authentication
- Refresh token mechanism
- Password reset flow
- Email verification
- Rate limiting

Context:
- Project: REST API for e-commerce platform
- Tech stack: Node.js, PostgreSQL, Redis
- Security: OWASP Top 10 compliance required

Deliverable:
- Architecture document (docs/auth-design.md)
- Component diagram
- API contract definitions
- Security considerations

Timeline: 20 minutes

Note: Developer agent will implement based on your design.`
})

// Returns: { sessionKey: "agent:task1:subagent:abc123" }
```

**Step 3: Record Session**

```markdown
## Active Sessions

| Agent | Task | Session Key | Started | Status |
|-------|------|-------------|---------|--------|
| task1 | auth-architecture | abc123 | 14:00 | Running |
| task2 | api-implementation | def456 | 14:15 | Running |
| task3 | integration-test | ghi789 | 14:30 | Queued |
```

### Progress Monitoring

**Every 5-10 minutes**, check status:

```bash
# Check all active sessions
sessions_list()

# View specific session log
sessions_log("abc123")
```

**Progress Update Template**:

```markdown
## Progress Update (14:25)

### Completed
- task1 (Architect): ✅ Architecture design done
- task2 (Developer): 🔄 API implementation 60% complete

### In Progress
- task2 (Developer): Implementing JWT validation

### Queued
- task3 (Tester): Waiting for task2 completion

### Issues
- None

### Next Check
- 14:35 (10 minutes)
```

### Issue Handling

**Common Issues**:

1. **Agent Timeout**
   - Symptom: No response for > 15 minutes
   - Action: Check logs, consider restart or reassign

2. **Tool Failure**
   - Symptom: File operation or command fails
   - Action: Investigate error, provide guidance or fix environment

3. **Blocked by Dependency**
   - Symptom: Agent waiting for another agent's output
   - Action: Check dependency status, adjust timeline

4. **Conflict Detected**
   - Symptom: Two agents trying to modify same file
   - Action: Pause one agent, serialize execution

**Issue Escalation**:

```markdown
⚠️ Issue Detected

Agent: task2 (Developer)
Task: API implementation
Issue: Database connection failed

Error:
```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

Impact: Cannot proceed with implementation

Action Taken:
1. Checked DATABASE_URL in .env
2. Verified PostgreSQL is running
3. Found: PostgreSQL service not started

Resolution:
Starting PostgreSQL service...

Status: Resolved
Resuming task execution...
```

## Phase 4: Gate

### Objective
Consolidate results and report to user.

### Timeline
**Within 5 minutes** of all tasks completing.

### Process

```
All Subtasks Complete
    ↓
Collect Results
    ↓
Verify Deliverables
    ↓
Consolidate Report
    ↓
Present to User
```

### Report Template

```markdown
# 牛马宗任务汇报

## 任务概述
[原始任务描述]

## 执行情况

### 已完成 ✅
- **拉磨驴 (task1)**: 架构设计完成
  - 产出: docs/auth-design.md
  - 耗时: 18 分钟
  
- **上等马 (task2)**: API 实现完成
  - 产出: src/auth/*, tests/auth.test.ts
  - 耗时: 42 分钟
  
- **天地一子 (task3)**: 集成测试完成
  - 产出: tests/integration/auth.test.ts
  - 测试通过率: 100% (15/15)
  - 耗时: 28 分钟

### 总结
- 参与人数: 3 人
- 总耗时: 1 小时 28 分钟
- 成功率: 100%
- 产出文件: 8 个

## 交付物

### 文档
- docs/auth-design.md - 架构设计文档

### 代码
- src/auth/jwt.ts - JWT 工具函数
- src/auth/middleware.ts - 认证中间件
- src/api/auth.ts - 认证 API 端点

### 测试
- tests/auth.test.ts - 单元测试 (12 个用例)
- tests/integration/auth.test.ts - 集成测试 (15 个用例)

## 质量指标
- 代码覆盖率: 95%
- 测试通过率: 100%
- 安全扫描: 无漏洞
- 性能: 响应时间 < 100ms

## 后续建议
1. 部署到测试环境验证
2. 进行安全渗透测试
3. 编写用户文档
4. 配置监控告警

此事已办妥，请掌门人过目。
```

**English Version**:

```markdown
# Task Completion Report

## Task Overview
[Original task description]

## Execution Summary

### Completed ✅
- **Architect (task1)**: Architecture design completed
  - Deliverable: docs/auth-design.md
  - Duration: 18 minutes
  
- **Developer (task2)**: API implementation completed
  - Deliverables: src/auth/*, tests/auth.test.ts
  - Duration: 42 minutes
  
- **Tester (task3)**: Integration testing completed
  - Deliverable: tests/integration/auth.test.ts
  - Pass rate: 100% (15/15)
  - Duration: 28 minutes

### Summary
- Agents involved: 3
- Total duration: 1 hour 28 minutes
- Success rate: 100%
- Files created: 8

## Deliverables

### Documentation
- docs/auth-design.md - Architecture design document

### Code
- src/auth/jwt.ts - JWT utilities
- src/auth/middleware.ts - Authentication middleware
- src/api/auth.ts - Authentication API endpoints

### Tests
- tests/auth.test.ts - Unit tests (12 cases)
- tests/integration/auth.test.ts - Integration tests (15 cases)

## Quality Metrics
- Code coverage: 95%
- Test pass rate: 100%
- Security scan: No vulnerabilities
- Performance: Response time < 100ms

## Next Steps
1. Deploy to staging environment
2. Conduct security penetration testing
3. Write user documentation
4. Configure monitoring and alerts

Task completed successfully.
```

## SOP Enforcement

### Mandatory Steps

These steps **MUST** be followed:

1. ✅ Acknowledge within 30 seconds
2. ✅ Check conflicts before spawning
3. ✅ Use `sessions_spawn` (not just verbal commitment)
4. ✅ Record session keys
5. ✅ Monitor progress every 5-10 minutes
6. ✅ Report with standardized template

### Optional Steps

These steps are recommended but not required for simple tasks:

- Detailed task breakdown document
- Progress updates to user during execution
- Post-mortem analysis

### Violations

**Common Violations**:

1. **Empty Promise**: Saying "I'll dispatch" but not calling `sessions_spawn`
2. **No Tracking**: Spawning without recording session key
3. **No Monitoring**: Spawning and forgetting
4. **Conflict Ignorance**: Not checking file ownership before dispatch
5. **Silent Failure**: Agent fails but main agent doesn't notice

**Consequences**:
- Task failures
- File conflicts and data loss
- Wasted agent time
- Poor user experience

## SOP Variations

### Simplified SOP (for simple tasks)

```
1. Acknowledge (30s)
2. Spawn agent with clear instructions
3. Wait for completion (auto-pushed)
4. Report result
```

**When to use**: Single-agent tasks, < 30 minutes, no file conflicts.

### Full SOP (for complex tasks)

Use all four phases as documented above.

**When to use**: Multi-agent tasks, > 30 minutes, file dependencies.

### Emergency SOP (for urgent tasks)

```
1. Immediate acknowledgment (< 10s)
2. Spawn highest-priority agent
3. Monitor every 2-3 minutes
4. Report immediately upon completion
```

**When to use**: Production incidents, critical bugs, time-sensitive requests.

## Metrics and KPIs

### Dispatch Efficiency

- **Acknowledgment Time**: < 30 seconds (target)
- **Planning Time**: < 5 minutes (target)
- **Spawn Success Rate**: > 95% (target)
- **Conflict Rate**: < 5% (target)

### Execution Quality

- **Task Completion Rate**: > 90% (target)
- **On-Time Delivery**: > 80% (target)
- **Rework Rate**: < 10% (target)
- **Agent Utilization**: 60-80% (optimal)

### Reporting Quality

- **Report Timeliness**: < 5 minutes after completion (target)
- **Report Completeness**: All deliverables listed (100%)
- **Report Accuracy**: Matches actual output (100%)

## Troubleshooting

### Problem: Agents not responding

**Symptoms**: Spawned agent shows no activity

**Diagnosis**:
```bash
sessions_list()  # Check if agent is actually running
sessions_log(<session-id>)  # Check for errors
```

**Solutions**:
1. Check agent configuration
2. Verify model API is accessible
3. Review agent logs for errors
4. Restart gateway if needed

### Problem: File conflicts

**Symptoms**: Multiple agents modifying same file

**Diagnosis**:
```bash
# Check file ownership map
# Review recent file modifications
```

**Solutions**:
1. Serialize conflicting tasks
2. Split file into sections
3. Reassign to single agent

### Problem: Task timeout

**Symptoms**: Agent running > expected duration

**Diagnosis**:
```bash
sessions_log(<session-id>)  # Check what agent is doing
```

**Solutions**:
1. Extend timeout if making progress
2. Kill and reassign if stuck
3. Break into smaller subtasks

---

Next: [Best Practices](best-practices.md)
