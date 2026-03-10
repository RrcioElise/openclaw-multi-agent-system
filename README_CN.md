# OpenClaw 多智能体系统

基于 OpenClaw 构建的综合性多智能体编排系统。通过智能任务调度、冲突预防和标准化工作流管理 AI 智能体团队。

## 特性

- **智能任务调度**：根据智能体专长自动路由任务到最合适的执行者
- **冲突预防**：内置文件所有权追踪，防止并发写入冲突
- **标准化工作流**：SOP 驱动的执行流程，包含接单、拆单、执行和汇报阶段
- **可扩展架构**：从 3 人开发团队到 16+ 人企业级团队
- **实时监控**：追踪智能体状态、任务进度和系统健康
- **灵活配置**：基于 YAML 的配置，支持人格定义（SOUL.md）和能力映射

## 快速开始（5 分钟）

### 前置要求

- Node.js 18+ 和 npm
- 已安装 OpenClaw（`npm install -g openclaw`）
- 你偏好的 LLM 提供商的 API 密钥

### 安装

```bash
# 克隆仓库
git clone https://github.com/yourusername/openclaw-multi-agent-system.git
cd openclaw-multi-agent-system

# 运行安装脚本
chmod +x scripts/setup.sh
./scripts/setup.sh

# 从 3 人团队示例开始
cd examples/3-agent-dev-team
openclaw gateway start
```

### 第一个任务

```bash
# 向智能体团队发送任务
openclaw chat "构建一个用户认证的 REST API"
```

系统将自动：
1. 分析任务复杂度
2. 拆分为子任务
3. 分配给合适的智能体（架构师、开发者、测试员）
4. 监控进度并处理冲突
5. 汇总结果并报告

## 架构概览

```
┌─────────────────────────────────────────────────────────────┐
│                     主智能体（编排者）                        │
│  - 任务接收与复杂度分析                                      │
│  - 子任务规划与智能体分配                                    │
│  - 进度监控与冲突解决                                        │
│  - 结果汇总与报告                                            │
└────────────────┬────────────────────────────────────────────┘
                 │
        ┌────────┴────────┬────────────────┬──────────────┐
        │                 │                │              │
   ┌────▼─────┐     ┌────▼─────┐    ┌────▼─────┐   ┌───▼──────┐
   │ 开发团队  │     │ 调研团队  │    │ 测试团队  │   │ 金融团队  │
   │          │     │          │    │          │   │          │
   │ - 架构师  │     │ - 分析师  │    │ - 质量    │   │ - 分析师  │
   │ - 开发者  │     │ - 侦察兵  │    │ - 自动化  │   │ - 交易员  │
   │ - 安全    │     │ - 追踪者  │    │   测试    │   │          │
   └──────────┘     └──────────┘    └──────────┘   └──────────┘
```

## 核心概念

### 智能体角色

每个智能体具有：
- **专长**：特定领域专业知识（开发、调研、测试等）
- **人格（SOUL.md）**：性格、沟通风格和决策方式
- **能力（TOOLS.md）**：可用工具、API 和系统访问权限
- **约束**：文件所有权规则、资源限制、安全边界

### 任务调度流程

1. **接单（Intake）**：主智能体接收任务，30 秒内确认
2. **拆单（Planning）**：拆分为子任务，分配负责人，检查冲突
3. **执行（Execution）**：派生子智能体，每 5-10 分钟监控进度
4. **汇报（Gate）**：汇总结果，使用标准化模板向用户报告

### 冲突预防

- **文件所有权**：每个时间窗口内一个文件只能有一个智能体操作
- **执行前检查**：派发前验证没有重叠的文件访问
- **锁机制**：智能体在写入前声明文件意图
- **回滚支持**：失败的任务不会破坏共享状态

## 使用场景

### 开发团队（3 个智能体）
- 架构师设计系统结构
- 开发者实现功能
- 测试员验证功能

### 创业团队（5 个智能体）
- 产品经理定义需求
- 开发者构建功能
- 设计师创建 UI/UX
- 测试员确保质量
- 运维处理部署

### 企业团队（16 个智能体）
- 指挥中心（战略、审查、顾问）
- 开发区（架构、编码、安全、稳定性）
- 策划产品（需求、设计）
- 情报室（调研、竞品分析、趋势）
- 金融区（分析、交易）
- 测试区（功能、自动化）

## 配置

### 网关配置（`config/gateway-config.yaml`）

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

### 智能体人格（`SOUL.md`）

```markdown
# 架构师智能体

## 身份
拥有 10 年以上经验的高级软件架构师。
INTJ 性格，战略思考者。

## 风格
- 简洁的技术沟通
- 关注可扩展性和可维护性
- 主动识别风险

## 职责
- 系统设计和架构决策
- 技术栈选择
- 代码审查和质量标准
```

## 示例

探索完整的工作示例：

- **[3 人开发团队](examples/3-agent-dev-team/)**：小型项目的最小化配置
- **[5 人创业团队](examples/5-agent-startup/)**：成长型公司的均衡团队
- **[16 人企业团队](examples/16-agent-enterprise/)**：复杂操作的全规模编排

## 文档

- [快速开始指南](docs/getting-started.md)
- [架构深入解析](docs/architecture.md)
- [智能体设计原则](docs/agent-design.md)
- [调度 SOP 参考](docs/dispatch-sop.md)
- [最佳实践](docs/best-practices.md)
- [故障排查](docs/troubleshooting.md)

## 贡献

我们欢迎贡献！详情请参阅[贡献指南](CONTRIBUTING.md)。

### 开发环境设置

```bash
# Fork 并克隆
git clone https://github.com/yourusername/openclaw-multi-agent-system.git

# 安装依赖
npm install

# 运行测试
npm test

# 提交 PR
```

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 社区

- **GitHub Issues**：错误报告和功能请求
- **Discussions**：问题和社区支持
- **Discord**：实时聊天和协作（即将推出）

## 致谢

基于 [OpenClaw](https://openclaw.ai) 构建 - 开源 AI 智能体编排平台。

灵感来自管理复杂软件开发、研究和业务运营的真实多智能体系统。

---

**如果觉得有用，请给这个仓库点星！** 🌟
