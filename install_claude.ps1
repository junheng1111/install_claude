# --- 1. Define Paths ---
$localBin = "$env:USERPROFILE\.local\bin"
$gitDir = "$localBin\git"
if (!(Test-Path $localBin)) { New-Item -ItemType Directory -Force $localBin }

# --- 2. Install Git Portable (No Admin Required) ---
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Downloading Portable edition..." -ForegroundColor Cyan
    
    # Official Git for Windows Portable Link
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/PortableGit-2.44.0-64-bit.7z.exe"
    $exePath = "$localBin\git_portable.exe"

    # Download via PowerShell
    Invoke-WebRequest -Uri $gitUrl -OutFile $exePath
    
    Write-Host "Extracting Git to $gitDir..." -ForegroundColor Cyan
    # -y: Yes to all, -o: Output directory
    Start-Process -FilePath $exePath -ArgumentList "-y", "-o`"$gitDir`"" -Wait
    
    # Clean up the installer
    Remove-Item $exePath
}

# --- 3. Update Environment Variables ---
# Git binary is located in the 'cmd' subdirectory of the portable folder
$gitBinPath = "$gitDir\cmd"
$currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)

$requiredPaths = @($localBin, $gitBinPath)
$updatedPath = $currentPath

foreach ($path in $requiredPaths) {
    if ($updatedPath -notlike "*$path*") {
        $updatedPath = "$path;$updatedPath"
    }
}

if ($updatedPath -ne $currentPath) {
    [Environment]::SetEnvironmentVariable("PATH", $updatedPath, [EnvironmentVariableTarget]::User)
    Write-Host "User PATH updated successfully." -ForegroundColor Green
}

# Apply to the current session immediately
foreach ($path in $requiredPaths) {
    if ($env:PATH -notlike "*$path*") {
        $env:PATH = "$path;$env:PATH"
    }
}

# --- 4. Install Claude Code ---
Write-Host "Installing Claude Code..." -ForegroundColor Cyan
irm https://claude.ai/install.ps1 | iex

# --- 5. Verification ---
Write-Host "`nVerification:" -ForegroundColor Green
git --version
claude --version
