# 16-Agent Enterprise Team (牛马宗架构)

基于实际生产环境的企业级多 agent 配置。

## 系统架构

```
宗主 (Main Agent)
├── 开发区 (6 agents)
│   ├── task1 - 拉磨驴 (架构设计)
│   ├── task2 - 上等马 (快速编码)
│   ├── task3 - 看门狗 (安全审计)
│   └── task16 - 大根骑士 (稳定性)
├── 策划产品 (2 agents)
│   ├── task4 - 领头羊 (需求分析)
│   └── task8 - 妙法天尊 (方案设计)
├── 情报室 (4 agents)
│   ├── task5 - 出头鸟 (快速搜索)
│   ├── task10 - 探宝鼠 (深度调研)
│   ├── task14 - 旅行者 (外部趋势)
│   └── task15 - 派蒙 (应急响应)
├── 金融区 (2 agents)
│   ├── task6 - 铁公鸡 (成本控制)
│   └── task12 - 涨停板 (量化分析)
├── 测试区 (2 agents)
│   ├── task9 - 天地一子 (功能测试)
│   └── task11 - 知更鸟 (自动化测试)
└── 指挥中心 (2 agents)
    ├── task7 - 笑面虎 (代码审查)
    └── task13 - 哲学猫 (战略分析)
```

## 模型配置

- **宗主**: Claude Opus 4.6 (200K context)
- **开发/测试/金融**: Claude Sonnet 4.6 (160K context)
- **策划/情报/指挥**: GPT-5.4 XHigh (128K context)

## 技能模块 (42+)

### 核心调度
- dispatch-sop-v2: 标准化调度流程
- task-recovery: 任务恢复
- feishu-tasks: 任务管理

### 开发工具
- github: GitHub 集成
- gog: Google Workspace
- notion: Notion 集成

### 业务技能
- [根据实际需求配置]

## 使用场景

- 大型软件项目开发
- 多团队协同工作
- 复杂业务流程自动化
- 企业级 AI 应用

## 配置说明

所有敏感信息已移除，使用前需要：
1. 配置模型 API Key
2. 设置 Telegram Bot Token（如需）
3. 配置各技能的凭证
4. 根据实际需求调整 agent 数量和角色

## 注意事项

- 建议先在测试环境验证
- 根据团队规模调整 agent 数量
- 监控资源使用情况
- 定期备份配置和数据
