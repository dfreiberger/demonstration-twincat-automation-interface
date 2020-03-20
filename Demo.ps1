Set-Location $PSScriptRoot
$WorkingDirectory = $PWD

Import-Module '.\Utilities.psm1'

# Add a message filter as described in https://download.beckhoff.com/download/Document/automation/twincat3/AutomationInterface_pdf_EN.pdf
# See section 4.2.5
[EnvDteUtils.MessageFilter]::Register()

# This closes any open instances of Visual Studio
Get-Process devenv -ErrorAction SilentlyContinue | Stop-Process

$testResultsPath = "C:\TwinCAT\test.txt"
$slnPath = "$WorkingDirectory\Demonstration.sln"

# Remove the file that we will watch for later
Remove-Item $testResultsPath -Force -ErrorAction SilentlyContinue

# Create Visual Studio solution
$dte = new-object -com VisualStudio.DTE.15.0
$dte.SuppressUI = $true

Write-Output "Opening solution at $slnPath"
$sln = $dte.Solution
$sln.Open($slnPath)

# load the target project
$project = $sln.Projects.Item(1)
$systemManager = $project.Object

Write-Output "Setting project autostart"
$plcProject = $systemManager.LookupTreeItem("TIPC^Untitled1")
$plcProject.BootProjectAutostart = $true

Write-Output "Activating configuration"
$systemManager.ActivateConfiguration()

Write-Output "Restarting TwinCAT"
$systemManager.StartRestartTwinCAT() 

while (!(Test-Path $testResultsPath)) 
{ 
    Write-Output "Waiting for result file to be created by PLC"
    Start-Sleep 5
}

while ((Test-FileLock $testResultsPath)) 
{ 
    Write-Output "Waiting for result file to be released by PLC"
    Start-Sleep 5
}

Write-Output "Reading test results"
Write-Output Get-Content $testResultsPath

# This closes any open instances of Visual Studio
Get-Process devenv -ErrorAction SilentlyContinue | Stop-Process

[EnvDteUtils.MessageFilter]::Revoke()