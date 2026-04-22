# Install Claude Code
irm https://claude.ai/install.ps1 | iex

# Add ~/.local/bin to user PATH (no admin required)
$newPath = "$env:USERPROFILE\.local\bin"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)

if ($currentPath -notlike "*$newPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$newPath", [EnvironmentVariableTarget]::User)
    Write-Host "PATH updated." -ForegroundColor Green
} else {
    Write-Host "PATH already contains the directory, skipping." -ForegroundColor Yellow
}

# Apply to current session immediately
$env:PATH = "$env:PATH;$newPath"

Write-Host "Done! Run 'claude --version' to verify installation." -ForegroundColor Green
