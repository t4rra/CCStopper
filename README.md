# CCStopper <!-- omit in toc --> 
Stops Adobe's pesky background apps and more 😉

> ## ⚠️This is the development version of CCStopper!⚠️ <!-- omit in toc -->
> Don't run code from this branch unless you know exactly what you're doing. Consider contributing if you do!



### Version
| Release     | Version    |
|-------------|-------------|
| Stable      | v1.2.2-hotfix.1      |
| Dev      | v1.2.3-pre.1      |

## Table of Contents <!-- omit in toc -->
- [v1.2.3 Changelog \[under development\]](#v123-changelog-under-development)
- [Installation](#installation)
    - [One-Line Install/Run](#one-line-installrun)
    - [Manual Install](#manual-install)
- [Features](#features)
- [FAQ](#faq)
- [Adding Entries to Hosts Blocklist](#adding-entries-to-hosts-blocklist)
- [New Features](#new-features)
- [Alternate Distributions/Modifications](#alternate-distributionsmodifications)
- [Known Issues](#known-issues)
- [Disclaimer/Notice](#disclaimernotice)

## v1.2.3 Changelog [under development]
- Combined everything into one file
- One-line install/run 
  - thanks [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) for the idea
  - see [below](#one-line-installrun) for commands
- Hosts file module improved to write/remove addresses more reliably 
###### Read previous changelogs from [the releases](https://github.com/eaaasun/CCStopper/releases) <!-- omit in toc -->


## Installation

#### One-Line Install/Run
> Run as admin for installing or creating a desktop shortcut.
<!-- table -->
| Command | Description |
|-------------|-------------|
| `irm https://ccstopper.netlify.app/run \| iex`      |  Runs CCStopper once.      |
| `irm https://ccstopper.netlify.app/shortcut \| iex`      |  Creates desktop shortcut that runs the command above. Needs internet to work, but always up-to-date.      |
| `irm https://ccstopper.netlify.app/install \| iex`      |  Installs CCStopper and creates a desktop shortcut. Works offline, however it won't automatically update.      |


#### Manual Install
1. Get the latest [release](https://github.com/eaaasun/CCStopper/releases/latest)
2. Extract the ZIP file (This is important, CCStopper may not work without additional files.)
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
  - Genuine Checker - Locks Genuine Checker files.
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

## Adding Entries to Hosts Blocklist
The `data` branch of CCStopper contains a `hosts.txt` file that has a list of addresses that CCStopper will block. If you think an address from adobe should be blocked, open a pull request with the address added to the bottom of the list. Also state why the address should be added to the hosts block.
## New Features
I work on new features in the dev branch. Most of the time, I'll include a section in the README with proposed changes. (there used to be a project board but i was too lazy to update it)

## Alternate Distributions/Modifications
> I cannot offer any support for CCStopper unless it's a release from this repository.

I have no problems with this and enjoy seeing what people do with my code! Please make sure that your fork complies with this repository's license, and that the user knows it's not a modified release. Also, if you make any improvements, please consider making a pull request!

## Known Issues
Check the [issues](https://github.com/eaaasun/CCStopper/issues) page for the latest issues. I try to respond to all of them ASAP, but this is a side project and I like to touch grass too.

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage, and offered as-is. There will be *many* bugs. I am not responsible for any damage, loss of data, or thermonuclear wars caused by these scripts. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _need_ to profit off unreliable and overpriced software. Piracy _helps_ Adobe by increasing their market dominance.

<h6 align="center">Made with &lt;3, and &lt;/3 for Adobe</h6>
