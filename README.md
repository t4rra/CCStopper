# CCStopper <!-- omit in toc --> 

Stops Adobe's pesky background apps and more 😉

**Latest stable:** v1.1.3

**Latest dev:** v1.2.0-pre.2-dev

## THIS IS THE DEVELOPMENT VERSION! <!-- omit in toc -->

Please don't run any code here, unless you know *exactly* what you're doing. If you do, please consider contributing.

## Table of Contents <!-- omit in toc -->
- [v1.2.0-pre.2 Changelog](#v120-pre2-changelog)
- [Installation](#installation)
- [Features](#features)
- [FAQ](#faq)
- [Future Features](#future-features)
- [Known Issues](#known-issues)
- [Disclaimer/Notice](#disclaimernotice)

## v1.2.0-pre.2 Changelog

- UI Change
  - Added submenus and changed inputs, new system for creating menus
- Powershell Rewrite
  - Everything is in Powershell!
  - Added `functions.ps1` file, helps with code reuse
- Reversibility in modules
  - If you used the RemoveAGS module before this version, it will not be reversible.  
- Separated Hosts Patch from Credit Card Patch
  - Thanks [@sh32devnull](https://github.com/sh32devnull) for Hosts Patch
- Added HideCCFolder, DisableAutoStart, and BlockProcesses modules
  - Thanks [@ItsProfessional](https://github.com/ItsProfessional)
- Included "extra" variant
  - Includes DisableAutoStart and BlockProcesses modules. For the final 1.2.0 release, these modules (and `AcrobatPatch.ps1`) will no longer be included nor supported.
- Bug Fixes and Improvements
- Documentation Update
###### Read previous changelogs from [the releases](https://github.com/eaaasun/CCStopper/releases) <!-- omit in toc -->


## Installation

1. Get the latest [release](https://github.com/eaaasun/CCStopper/releases/latest)
2. Extract the ZIP file (This is important, CCStopper will not work without the additional scripts in the additional folders)
3. Run CCStopper.bat
4. Select an option
5. Prevent profit (for Adobe)

## Features
> Please do not list options by number if you are creating a guide that uses CCStopper. To reduce confusion, use the names of the options. Thank you.

- Stop running Adobe background processes
- Internet Patches
  - Credit Card Trial - Creates firewall rule to block the credit card prompt. See [issue #42](https://github.com/eaaasun/CCStopper/issues/42) if it does not work.
  - Add to Hosts - Blocks unnecessary Adobe servers in the hosts file.
- System Patches
  - Genuine Checker - Replaces and locks Genuine Checker files.

## FAQ
<details>
<summary>Why administrator permissions?</summary>

> This script needs those permissions to modify files and settings. CCStopper is fully open source for auditing.</details>

<details>
<summary>Is this a virus?</summary>

> Virus detections are false positives. CCStopper is fully open source for auditing.
</details>

<details>
<summary>I found a bug/issue! What do I do?</summary>

> Before submitting an issue, update to the latest version and check [the known issues](https://github.com/eaaasun/CCStopper/blob/main/README.md#known-issues) and existing issues. Please read through the issue form before submitting so the bug can be patched ASAP.
</details>

<details>
<summary>Is this available for MacOS?</summary>

> It is not available for MacOS, and I won't port it to MacOS as long as I use Windows. 
</details>

<details>
<summary>Will more features be added?</summary>

> Yes! They are in the Future Features section below. Open a discussion [here](https://github.com/eaaasun/CCStopper/discussions/new?category=feature-request) to suggest a feature.
</details>

<details>
<summary>Is there any way to support the project?</summary>

> Please donate your time! If you have Powershell/Batch knowledge, contribute to the project! If not, finding bugs and suggesting features is just as helpful!
</details>

## Future Features
Please visit the [project board](https://github.com/users/eaaasun/projects/2) to see what features are planned. If you have a suggestion, please open a discussion [here](https://github.com/eaaasun/CCStopper/discussions/new?category=feature-request).

## Known Issues
> There are more issues in the [issues](https://github.com/eaaasun/CCStopper/issues) section; these are just the most common ones.

**Issue:** Error message: `The execution of scripts is disabled on this system. Please see "Get-Help about_signing" for more details.` or selecting the "Genuine Checker" patch gives no results.

Fix: Run `Set-ExecutionPolicy RemoteSigned` in an administrator powershell window, or manually execute the `StopProcesses.ps1` script in the scripts folder once (you can use CCStopper running the script for the first time manually). [Thanks /u/getblownaparte for bringing this issue up](https://www.reddit.com/user/getblownaparte/)

---

**Issue:** Error message: `The argument '.\scripts\StopProcesses.ps1' to the -File parameter does not exist. Provide the path to an existing file as an argument to the -File parameter.` and no apps are closed.

**Fix:** Update to the latest version of the script.

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage, and offered as-is. There will be bugs. I am not responsible for any damage, loss of data, or thermonuclear wars caused by these scripts. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _need_ to profit off unreliable and overpriced software. Piracy _helps_ Adobe by increasing their market dominance. If you want to dethrone Adobe, use [alternatives](https://ass.easun.me).

<h6 align="center">Made with &lt;3, and &lt;/3 for Adobe</h6>