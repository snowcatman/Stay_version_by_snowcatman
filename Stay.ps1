#!/usr/bin/env pwsh
#
# Stay Script - PowerShell Version
# Description: Opens a new PowerShell window and runs a command, keeping the window open
# Author: snowcatman
# Version: 1.0

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$CommandArgs
)

# Function to show usage
function Show-Usage {
    Write-Host "Stay - PowerShell Version" -ForegroundColor Green
    Write-Host "Usage: Stay.ps1 <command>" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  Stay.ps1 echo 'Hello World'"
    Write-Host "  Stay.ps1 Get-Process"
    Write-Host "  Stay.ps1 python script.py"
    Write-Host ""
    Write-Host "This will open a new PowerShell window, run your command,"
    Write-Host "and keep the window open for you to view the results."
}

# Function to execute command in new window
function Invoke-StayCommand {
    param([string]$Command)
    
    if ([string]::IsNullOrWhiteSpace($Command)) {
        Show-Usage
        exit 1
    }
    
    # Create a temporary script file
    $tempScript = Join-Path $env:TEMP "stay_temp_$(Get-Random).ps1"
    
    # Build the script content
    $scriptContent = @"
# Stay Temporary Script
Write-Host "Running command: $Command" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
try {
    $Command
    Write-Host "`n----------------------------------------" -ForegroundColor Gray
    Write-Host "Command completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "`n----------------------------------------" -ForegroundColor Gray
    Write-Host "Command failed with error:" -ForegroundColor Red
    Write-Host `$_.Exception.Message -ForegroundColor Red
}
Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
`$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
"@
    
    # Write the temporary script
    $scriptContent | Out-File -FilePath $tempScript -Encoding UTF8
    
    try {
        # Start new PowerShell window with the script
        Start-Process powershell.exe -ArgumentList "-NoExit", "-File", "`"$tempScript`""
        Write-Host "New PowerShell window opened with your command." -ForegroundColor Green
    } catch {
        Write-Host "Failed to open new PowerShell window: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Main execution
if ($CommandArgs.Count -eq 0) {
    Show-Usage
    exit 1
}

# Join all arguments into a single command string
$fullCommand = $CommandArgs -join ' '

# Check for help flags
if ($fullCommand -match '^(-h|--help|help|/\?|/help)$') {
    Show-Usage
    exit 0
}

Write-Host "Stay: Opening new PowerShell window..." -ForegroundColor Cyan
Invoke-StayCommand -Command $fullCommand
