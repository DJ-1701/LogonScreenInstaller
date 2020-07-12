#NoTrayIcon
#include <AutoItConstants.au3>
#RequireAdmin
BlockInput(1)
SplashImageOn ( "Upgrade in Progress...", @ScriptDir & "\Message.jpg", 512, 328 )
RunWait('powershell.exe -executionpolicy bypass -File "' & @ScriptDir & '\PreLogin.ps1"', @ScriptDir, @SW_HIDE)
SplashOff()
BlockInput(0)
