# CCStopper <!-- omit in toc --> 
Stops Adobe's pesky background apps and more 😉
## ⚠️ THIS IS THE DEVELOPMENT VERSION ⚠️ <!-- omit in toc --> 
> Please don't run any code unless you know *exactly* what you're doing. The documentation will be incomplete/inaccurate. If you do happen to know what you're doing, consider contributing!

### Version
| Release     | Version    |
|-------------|-------------|
| Stable      | v1.2.0      |
| Dev      | v1.2.1      |

## Table of Contents <!-- omit in toc -->
- [v1.2.1 Changelog](#v121-changelog)
- [Installation](#installation)
- [Features](#features)
- [FAQ](#faq)
- [New Features](#new-features)
- [Alternate Distributions/Modifications](#alternate-distributionsmodifications)
- [Known Issues](#known-issues)
- [Disclaimer/Notice](#disclaimernotice)

## v1.2.1 Changelog
- Fixed multiple exit inputs to exit bug
- Updated hosts block
  - Added an updater; it will update from hosts.txt from the data branch
  - removes the need to update CCStopper as a whole to update the hosts blocklist
- Renamed the credit card trial patch to "Firewall Blocks"
- Documentation Update
  - Removed project board (too lazy to update it)
  - Removed discussions (again, too lazy to check it, use the issues section instead)
###### Read previous changelogs from [the releases](https://github.com/eaaasun/CCStopper/releases) <!-- omit in toc -->


## Installation

1. Get the latest [release](https://github.com/eaaasun/CCStopper/releases/latest)
2. Extract the ZIP file (This is important, CCStopper will not work without the additional scripts in the additional folders. Also, antivirus may block it from running in the downloads folder.)
3. Run CCStopper.bat
4. Select an option
5. Prevent profit (for Adobe)

## Features
> Please do not list options by number (i.e. "select option 1, then run option 3") if you are creating a guide or asking a question that uses CCStopper. To reduce confusion, use the names of the options. Thank you.

> All patches are reversible by running the same patch again.

- Stop running Adobe background processes
- Internet Patches
  - Firewall Block - Creates firewall rule to block the credit card prompt. See [issue #42](https://github.com/eaaasun/CCStopper/issues/42) if it does not work.
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

> Before submitting an issue, update to the latest version and check [the issues page](https://github.com/eaaasun/CCStopper/issues) to see if your issue is there. Please read through the issue form before submitting so the bug can be patched ASAP.
</details>

<details>
<summary>Is this available for MacOS?</summary>

> It is not available for MacOS, and I won't port it to MacOS as long as I use Windows. 
</details>

<details>
<summary>Will more features be added?</summary>

> Yes! If I am actively working on features, they will be listed in the [dev branch](https://github.com/eaaasun/ccstopper/tree/dev). Open an issue [here](https://github.com/eaaasun/CCStopper/discussions/new?category=feature-request) to suggest a feature.
</details>

<details>
<summary>Is there any way to support the project?</summary>

> Please donate your time! If you have Powershell/Batch knowledge, contribute to the project! If not, finding bugs and suggesting features is just as helpful!
</details>

## New Features
> I work on new features in the dev branch. Most of the time, I'll include a section in the README with proposed changes. (there used to be a project board but i was too lazy to update it)

## Alternate Distributions/Modifications
I have no problems with this and enjoy seeing what people do with my code! Please make sure that your fork complies with this repository's license, and that the user knows it's not a modified release. Also, if you make any improvements, please consider making a pull request!

## Known Issues
> Check the [issues](https://github.com/eaaasun/CCStopper/issues) page for the latest issues. I try to respond to all of them ASAP, but this is a side project and I like to touch grass too.

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage, and offered as-is. There will be *many* bugs. I am not responsible for any damage, loss of data, or thermonuclear wars caused by these scripts. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _need_ to profit off unreliable and overpriced software. Piracy _helps_ Adobe by increasing their market dominance.

<h6 align="center">Made with &lt;3, and &lt;/3 for Adobe</h6>
