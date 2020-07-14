# LogonScreenInstaller

This script... or should I say collection of scripts... is so we can install an item at the logon screen before a user logs in. They also try to prevent the user from logging in until the installation is complete.

The reason for creating this method is that our OneDrive clients, which we install to all users, were having difficulty updating to the latest version... even if we scripted it to install in the background the application would have closed and not restarted under the user session... personally I didn't like the idea of potential data loss, so I wondered what could be done about it.

This install method works as follows:

The batch file (Install.cmd) is executed first, this requires psexec https://docs.microsoft.com/en-us/sysinternals/downloads/psexec so it can run our next script visibly at the logon screen.

The Autoit file (LogonScreenInstaller.au3, which you will need to convert to LogonScreenInstaller.exe https://www.autoitscript.com/site/autoit/), is the program that is run by the batch file, it's job is to inform the user that software is installing (which is does by displaying Message.jpg on the screen) covering up the username and password field, run our PowerShell script to install some software (in this example OneDrive) and disable use of the keyboard and mouse to try and prevent a user from logging on while we are still installing.

Please note, Ctrl-Alt-Del as a safety feature does allow you to regain control of the mouse and keyboard again but you will be unable to move the splash screen, it will disappear when the PowerShell script is finished.

The PowerShell script (PreLogin.ps1) requires the software you wish to install (OneDriveSetup.exe https://support.microsoft.com/en-us/office/onedrive-release-notes-845dcf18-f921-435e-bf28-4e24b95e5fc0), it then runs though an uninstallation cycle of any older versions of OneDrive within the C:\Program Files (x86)\Microsoft OneDrive folder. After that it will install OneDriveSetup for all users.

Please note that you can amend the PowerShell script with different coding, and change the Message.jpg if you don't want to install OneDrive but another program.

All of the files listed should be kept in the same directory...

Install.cmd<br>
Psexec.exe<br>
LogonScreenInstaller.exe (i.e. the complied .au3 file)<br>
Message.jpg<br>
PreLogin.ps1<br>
OneDriveSetup.exe (i.e. the installer wish to install)

You can then setup your deployment method to run Install.cmd

My method for deployment was MECM (aka SCCM), so the detection method I used for installation of OneDrive was for the Version key in
HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\OneDrive to be greater than or equal to that of the installer (so in my case 20.084.0426.0007).

If unlike me however you are just distributing by say a GPO bootup script, you could change Install.cmd from

`psexec.exe -accepteula -s -h -x "%~dp0LogonScreenInstaller.exe"`<br>
to<br>
`If Not Exist "C:\Program Files (x86)\Microsoft OneDrive\20.084.0426.0007" psexec.exe -accepteula -s -h -x "%~dp0LogonScreenInstaller.exe"`
