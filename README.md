<div align="center">
    <h1>BeepServ installer</h1></h1>
    <img src="Resources/Icon.png" width="125" height="125" />
</div>

## Overview
BeepServ installer is an installer for BeepServ, a small service that can be connected with Beeper Mini to provide phone number registration functionality. The installer is extremely reliable, fast and easy to use. It is a fork of [TrollInstallerX](https://github.com/alfiecg24/TrollInstallerX) with the main difference being that it installs BeepServ alongside TrollStore.

BeepServ installer supports all (almost) devices running iOS 14.0 - 16.6.1, both arm64 and arm64e. It makes use of one of two different methods to install TrollStore, depending on what device and iOS you have. These methods are:

* **Direct installation**: using the [kfd](https://github.com/felix-pb/kfd) kernel exploit, along with the [dmaFail](https://github.com/opa334/Dopamine/blob/2.x/Application/Dopamine/Exploits/dmaFail/dmaFail.c) PPL bypass on iOS 15.2+ arm64e devices.
  * Supports iOS 14.0 - 16.6.1 (arm64) and iOS 14.0 - 16.5.1 (arm64e).
    * **Note**: A15, A16, and M2 devices on iOS 16.5.1 do not support this method.
    * **Note**: A8 devices are only supported on iOS 14.0 - 15.1 for the time being.

* **Indirect installation**: Using the [kfd](https://github.com/felix-pb/kfd) kernel exploit, BeepServ installer will replace the Tips application with the TrollStore persistence helper. This method only exists due to both the lack of a PPL bypass on iOS 16.6 and above, as well as the fact that dmaFail is non-functional on A15, A16, and M2 devices on iOS 16.5.1.
  * Supports iOS 16.5.1 - 16.6.1 (arm64e).
    * **Note**: This method is the only method that supports A15, A16, and M2 devices on iOS 16.5.1.

**Note**: iOS 16.2 - 16.6.1 and iOS 15.7.2 - 15.8.2 require an internet connection in order for the installer to download the kernelcache and patchfind it.

## FAQ
> Why am I stuck at "Exploiting kernel"?

This is a common issue with the kfd exploit. Simply reboot your device and try again.

> Why can I not open/see TrollStore after a successful installation?

During installation, you will have installed a persistence helper. Open your persistence helper and press "refresh app registrations" to fix TrollStore not being able to be opened.

> Why am I getting an error about not being able to patchfind?

Either:
- You're on a non-MacDirtyCow supported version, and are not connected to the internet, or;
- You're using a Yellow iPhone 14 or Yellow iPhone 14 Plus on iOS 16.3 (20D50), in which case, [open a GitHub Issue](https://github.com/alfiecg24/beepserv-installer/issues/new/choose).

Additionally, if a file exists at `/beepserv-installer.app/kernelcache`, the installer will use that file instead of downloading the kernelcache. This can be useful if you have a slow or unreliable internet connection, or happen to have a device and version combination that has no public kernelcache available.

> Why does the installer say "failed to install persistence helper" using the indirect method?

The indirect method is not perfect, and sometimes it will fail to install the persistence helper. If this happens, simply shut down your device, turn it back on, and try again. If you repeatedly have issues with the same app, try using a different app.

## Building
This is a regular Xcode project, but the project also contains a build script. To build it and produce an IPA, simply run the `build.sh` script in the root of the project. This will build the project and produce an IPA in the root of the project.

## Credits
BeepServ installer wouldn't have been possible without the work of the following people:
* [opa334](https://x.com/opa334dev) for [Dopamine](https://github.com/opa334/Dopamine), the dmaFail exploit and the kernel patchfinder
* [felix-pb](https://github.com/felix-pb) for the kfd exploits
* [Kaspersky](https://securelist.com/operation-triangulation-the-last-hardware-mystery/111669/) for Operation Triangulation
* [kok3shidoll](https://github.com/kok3shidoll) for lots of work on arm64 support for Dopamine
* [wh1te4ever](https://github.com/wh1te4ever) for [kfund](https://github.com/wh1te4ever/kfund)
* [Zhuowei](https://github.com/zhuowei) for the tccd unsandboxing method
* [xina520](https://x.com/xina520) for the kernel read/write-only privilege escalation method
* [dhinakg](https://github.com/dhinakg) for the memory hogger, the MacDirtyCow kernelcache grabber method, [libpartial](https://github.com/dhinakg/partial) and help with [libgrabkernel2](https://github.com/alfiecg24/libgrabkernel2)
* [staturnz](https://github.com/staturnzz) for work on the kernel patchfinder
* [aaronp613](https://x.com/aaronp613) for the TrollInstallerX icon
* [DTCalabro](https://github.com/DTCalabro) and [JJTech](https://github.com/JJTech0130) for improvements to the logging system
* [MasterMike88](https://x.com/MasterMike88) for helping test and debug during development
