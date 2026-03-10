#!/bin/bash
# 清理敏感信息脚本

echo "开始清理敏感信息..."

# 1. 移除真实邮箱
find . -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.json" \) | while read file; do
    sed -i '' 's/[a-zA-Z0-9._%+-]\+@qq\.com/user@example.com/g' "$file" 2>/dev/null || sed -i 's/[a-zA-Z0-9._%+-]\+@qq\.com/user@example.com/g' "$file" 2>/dev/null
    sed -i '' 's/[a-zA-Z0-9._%+-]\+@gmail\.com/user@example.com/g' "$file" 2>/dev/null || sed -i 's/[a-zA-Z0-9._%+-]\+@gmail\.com/user@example.com/g' "$file" 2>/dev/null
    sed -i '' 's/[a-zA-Z0-9._%+-]\+@163\.com/user@example.com/g' "$file" 2>/dev/null || sed -i 's/[a-zA-Z0-9._%+-]\+@163\.com/user@example.com/g' "$file" 2>/dev/null
done

# 2. 移除 Telegram ID
find . -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.json" \) | while read file; do
    sed -i '' 's/6045751205/YOUR_TELEGRAM_ID/g' "$file" 2>/dev/null || sed -i 's/6045751205/YOUR_TELEGRAM_ID/g' "$file" 2>/dev/null
    sed -i '' 's/telegram:-[0-9]\+/telegram:YOUR_TELEGRAM_ID/g' "$file" 2>/dev/null || sed -i 's/telegram:-[0-9]\+/telegram:YOUR_TELEGRAM_ID/g' "$file" 2>/dev/null
done

# 3. 移除真实域名
find . -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.json" \) | while read file; do
    sed -i '' 's/ai\.zns\.cc/your-domain.com/g' "$file" 2>/dev/null || sed -i 's/ai\.zns\.cc/your-domain.com/g' "$file" 2>/dev/null
    sed -i '' 's/zns\.cc/example.com/g' "$file" 2>/dev/null || sed -i 's/zns\.cc/example.com/g' "$file" 2>/dev/null
done

# 4. 移除真实用户名
find . -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.json" \) | while read file; do
    sed -i '' 's/alshyib/your-username/g' "$file" 2>/dev/null || sed -i 's/alshyib/your-username/g' "$file" 2>/dev/null
    sed -i '' 's/dogosaka/your-username/g' "$file" 2>/dev/null || sed -i 's/dogosaka/your-username/g' "$file" 2>/dev/null
    sed -i '' 's/RrcioElise/your-github-username/g' "$file" 2>/dev/null || sed -i 's/RrcioElise/your-github-username/g' "$file" 2>/dev/null
done

echo "清理完成！"
