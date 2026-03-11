# HEARTBEAT.md

## 弟子监控系统

每次心跳检查监控脚本状态：

### 检查项
1. 检查 PM2 进程是否运行
2. 如果未运行，立即启动
3. 如果运行异常，重启
4. 汇报监控状态

### 执行命令
```bash
# 检查状态
pm2 status disciple-monitor

# 如果未运行，启动
pm2 start ~/.openclaw/skills/disciple-monitor/monitor.mjs --name disciple-monitor

# 如果异常，重启
pm2 restart disciple-monitor
```

### 监控规则
- 运行超过 30 分钟 → 警告
- 运行超过 60 分钟 → 高危
- 5 分钟无更新且运行超过 10 分钟 → 可能卡死
- Token 使用超过 500k → 警告

### 汇报规则
- 有异常立即汇报
- 无异常每 15 分钟汇报一次
- 任务完成时汇报
