# --- 1. Define Local Paths (User Profile Only) ---
$localDir = "$env:USERPROFILE\.local"
$binDir = "$localDir\bin"
$gitDir = "$localDir\git"

if (!(Test-Path $binDir)) { New-Item -ItemType Directory -Force $binDir }

# --- 2. Install Portable Git (No Admin Required) ---
if (!(Test-Path "$gitDir\cmd\git.exe")) {
    Write-Host "Downloading Portable Git..." -ForegroundColor Cyan
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-64-bit.7z.exe"
    $gitExe = "$binDir\git_portable.exe"
    
    Invoke-WebRequest -Uri $gitUrl -OutFile $gitExe
    
    Write-Host "Extracting Git to $gitDir..." -ForegroundColor Cyan
    # Extracting to User folder doesn't require Admin
    Start-Process -FilePath $gitExe -ArgumentList "-y", "-o`"$gitDir`"" -Wait
    Remove-Item $gitExe
}

# --- 3. FIX: Set Claude Code Specific Bash Path ---
# This resolves the 'requires git-bash' error
$bashPath = "$gitDir\bin\bash.exe"
if (Test-Path $bashPath) {
    # Set User-level environment variable (No Admin needed)
    [Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", $bashPath, "User")
    $env:CLAUDE_CODE_GIT_BASH_PATH = $bashPath
    Write-Host "SUCCESS: CLAUDE_CODE_GIT_BASH_PATH set to $bashPath" -ForegroundColor Green
}

# --- 4. Increase Memory Limit for Node.js (Fixes Out of Memory) ---
$env:NODE_OPTIONS = "--max-old-space-size=4096"

# --- 5. Update User PATH ---
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$gitCmdPath = "$gitDir\cmd"

if ($userPath -notlike "*$gitCmdPath*") {
    $newPath = "$gitCmdPath;$binDir;" + $userPath
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    $env:PATH = "$gitCmdPath;$binDir;" + $env:PATH
    Write-Host "User PATH updated." -ForegroundColor Green
}

# --- 6. Install Claude Code ---
Write-Host "Installing Claude Code..." -ForegroundColor Cyan
try {
    # Using the official installer within the current memory-boosted session
    irm https://claude.ai/install.ps1 | iex
} catch {
    Write-Host "Direct install failed. Attempting via NPM if available..." -ForegroundColor Yellow
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm install -g @anthropic-ai/claude-code
    }
}

# --- 7. Verification ---
Write-Host "`nVerification:" -ForegroundColor Green
git --version
Write-Host "Note: If 'claude' command is not found, restart your terminal/VS Code." -ForegroundColor Yellow