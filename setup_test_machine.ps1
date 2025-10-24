Write-Host "Starting setup." -ForegroundColor DarkGreen

Write-Host
Write-Host "Creating junction for cwoodwar user profile." -ForegroundColor DarkYellow

# Create a junction 'C:\Users\cwoodwar' pointing to the actual user profile directory.
$userDir = [System.Environment]::GetFolderPath("UserProfile")
$cwoodwarDir = Join-Path (Split-Path -Path $userDir -Parent) "cwoodwar"
if (-not (Test-Path $cwoodwarDir)) {
    Write-Host "Creating junction '$cwoodwarDir' -> '$userDir'"
    New-Item -Path $cwoodwarDir -Type Junction -Target $userDir -Force
}
else {
    Write-Host "Junction '$cwoodwarDir' already exists."
}

# Create necessary directories in user profile.
Write-Host
Write-Host "Creating directories in user profile." -ForegroundColor DarkYellow

$dirs = @("$userDir\DFD", "$userDir\Models", "$userDir\Source", "$userDir\WPR")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        Write-Host "Creating directory: '$dir'"
        mkdir $dir -Force
    }
    else {
        Write-Host "Directory already exists: '$dir'"
    }
}

# Pin directories to Quick Access.
Write-Host
Write-Host "Pinning directories to Quick Access." -ForegroundColor DarkYellow

$pins = @($userDir) + $dirs + 'C:\ProgramData'; $pins
foreach ($dir in $pins) {
    Write-Host "Pinning '$dir' to Quick Access"
    $shell = New-Object -ComObject Shell.Application
    $folder = $shell.Namespace($dir)
    $folder.Self.InvokeVerb("pintohome")
}

# Install applications using winget.
Write-Host
Write-Host "Installing applications." -ForegroundColor DarkYellow

foreach ($app in @("Microsoft.PowerShell", "7zip.7zip", "vim.vim", "Microsoft.Sysinternals.Suite")) {
    if (-not (winget list --id $app -q)) {
        Write-Host "Installing '$app'."
        winget install $app --silent --accept-source-agreements --accept-package-agreements
    }
    else {
        Write-Host "'$app' is already installed."
    }
}

# Update Path environment variable.
Write-Host
Write-Host "Updating Path environment variable." -ForegroundColor DarkYellow

$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "x64" }
Write-Host "Architecture '$env:PROCESSOR_ARCHITECTURE' is '$arch'"

$programFiles = [System.Environment]::GetFolderPath("ProgramFiles")
$installDirs = @("$programFiles\7-Zip\", "$programFiles\Vim\", "$programFiles (x86)\Windows Kits\10\Debuggers\$arch\")

foreach ($dir in $installDirs) {
    $newPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")

    if (-not ($newPath -like "*$dir*")) {
        Write-Host "Adding '$dir' to Path."
        [System.Environment]::SetEnvironmentVariable("Path", $newPath + ";$dir", "Machine")
    }
    else {
        Write-Host "'$dir' is already in Path."
    }
}

write-Host
Write-Host "Setup complete." -ForegroundColor DarkGreen
