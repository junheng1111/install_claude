# 1. 安装 Claude Code
irm https://claude.ai/install.ps1 | iex

# 2. 将 ~/.local/bin 添加到用户 PATH（无需管理员权限）
$newPath = "$env:USERPROFILE\.local\bin"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)

if ($currentPath -notlike "*$newPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$newPath", [EnvironmentVariableTarget]::User)
    Write-Host "✅ PATH 已更新" -ForegroundColor Green
} else {
    Write-Host "ℹ️  PATH 已包含该路径，无需重复添加" -ForegroundColor Yellow
}

# 3. 在当前会话中立即生效
$env:PATH = "$env:PATH;$newPath"

Write-Host "✅ 完成！运行 'claude --version' 验证安装" -ForegroundColor Green
