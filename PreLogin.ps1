#Uninstall Old Versions
$ListOfUninstallers = @(Get-ChildItem -path "C:\Program Files (x86)\Microsoft OneDrive" -Include "OneDriveSetup.exe" -ErrorAction silentlycontinue -Recurse).FullName
ForEach ($Uninstaller in $ListOfUninstallers) {&"$Uninstaller" /uninstall /allusers | Out-Null}

#Install Latest Version
If ($PSScriptRoot -eq "") {$Path = Convert-Path (Get-Location).Path} Else {$Path = $PSScriptRoot}
If ($Path.Substring($Path.Length-1) -eq "\") {$Path = $Path.Substring(0,$Path.Length-1)}
$Installer = "$Path`\OneDriveSetup.exe"
&"$Installer" /AllUsers | Out-Null
