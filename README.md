# CCStopper

Kills Adobe's pesky background apps and more!

**Current Version:** v1.1.2

## v1.1.2 Changelog

- UI Change
  - Replace button plugin (thanks [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) for UI ~~ripoff~~ inspiration)
- Added Credit Card Stop Module
  - Creates a firewall rule that blocks `Adobe Desktop Service.exe` from accessing the internet
  - Blocking ADS bypasses the credit card prompt (confirmed working as of Apr. 4, 2022; subject to change in the future)
- Documentation Update
  - Changed some things, added a "Future Features" section. If you have batch scripting knowledge, please take a look and see what you can do.

###### Read previous changelogs from [the releases](https://github.com/E-Soda/CCStopper/releases) <!-- omit in toc -->

###### Read previous changelogs from [the releases](https://github.com/E-Soda/CCStopper/releases)

## Instructions

1. Get the latest [release](https://github.com/E-Soda/CCStopper/releases)
2. Extract the ZIP file (This is important, CCStopper will not work without the additional scripts and plugins in the additional folders)
3. Run CCStopper.bat
4. Select an option
5. Profit


## Menu Options

<details>
<summary>End Adobe Processes</summary>
<br>
Does what it says, all Adobe processes will be stopped.
</details>

<details>
<summary>Remove AGS</summary>
<br>
Clears the AdobeGCClient (genuine checker) folder and changes its permissions so that it cannot be modified by applications.
</details>

<details>
<summary>Patch Acrobat</summary>
<br>
Run "Remove AGS" before proceeding. 

This function edits the registry to patch Acrobat. Will ask if you want to create a restore point in the case that registry patching fails catastrophically. Automates <a href="https://www.reddit.com/r/GenP/wiki/redditgenpguides#wiki_guide_.2310_-_adobe_acrobat_pro_dc_.28standalone.2Fcc-less.29">this</a> guide.
</details>

## FAQ

<details>
<summary>Q: It asks for administrator permissions?</summary>
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

A: Update to the latest version. If the issue presists, check the open issues and [the known issues](https://github.com/E-Soda/CCStopper/blob/main/README.md#known-issues) for any issues that I am aware of. If it's not there, open up an issue describing your problem and how to reproduce it. I'll work on it as soon as I can.

</details>

<br>

<details>
<summary>Q: Is this available for MacOS?</summary>
<br>
A: It is not currently available for MacOS, and I don't intend on porting it to MacOS. Community ports are welcome, but please credit accordingly.
</details>

<br>

<details>
<summary>Q: Will more features be added?</summary>
<br>
A: Yes! They are all in the Future Features section below. Any help with the future features is greatly appreciated!
</details>
<br>

<details>
<summary>Q: Will this affect Adobe apps in any negative way?</summary>
<br>
A: No, it won't. If you do have Adobe apps (Photoshop, After Effects, etc.) open, it will close them if you decide to end Adobe processes. Other than that, everything should work normally. Please open an issue if this is not the case.
</details>
<br>

<details>
<summary>Q: Is there any way to support the project?</summary>
<br>
A: Please donate your time! If you have batch scripting knowledge, please look through the Future Features section below and see what you can contribute. Financial donations are not accepted at the moment.
</details>
<br>

## Future Features
> These are features that I'd like to implement in the future. If you can help, please open a thread in the discussions tab, under the "Development" category, or if you have code already, open a pull request! 

- [ ] Patch Retention
  - Locks the patched file from genP so that nothing can modify/delete it
  - I'm stuck at setting a list of filepaths that the script can read off and patch.
- [ ] Revamp the ProcessKill script
  - Currently, the script stops any process that mentions `Adobe` in its `Company Name` attribute. It is a "'shotgun' approach" as stated by [the creator](https://gist.github.com/carcheky/530fd85ffff6719486038542a8b5b997#gistcomment-3586740) of the command. It'll kill any CC app (Photoshop, Premiere, etc.) running, destroying unsaved work.
  - Getting individual processes and blocking them is unfeasible, as Adobe changes that every time they sneeze
- [ ] Running in background
  - tbh i have no idea where to even start with this
  - Goal: have an option to run the ProcessKill script every set interval 
- [ ] Converting ProcessKill module to a batch script
  - Done by running powershell commands from a batch script
  - i'm just too lazy to do this lmao
- [ ] Backup documentation/scripts
  - Host on my own website?
## Known Issues

---

**Issue:** Error message: `the execution of scripts is disabled on this system. Please see "get-help about_signing" for more details.` or pushing the "Remove AGS" button gives no results.

Fix: Run `set-executionpolicy remotesigned` in an admininstrator powershell window, or manually execute the `ProcessKill.ps1` script in the scripts folder once (you can use CCStopper running the script for the first time manually). [Credit to /u/getblownaparte on Reddit for bringing this issue up](https://www.reddit.com/r/GenP/comments/ndhm94/i_made_a_script_to_stop_all_adobe_background/gyb0twq?utm_source=share&utm_medium=web2x&context=3)

---

**Issue:** Error message: `The argument '.\scripts\ProcessKill.ps1' to the -File parameter does not exist. Provide the path to an existing file as an argument to the -File parameter.` and no apps are closed.

**Fix:** Update to the latest version of the script. There might be an additional prompt when you end Adobe processes, enter `a` if prompted.

---

**Issue:** Error message: `The target registry key cannot be found, or it has been edited already. Cannot proceed with Acrobat fix.` and there is no value in the registry.

**Fix:** Create a DWORD value (in the registry) called `IsAMTEnforced` with a value of 1. You will not need to patch Acrobat with the script after this.

---

**Issue:** Resizing the command window breaks buttons.

**Fix:** This is an issue with the GUI button plugin, please refrain from resizing the window. An update will be released if there is a fix.

---

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage, and offered as-is. There will be bugs. I am not responsible for any damage or loss of data caused by this script. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _needs_ to profit off unreliable and overpriced software. Piracy _helps_ Adobe by increasing their market dominance. If you want to dethrone Adobe, use [alternatives](https://ass.easun.me).

<h6 align="center">Made with &lt;3 from easun and &lt;/3 for Adobe</h6>
