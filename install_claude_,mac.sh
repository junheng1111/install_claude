#!/bin/bash

# --- 1. Define Paths ---
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# --- 2. Check & Install Xcode Command Line Tools ---
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    # This triggers the GUI installer. 
    # Note: Completely silent CLI install is difficult without sudo/softwareupdate, 
    # but this is the standard approach for macOS.
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
    if [[ -n "$PROD" ]]; then
        softwareupdate -i "$PROD" --verbose
    else
        echo "Please install Xcode Tools manually: xcode-select --install"
        exit 1
    fi
else
    echo "Xcode Command Line Tools are already installed."
fi

# --- 3. Check & Install Homebrew ---
echo "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    # Official Homebrew install script (Non-interactive mode)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
    
    # Set up Homebrew environment for the current session (Apple Silicon vs Intel)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed: $(brew --version | head -n 1)"
fi

# --- 4. Check & Install Git ---
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing via Homebrew..."
    brew install git
else
    echo "Git is already installed: $(git --version)"
fi

# --- 5. Update Environment Variables ---
# Determine shell config file
case "$SHELL" in
    */zsh)  SHELL_CONFIG="$HOME/.zshrc" ;;
    */bash) SHELL_CONFIG="$HOME/.bash_profile" ;;
    *)      SHELL_CONFIG="$HOME/.profile" ;;
esac

# Ensure Homebrew and Local Bin are in PATH for future sessions
{
    if ! grep -q "$LOCAL_BIN" "$SHELL_CONFIG" 2>/dev/null; then
        echo "export PATH=\"$LOCAL_BIN:\$PATH\"" >> "$SHELL_CONFIG"
    fi
    # Add Homebrew setup to shell config if brew was just installed
    if command -v brew &> /dev/null && ! grep -q "brew shellenv" "$SHELL_CONFIG" 2>/dev/null; then
        echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> "$SHELL_CONFIG"
    fi
} 

# Update current session PATH
export PATH="$LOCAL_BIN:$PATH"

# --- 6. Install Claude Code ---
echo "Installing Claude Code..."
# Claude Code typically requires Node.js/NPM. 
# If the curl method is used, ensure it handles the install.
curl -s https://claude.ai/install.sh | sh

# --- 7. Verification ---
echo -e "\n--- Final Verification ---"
echo "Git: $(git --version)"
if command -v brew &> /dev/null; then
    echo "Brew: $(brew --version | head -n 1)"
fi

if command -v claude &> /dev/null; then
    echo "Claude Code: $(claude --version)"
else
    echo "Note: If 'claude' command is not found, run: source $SHELL_CONFIG"
fi
