# ESoda's CCStopper

Kills Adobe's pesky background apps and more!

**Current Version:** v1.1.0

## v1.1.0 Changelog
- GUI Update
  - Made with a plugin from Thebateam
- Updated the update checker
- Updated the AGSKill script to create an empty AdobeGCClient folder w/ permissions denied
  - This ensures that CC cannot create a AdobeGCClient folder 

## Menu Options

**Kill all running Adobe Processess**

Does what it says, all Adobe processess will be stopped.

**Delete Adobe Genuine Software Integrity Service (AdobeGCClient)**

It first stops AGSService, then deletes the AdobeGCClient folder.

**Patch Acrobat**

Ask if the user wants to create a system restore point in case something goes wrong, then edit the registry to patch Acrobat. 

**Check for updates**

Checks if a newer version of the script is available

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
A: This script needs those permissions to stop Adobe from running in the background and to delete the AdobeGCClient folder. You should be weary of all software/scripts that ask for administrator permissions (especially Github scripts like this one). Please don't run this script if you don't know what you're doing. The full source code of this script is available in this repository.</details>

<br>

<details>
<summary>Q: Is this a virus?</summary>
<br>
A: Windows might say that it is a virus, but that is a false positive. As stated above, don't run this script if you don't trust it/know what you're doing.
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
**Issue:** "the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details."

Fix: Run ```set-executionpolicy remotesigned ``` in an admininstrator powershell window. [Credit to /u/getblownaparte on Reddit for bringing this issue up](https://www.reddit.com/r/GenP/comments/ndhm94/i_made_a_script_to_stop_all_adobe_background/gyb0twq?utm_source=share&utm_medium=web2x&context=3)

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage. There most likely will be bugs. I am not responsible for any damage or loss of data caused by this script. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _needs_ to profit off unreliable and overpriced software. Plus, Adobe will be sad :(
