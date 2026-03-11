# TOOLS.md - 环境信息

## 基础设施

- 机器: Mac Mini M4 16GB
- 外网: example.com (Cloudflare Tunnel)
- 代理: socks5h://127.0.0.1:1080

## 项目路径

- conpay: /Users/user/WorkSpace/Next/conpay
- star-office-ui: /Users/user/WorkSpace/Next/star-office-ui
- nanobot: /Users/user/nanobot
- zns: /Users/user/WorkSpace/zns (端口 3000)

## 任务管理

- 主力：飞书多维表格（feishu-tasks 技能）
- 辅助：task-monitor 仪表板（防空承诺）
- 恢复：task-recovery（重启后任务恢复）

## bot_speak.py

让其他 bot 在 Telegram 群里发言（不是执行任务）：
```bash
HTTPS_PROXY=socks5h://127.0.0.1:1080 python3 scripts/bot_speak.py <bot_name> <消息内容>
```
bot_name: task1-task16, all

## 安全规则

### Cloudflare Tunnel 配置

- ✅ example.com → zns 项目 (端口 3000)
- ✅ example.com → zns 项目 (端口 3000)
- ✅ example.com → 下载服务 (端口 8000)
- ❌ 绝对不要暴露 OpenClaw Gateway (端口 XXXX)
- ⚠️ 修改 Tunnel 配置前必须检查安全性

详见：SECURITY_WARNING.md
