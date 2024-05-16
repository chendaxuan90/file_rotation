# Rotation by powershell script
A collection of useful PowerShell scripts.

# Usage:
Double-click or right-click and select "Run with PowerShell".

This script checks the path where the rotation script saves the file. Ensure that the script is saved in the correct location where you want the rotation to occur.

The rotation script will examine the file creation time and file name. Old files will be moved to another folder, with the default folder name being "0.0 Old".

# File Rotation Script:
The default rotation cycle is one month. You can change this by editing the script.
*Future upgrades are planned.

When the file rotation runs, it will create a new folder within "0.0 Old". This new folder will be named with a timestamp in the format yyyyMMdd. A new log file will also be created, named with a timestamp in the format yyyyMMddHHmmss. The log file will record the moved files.

# Log Rotation Script:
Old log files will be moved to the archive folder, with the default archive folder named "Log Backup" within the "0.0 Old" folder.
