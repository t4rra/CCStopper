# CCStopper <!-- omit in toc --> 
Stops Adobe's pesky background apps and more 😉

### Version
| Release     | Version    |
|-------------|-------------|
| Stable      | v1.2.2-hotfix.1      |
| Web      | v1.3.0-pre.1      |
| Dev      | v1.3.0-pre.1      |

## Table of Contents <!-- omit in toc -->
- [v1.3.0-pre.1 Changelog](#v130-pre1-changelog)
- [v1.2.2 Changelog](#v122-changelog)
  - [hotfix.1 Changelog](#hotfix1-changelog)
- [Installation](#installation)
- [Features](#features)
- [FAQ](#faq)
- [Adding Entries to Hosts Blocklist](#adding-entries-to-hosts-blocklist)
- [New Features](#new-features)
- [Alternate Distributions/Modifications](#alternate-distributionsmodifications)
- [Known Issues](#known-issues)
- [Disclaimer/Notice](#disclaimernotice)

## v1.3.0-pre.1 Changelog
> [Visit the dev readme for updated documentation](https://github.com/eaaasun/CCStopper/tree/dev). 
- Combined everything into one file
- One-line install/run 
  - thanks [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) for the idea
  - see [the dev branch documentation](https://github.com/eaaasun/CCStopper/tree/dev) for commands
- The hosts file module write/remove addresses in a different way
  - it *should* migrate old entries, but it hasn't been extensively tested
  - ***known bug***: if the [hosts list](https://github.com/eaaasun/CCStopper/blob/data/Hosts.txt) has a new entry and system's hosts file don't have the new entry, CCStopper will only give option to remove entries from hosts file. this doesn't apply if ccstopper is installed (via one-line command or zip file)
  - ***fix***: if the hosts block stops working try removing and then adding the hosts block back. 
- New module for patching the creative cloud app 
  - credit to AbsentForeskin on the genP discord
  - requires restart after patching
- Created logo for shortcut icons (its very original trust)
## v1.2.2 Changelog
- Updated user messages in `RemoveAGS.ps1` to be more descriptive
- Firewall names are more descriptive
  - to update them, run the `Firewall Block` option again. 

### hotfix.1 Changelog
- Removed mentions of "InternetBlock" in menus of `FirewallBlock.ps1`
  - Firewall rules will still show "InternetBlock" in the name, can't change because backwards compatibility
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
