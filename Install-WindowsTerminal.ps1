Write-Output "Checking windows version"
$WindowsVersion = (Get-ComputerInfo).WindowsVersion

if ($WindowsVersion -lt 1903){
    Write-Error "Your windows version is $WindowsVersion, the minimal requirement is 1903. Please update your windows"
    break 
}
Write-Output "Downloading winget installer"
$UserName = $env:UserName
$Location = "C:\Users\$UserName\Downloads"
$WingetInstallerPath = "$Location\winget.appxbundle"

Set-Location $Location

Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/download/v-0.2.10191-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle' -OutFile $WingetInstallerPath -UseBasicParsing
if ($WingetInstallerPath) {
    Write-Output "Winget successfully downloaded. Starting installation"
}
else{
    Write-Error "Winget is not downloaded"
    break
}

start-process $WingetInstallerPath
$InstallerProcess = Get-Process -ProcessName 'AppInstaller'
$InstallerProcess.WaitForExit()

Write-Output "Removing winget installer file"
Remove-Item $WingetInstallerPath

Write-Output "Installing Windows Terminal using Winget"
Invoke-expression 'cmd /c start powershell -Command {
    if (winget){
        winget install --id=Microsoft.WindowsTerminal -e
    }
    else{
        write-error "Winget is not installed. Installation cannot proceed without winget"
    }; Read-Host "Push Enter to exit"}'

