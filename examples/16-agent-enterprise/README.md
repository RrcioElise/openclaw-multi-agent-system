# 16-Agent Enterprise Team (牛马宗)

A comprehensive enterprise-scale multi-agent system based on the battle-tested 牛马宗 (Niuma Sect) configuration.

## Team Composition

### Command Center (指挥中心)
| ID | Name | Role | Specialization |
|----|------|------|----------------|
| main | 宗主 (Sect Master) | Orchestrator | Task coordination, decision-making |
| task7 | 笑面虎 (Smiling Tiger) | Code Review | Quality gatekeeper, code review |
| task13 | 哲学猫 (Philosophy Cat) | Strategic Advisor | Strategic analysis, consultation |

### Development Zone (开发区)
| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task1 | 拉磨驴 (Grinding Donkey) | Architect | Complex architecture, hard problems |
| task2 | 上等马 (Premium Horse) | Developer | Fast coding, feature implementation |
| task3 | 看门狗 (Guard Dog) | Security | Security audit, code protection |
| task16 | 大根骑士 (Radish Knight) | Stability | Defensive stability, error handling |

### Planning & Product (策划产品)
| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task4 | 领头羊 (Lead Sheep) | Product | Product planning, requirements |
| task8 | 妙法天尊 (Dharma Master) | Solution Design | Solution design, tech selection |

### Intelligence (情报室)
| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task5 | 出头鸟 (Early Bird) | Quick Scout | Fast search, competitive analysis |
| task10 | 探宝鼠 (Treasure Hunter) | Deep Research | Deep research, data mining |
| task14 | 旅行者 (Traveler) | Trend Tracker | External trends, industry tracking |
| task15 | 派蒙 (Paimon) | Emergency Guide | Emergency response, quick help |

### Finance (金融区)
| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task6 | 铁公鸡 (Iron Rooster) | Financial Analyst | Financial analysis, cost control |
| task12 | 涨停板 (Limit Up) | Trading | Financial trading, quantitative analysis |

### Testing (测试区)
| ID | Name | Role | Specialization |
|----|------|------|----------------|
| task9 | 天地一子 (Heaven Earth One) | Functional Tester | Functional testing, quality validation |
| task11 | 知更鸟 (Robin) | Automation Tester | Automated testing, regression |

## Use Cases

Perfect for:
- Large-scale enterprise operations
- Complex multi-domain projects
- High-frequency task coordination
- Mission-critical systems

## Architecture

```
                    宗主 (Main Orchestrator)
                            |
        ┌───────────────────┼───────────────────┐
        |                   |                   |
   Command Center      Development         Intelligence
   ├─ 笑面虎 (Review)    ├─ 拉磨驴 (Arch)     ├─ 出头鸟 (Scout)
   └─ 哲学猫 (Advisor)   ├─ 上等马 (Dev)      ├─ 探宝鼠 (Research)
                        ├─ 看门狗 (Security)  ├─ 旅行者 (Trends)
                        └─ 大根骑士 (Stable)  └─ 派蒙 (Emergency)
        |                   |
    Planning            Testing & Finance
    ├─ 领头羊 (Product)   ├─ 天地一子 (Test)
    └─ 妙法天尊 (Design)  ├─ 知更鸟 (Auto Test)
                        ├─ 铁公鸡 (Finance)
                        └─ 涨停板 (Trading)
```

## Workflow Example

**Complex Task**: "Build a complete e-commerce platform"

1. **领头羊 (Product)** - Define requirements (30 min)
2. **妙法天尊 (Solution Design)** - Architecture design (45 min)
3. **拉磨驴 (Architect)** - Detailed technical design (60 min)
4. **出头鸟 (Scout)** - Research best practices (20 min)
5. **上等马 (Developer)** - Implement core features (120 min)
6. **看门狗 (Security)** - Security audit (30 min)
7. **大根骑士 (Stability)** - Error handling & resilience (45 min)
8. **天地一子 (Tester)** - Functional testing (60 min)
9. **知更鸟 (Auto Test)** - Automated test suite (45 min)
10. **笑面虎 (Reviewer)** - Code review (30 min)
11. **铁公鸡 (Finance)** - Cost analysis (20 min)

**Total**: ~8 hours with parallel execution

## Setup

### 1. Prerequisites

This is an advanced configuration. Ensure you have:
- Sufficient API quota (high token usage)
- Good understanding of multi-agent systems
- Experience with dispatch SOP

### 2. Configuration

```bash
cd examples/16-agent-enterprise
cp .env.example .env
# Edit .env with your API keys
```

### 3. Start Gateway

```bash
openclaw gateway start --config gateway-config.yaml
```

### 4. Test

```bash
openclaw chat "研究并实现一个用户认证系统"
```

## Key Features

### Dispatch SOP Integration

This configuration uses the full `dispatch-sop-v2` skill:
- **Intake**: 30-second acknowledgment
- **Planning**: Task decomposition with conflict checking
- **Execution**: Parallel/serial execution with monitoring
- **Gate**: Consolidated reporting

### Conflict Prevention

With 16 agents, file conflicts are common. The system:
- Pre-checks file ownership before spawning
- Serializes conflicting tasks automatically
- Tracks file locks across all agents

### Specialized Roles

Each agent has a narrow, well-defined role:
- Reduces decision paralysis
- Improves task matching
- Enables true parallel execution

## Performance Characteristics

### Throughput
- Simple tasks: 5-10 per hour
- Medium tasks: 2-3 per hour
- Complex tasks: 1 per 2-4 hours

### Resource Usage
- Memory: 8-16GB recommended
- CPU: 8+ cores recommended
- Network: High API call volume

### Cost
- Active development: $5-10/hour
- Idle: Minimal (agent pooling disabled by default)

## Customization

### Reduce Team Size

Remove agents you don't need:
1. Comment out in `gateway-config.yaml`
2. Update `AGENTS.md`
3. Restart gateway

### Add Agents

Follow the pattern:
1. Create `souls/new-agent.md`
2. Add to `AGENTS.md`
3. Add to `gateway-config.yaml`
4. Restart gateway

### Adjust Personalities

Edit individual `souls/*.md` files to customize:
- Communication style
- Decision-making approach
- Collaboration patterns

## Lessons Learned

This configuration is based on real-world usage. Key insights:

1. **Specialization matters**: Narrow roles perform better than generalists
2. **Conflict prevention is critical**: Pre-checking saves hours of debugging
3. **Monitoring is essential**: 5-10 minute check-ins catch issues early
4. **Personality matters**: Well-defined personas improve consistency
5. **Documentation is key**: Clear SOUL.md files reduce confusion

## Troubleshooting

### Too Many Agents Active
- Reduce concurrent agent limit in config
- Use agent pooling sparingly
- Monitor memory usage

### Conflicts Still Happening
- Review file ownership rules in AGENTS.md
- Ensure dispatch SOP is being followed
- Check logs for conflict warnings

### High Costs
- Use cheaper models for simple agents (Haiku instead of Opus)
- Reduce context size in prompts
- Implement caching for repeated queries

## Next Steps

1. Start with 3-5 agents, scale gradually
2. Monitor performance and costs
3. Customize personalities for your domain
4. Add domain-specific skills
5. Implement custom workflows

---

**Note**: This is a sanitized version of the production 牛马宗 configuration. Sensitive information has been removed.
