# Migrating from/Uninstalling CCStopper <!-- omit in toc -->
 > ⚠️ CCStopper is no longer maintained. I have switched to Mac. The rest of this README will be about uninstallation/alternatives. ⚠️

 No further updates/support will be provided starting Jan. 14, 2024, and the repo will be archived on Mar. 31, 2024.

 The final version of CCStopper is [v1.3](https://github.com/eaaasun/CCStopper/releases/). It only stops Adobe processes, and will not do anything else. Previous releases are still available to download. The previous version's code is still available in the [`full` branch](https://github.com/eaaasun/CCStopper/tree/full).

## Table of Contents <!-- omit in toc -->
- [Uninstalling](#uninstalling)
  - [The Easy Way](#the-easy-way)
  - [The Hard Way](#the-hard-way)
    - [Hosts Patch](#hosts-patch)
    - [Creative Cloud App](#creative-cloud-app)
    - [Remove Genuine Checker](#remove-genuine-checker)
    - [Hide Creative Cloud Folder](#hide-creative-cloud-folder)
- [Alternatives](#alternatives)
  - [Stop Processes](#stop-processes)
  - [Hosts/CC App Patch](#hostscc-app-patch)
  - [Genuine Checker](#genuine-checker)
  - [Creative Cloud Folder in Explorer](#creative-cloud-folder-in-explorer)
- [Additional Notes/Goodbye](#additional-notesgoodbye)


# Uninstalling
## The Easy Way
Simply run each of the patches that you've applied again. There should be an option to remove the patch.
> NOTE: The web version of CCStopper no longer work. You will have to manually download CCStopper from the [releases](https://github.com/eaaasun/CCStopper/releases).

## The Hard Way
### Hosts Patch
1. Open the hosts file in a text editor. 
2. Remove all the lines between the start/end caps, and the start/end caps themselves.


   ```
   # START CCStopper Block List - DO NOT EDIT THIS LINE
   <hosts lines here>
   # END CCStopper Block List - DO NOT EDIT THIS LINE
   ```

3. Save the file.

### Creative Cloud App
1. Go to `C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\AppsPanel\`
2. Make sure you find a `AppsPanelBL.dll.bak` file. If you don't, and Creative Cloud is either not working or still shows the patched apps, you will have to reinstall Creative Cloud.
3. Delete the `AppsPanelBL.dll` file.
4. Rename `AppsPanelBL.dll.bak` to `AppsPanelBL.dll`.
5. You may have to restart your computer for the changes to take effect.

### Remove Genuine Checker

#### Restoring AdobeGenuineValidator.exe <!-- omit in toc -->
1. Go to `C:\Program Files (x86)\Adobe\Adobe Creative Cloud\Utils\`
2. Check if there is a `AdobeGenuineValidator.exe.bak` file. Additionally, check that `AdobeGenuineValidator.exe` is a 0 byte file. If either don't apply, this won't work. You should reinstall Creative Cloud to remove the Genuine Checker patch.
3. `AdobeGenuineValidator.exe` will be locked. Open the file properties, and go to the security tab. Click on `Edit`, and click `Administrators`. Uncheck the `Deny` box for everything. Click Apply to save the changes.
4. Delete the `AdobeGenuineValidator.exe` file, and rename `AdobeGenuineValidator.exe.bak` to `AdobeGenuineValidator.exe`.
  
#### Restoring AdobeGCClient Folder <!-- omit in toc -->
1. Go to `C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\`
2. Check if there is a `AdobeGCClient.bak` folder. If not, this won't work. You should reinstall Creative Cloud to remove the Genuine Checker patch.
3. `AdobeGCClient` will be locked. Open the folder properties, and go to the security tab. Click on `Edit`, and click `Administrators`. Uncheck the `Deny` box for everything. Click Apply to save the changes.
4. Delete the `AdobeGCClient` folder, and rename `AdobeGCClient.bak` to `AdobeGCClient`.

### Hide Creative Cloud Folder
1. Open the Registry Editor.
2. Go to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\`
3. Search (`CTRL+F`) for `System.IsPinnedToNameSpaceTree`
4. Change the value from `0` to `1`.
5. Restart windows explorer.

# Alternatives

## Stop Processes
The final release of CCStopper (v1.3) only stops Adobe processes. Simply download the script, right-click, then select `Run with Powershell`.

## Hosts/CC App Patch
I recommend following the guides on [genP](https://reddit.com/r/genP). They have a `CreativeCloudPatcher.bat` script that does similar things to CCStopper (Hosts patch, CC App patch)

CreativeCloudPatcher also adds to the hosts file, and like CCStopper, it may not be up-to-date with the latest address the moment Adobe updates them. I recommend you check genP's discord server for the latest URL.

## Genuine Checker
AGS can be uninstalled by running the following in an admin powershell window:
```powershell
[System.Diagnostics.Process]::Start("C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\AdobeCleanUpUtility.exe")
```
*(thanks allstart4u/genP discord)*

## Creative Cloud Folder in Explorer
[Adobe has an official guide on hiding the Creative Cloud Files folder.](https://helpx.adobe.com/ie/creative-cloud/kb/remove-cc-files-folder-shortcut-navigation-panel.html)

# Additional Notes/Goodbye
Welp, it's been a fun ride! CCStopper wouldn't have been possible without the help of the community, so thank you!

I won't be creating a CCStopper for Mac as zii seems to be dead, and the current method is just downloading a pre-patched version of the app.

Finally, I'd like to apologize to everyone with an unresolved issue. I'll try my best to help before archiving the repo, but in most cases I'll recommend the aforementioned alternatives.

<h6 align="center">Made with &lt;3, and &lt;/3 for Adobe</h6>
