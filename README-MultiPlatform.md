# Stay - Multi-Platform Terminal Launcher

A cross-platform utility that opens a new terminal window and runs a command, keeping the window open for you to view the results.

## 🚀 Quick Start

### Universal Usage (Recommended)
```bash
# Works on all platforms
Stay echo "Hello World"
Stay ls -la
Stay python script.py
```

### Platform-Specific Usage
```bash
# Linux
./Stay-linux.sh echo "Hello World"

# macOS
./Stay-mac.sh echo "Hello World"

# Windows PowerShell
.\Stay.ps1 echo "Hello World"

# Windows CMD
Stay.bat echo "Hello World"
```

## 📁 File Structure

```
Stay_version_by_snowcatman/
├── Stay                    # Universal launcher (detects OS automatically)
├── Stay-linux.sh          # Linux version with terminal auto-detection
├── Stay-mac.sh            # macOS version using osascript
├── Stay.ps1               # Windows PowerShell version
├── Stay.bat               # Windows CMD batch version
├── Stay.sh                # Original Linux version (deprecated)
└── README-MultiPlatform.md # This file
```

## 🖥️ Platform Support

### Linux ✅
- **Auto-detects terminals**: gnome-terminal, konsole, xterm, xfce4-terminal, mate-terminal, lxterminal
- **No D-Bus dependency**: Uses fallback terminals that work reliably
- **Root support**: Works with sudo and regular users

### macOS ✅
- **Native Terminal**: Uses osascript to open Terminal.app
- **Clean execution**: Proper script cleanup and error handling

### Windows ✅
- **PowerShell**: Full-featured version with error handling
- **CMD**: Lightweight batch file version
- **Auto-selection**: Universal launcher prefers PowerShell, falls back to CMD

## 🛠️ Installation

### Option 1: Universal Installation
1. Download all files to a directory
2. Add the directory to your PATH
3. Use `Stay` command from anywhere

### Option 2: Platform-Specific
**Linux/macOS:**
```bash
chmod +x Stay
sudo cp Stay /usr/local/bin/
```

**Windows PowerShell:**
```powershell
# Add to PATH or copy to system directory
$env:PATH += ";C:\path\to\stay"
```

**Windows CMD:**
```cmd
# Add to PATH or copy to system directory
set PATH=%PATH%;C:\path\to\stay
```

## 📖 Usage Examples

### Basic Commands
```bash
Stay echo "Hello World"
Stay dir                    # Windows
Stay ls -la                 # Linux/macOS
Stay python script.py
```

### Development Commands
```bash
Stay npm start
Stay python -m http.server
Stay make build
```

### System Commands
```bash
Stay htop                   # Linux
Stay taskmgr                # Windows
Stay activity monitor       # macOS
```

## 🔧 Features

### ✨ Universal Features
- **Auto OS detection**: No need to specify platform
- **Help system**: `Stay --help` on all platforms
- **Error handling**: Clear error messages and cleanup
- **Temporary files**: Automatic cleanup of scripts

### 🎯 Platform-Specific Features

**Linux:**
- Terminal emulator auto-detection
- Multiple terminal support with fallbacks
- No D-Bus dependency issues

**macOS:**
- Native Terminal.app integration
- osascript for reliable window management

**Windows:**
- PowerShell with advanced error handling
- CMD batch for lightweight usage
- Proper Windows path handling

## 🐛 Troubleshooting

### Linux Issues
```bash
# If no terminal found, install one:
sudo apt install gnome-terminal  # Ubuntu/Debian
sudo dnf install gnome-terminal  # Fedora
```

### macOS Issues
```bash
# If osascript fails, check Terminal permissions:
# System Preferences > Security & Privacy > Privacy > Automation
```

### Windows Issues
```powershell
# Enable PowerShell scripts:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🔄 Migration from Original

If you were using the original `Stay.sh`:

1. **Keep using it**: It still works on Linux
2. **Upgrade to universal**: Use `Stay` for all platforms
3. **Platform-specific**: Use dedicated files for better features

### Key Improvements
- ✅ **No more D-Bus errors** on Linux
- ✅ **Windows support** (PowerShell + CMD)
- ✅ **macOS support** with native Terminal
- ✅ **Better error handling** across all platforms
- ✅ **Auto terminal detection** on Linux

## 🤝 Contributing

### Adding New Platforms
1. Create `Stay-{platform}.sh` or `Stay-{platform}.ps1`
2. Update the universal `Stay` launcher
3. Add tests and documentation

### Adding Terminal Support
Edit `Stay-linux.sh` and add your terminal to the `detect_terminal()` function.

## 📄 License

Same as original project - see LICENSE file for details.

## 🙏 Acknowledgments

- Original Stay script by Derek Taylor and contributors
- Enhanced and made cross-platform by snowcatman
- Community feedback and testing
