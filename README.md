# CCStopper <!-- omit in toc --> 

Stops Adobe's pesky background apps and more 😉

### Version
| Released Variant     | Ver. Num    |
|-------------|-------------|
| Stable      | v1.2.0      |

## Table of Contents <!-- omit in toc -->
- [v1.2.0 Changelog](#v120-changelog)
- [Installation](#installation)
- [Features](#features)
- [FAQ](#faq)
- [Future Features](#future-features)
- [Known Issues](#known-issues)
- [Disclaimer/Notice](#disclaimernotice)

## v1.2.0 Changelog

- UI Change
  - Added submenus and changed inputs, new system for creating menus
- Powershell Rewrite
  - Everything is in Powershell!
  - Added `functions.ps1` file, helps with code reuse
- Reversibility in modules
  - If you used the RemoveAGS module before this version, it will not be reversible.  
- Separated Hosts Patch from Credit Card Patch
  - Thanks [@sh32devnull](https://github.com/sh32devnull) for Hosts Patch
- Added HideCCFolder module
  - Thanks [@ItsProfessional](https://github.com/ItsProfessional)
- Bug Fixes and Improvements
- Documentation Update
###### Read previous changelogs from [the releases](https://github.com/eaaasun/CCStopper/releases) <!-- omit in toc -->


## Installation

1. Get the latest [release](https://github.com/eaaasun/CCStopper/releases/latest)
2. Extract the ZIP file (This is important, CCStopper will not work without the additional scripts in the additional folders. Also, antivirus may block it from running in the downloads folder.)
3. Run CCStopper.bat
4. Select an option
5. Prevent profit (for Adobe)

## Features
> Please do not list options by number if you are creating a guide or asking a question that uses CCStopper. To reduce confusion, use the names of the options. Thank you.

> All patches are reversible by running the same patch again.

- Stop running Adobe background processes
- Internet Patches
  - Credit Card Trial - Creates firewall rule to block the credit card prompt. See [issue #42](https://github.com/eaaasun/CCStopper/issues/42) if it does not work.
  - Add to Hosts - Blocks unnecessary Adobe servers in the hosts file.
- System Patches
  - Genuine Checker - Replaces and locks Genuine Checker files.
  - Hide CCFolder - Hides the Creative Cloud folder in Windows Explorer.

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
> Please visit the [project board](https://github.com/users/eaaasun/projects/2) to see what features are planned. If you have a suggestion, please open a discussion [here](https://github.com/eaaasun/CCStopper/discussions/new?category=feature-request).

## Known Issues
> Check the [issues](https://github.com/eaaasun/CCStopper/issues) page for the latest issues. The [project board](https://github.com/users/eaaasun/projects/2) has a verified list of bugs, so it may not be up to date.

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage, and offered as-is. There will be *many* bugs. I am not responsible for any damage, loss of data, or thermonuclear wars caused by these scripts. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _need_ to profit off unreliable and overpriced software. Piracy _helps_ Adobe by increasing their market dominance.

<h6 align="center">Made with &lt;3, and &lt;/3 for Adobe</h6>
