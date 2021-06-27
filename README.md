# CCStopper

Kills Adobe's pesky background apps and more!

**Current Version:** v1.1.0

## v1.1.0 Changelog
- GUI Update
  - Made with a plugin from Thebateam
- Updated the update checker
- Updated the AGSKill script to create an empty AdobeGCClient folder w/ permissions denied
  - This ensures that CC cannot create a AdobeGCClient folder 
###### Read previous changelogs from [the releases](https://github.com/E-Soda/CCStopper/releases)
## Menu Options

**End Adobe Processes**

Does what it says, all Adobe processes will be stopped.

**Remove AGS**

It first stops AGSService, then clears the AdobeGCClient folder and changes its permissions so that it cannot be modified by the system.

**Patch Acrobat**

Edits the registry to patch Acrobat. 

**Check for updates**

Checks if a newer version of the script is available.

## Instructions

1. Get the latest [release](https://github.com/E-Soda/CCStopper/releases)
2. Extract the ZIP file (This is important, CCStopper will not work without the additional scripts and plugins in the additional folders)
3. Run CCStopper.bat
4. Select an option
5. Done!

## FAQ

<details>
<summary>Q: It asks for administrator permissions????</summary>
<br>
A: This script needs those permissions to stop Adobe from running in the background and to delete the AdobeGCClient folder. The full source code of this script is available in this repository for auditing.</details>

<br>

<details>
<summary>Q: Is this a virus?</summary>
<br>
A: Windows might say that it is a virus, but that is a false positive. As stated above, the full source code for this script is avaliable for auditing.
</details>

<br>

<details>
<summary>Q: I found a bug/issue! What do I do?</summary>
<br>

A: First check [the known issues](https://github.com/E-Soda/CCStopper/blob/main/README.md#known-issues) for any issues that I am aware of. If your issue is not there, open up an issue describing your issue and how to reproduce it, and I'll work on it as soon as I can.
</details>

<br>

<details>
<summary>Q: Is this available for MacOS?</summary>
<br>
A: It is not currently available for MacOS, and I do not intend on porting it to MacOS. If anyone in the community would like to port this to MacOS, feel free to do so!
</details>

<br>

<details>
<summary>Q: Will more features be added?</summary>
<br>
A: Yes! If you have any suggestions, please open an issue.
</details>
<br>

<details>
<summary>Q: Will this affect Adobe apps in any way?</summary>
<br>
A: No, it won't. If you do have Adobe apps (Photoshop, After Effects, etc.) open, it will close them if you decide to end Adobe processes. Other than that, everything should work normally. Please open an issue if this is not the case.
</details>
<br>

## Known Issues
******
**Issue:** Error message: `the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.`

Fix: Run `set-executionpolicy remotesigned` in an admininstrator powershell window. [Credit to /u/getblownaparte on Reddit for bringing this issue up](https://www.reddit.com/r/GenP/comments/ndhm94/i_made_a_script_to_stop_all_adobe_background/gyb0twq?utm_source=share&utm_medium=web2x&context=3)
******
**Issue:** Error message: `The argument '.\scripts\ProcessKill.ps1' to the -File parameter does not exist. Provide the path to an existing file as an argument to the -File parameter.` and no apps are closed.

**Fix:** Update to the latest version of the script. There might be an additional prompt when you end Adobe processes, enter `a` if prompted.
******
**Issue:** Error message: `The target registry key cannot be found, or it has been edited already. Cannot proceed with Acrobat fix.` and there is no value in the registry.

**Fix:** Create a DWORD value called `IsAMTEnforced` with a value of 1. You will not need to patch Acrobat with the script after this. 
******
**Issue:** Resizing the command window breaks buttons.

**Fix:** This is an issue with the GUI button plugin, please refrain from resizing the window. I've included a separate version of the script called `CCStopper-CMD` that keeps the keyboard input instead of the button input.
******
## Disclaimer/Notice

**Disclaimer:** This script is in an early stage. There most likely will be bugs. I am not responsible for any damage or loss of data caused by this script. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _needs_ to profit off unreliable and overpriced software. Plus, Adobe will be sad :(

###### Made by esoda