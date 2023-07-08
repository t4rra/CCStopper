# CCStopper <!-- omit in toc -->
## Table of Contents <!-- omit in toc -->

- [Features/Modules](#featuresmodules)
- [Run/Install](#runinstall)
- [v1.2.3-pre.2 changelog](#v123-pre2-changelog)
- [Contributing](#contributing)
  - [Issues](#issues)
  - [Alternate Distributions/Modifications](#alternate-distributionsmodifications)
  - [Adding Entries to Hosts Blocklist](#adding-entries-to-hosts-blocklist)
- [Disclaimer/Notice](#disclaimernotice)

## Features/Modules

> Every module is reversible by running it again.

- Stop Background Processes
- Add to Hosts
- System Patches
  - Patch Creative Cloud App Buttons
  - Lock Genuine Checker Folder
  - Hide Creative Cloud Folder in Explorer

## Run/Install

### Powershell - v1.2.3+ Only <!-- omit in toc -->

> ⚠️ By using the commands below, you're running code that can be compromised/broken/changed anytime. Proceed with caution. ⚠️

- Run CCStopper once.
  ```
  irm https://ccstopper.netlify.app/run | iex
  ```

- Create a desktop shortcut that runs the command above. 
  ```
  irm https://ccstopper.netlify.app/shortcut | iex
  ```

- Saves CCStopper locally and creates a desktop shortcut. Works offline, however it won't automatically update. Run this command again to uninstall. 
  ```
  irm https://ccstopper.netlify.app/install | iex
  ```

### Manual Install <!-- omit in toc -->

1. Get the latest [release](https://github.com/eaaasun/CCStopper/releases/latest)
2. Extract the ZIP file (This is important, CCStopper may not work without additional files.)
3. Run CCStopper.bat
4. Select an option
5. Prevent profit (for Adobe)

## v1.2.3-pre.2 changelog
- One-line install/run
  - thanks [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) for the idea
  - see [below](#one-line-installrun) for commands
- reverted pre.1's AIO changes
  - i realized an AIO version would be a nightmare to maintain
- re-written hosts block module
  - it will now update hosts file if entries already exists (fixed #80)
  - new comments surrounding entries in hosts file
  - it _should_ migrate old entries, but it hasn't been extensively tested
- New module for patching the creative cloud app
  - credit to AbsentForeskin on the genP discord
  - restart recommended after patching
- re-written the installer/online scripts to work with multiple files
- Created logo for shortcut icons (its very original trust)
- Documentation update
###### Read previous changelogs from [the releases](https://github.com/eaaasun/CCStopper/releases) <!-- omit in toc -->


## Contributing

> Want to support this project? Please donate your time! If you have Powershell/Batch knowledge, contribute to the project! If not, finding bugs and suggesting features is just as helpful!

### Issues

Found a bug? Something not working? Please open an issue! Please read through the issue form, and check for existing/closed issues before submitting.

### Alternate Distributions/Modifications

> I cannot offer any support for CCStopper unless it's a release from this repository.

I have no problems with this and enjoy seeing what people do with my code! Please make sure that your fork complies with this repository's license, and that the user knows it's a fork of CCStopper. Also, if you make any improvements, please consider making a pull request!

### Adding Entries to Hosts Blocklist

The `data` branch of CCStopper contains a `hosts.txt` file that has a list of addresses that CCStopper will block. If you think an address from adobe should be blocked, open a pull request with the address added to the bottom of the list. Also state why the address should be added to the hosts block.

## Disclaimer/Notice

**Disclaimer:** This script is in an early stage, and offered as-is. There will be _many_ bugs. I am not responsible for any damage, loss of data, or thermonuclear wars caused by these scripts. I am not affiliated with Adobe.

**Notice:** Don't use this tool for piracy. It's illegal, and multi-billion dollar companies like Adobe _need_ to profit off unreliable and overpriced software. Piracy _helps_ Adobe by increasing their market dominance.

<h6 align="center">Made with &lt;3, and &lt;/3 for Adobe</h6>
