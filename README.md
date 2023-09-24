<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/LaunchLogo.png" alt= "project Logo" width="350">
</p>

<p align="center">
   <img src="https://img.shields.io/badge/iOS-16.0%2B-blueviolet" alt="iOS Version">
   <img src="https://img.shields.io/badge/Version-1.1-blue" alt="Game Version">
   <img src="https://img.shields.io/badge/License-MIT-source" alt="License">
</p>
<p align="center">
<a href='https://github.com/MShawon/github-clone-count-badge'><img alt='GitHub Clones' src='https://img.shields.io/badge/dynamic/json?color=success&label=Clone&query=count&url=https://gist.githubusercontent.com/advanc3dUA/64246d82f8d3073cec7968493dbeb97c/raw/clone.json&logo=github'></a> <sup>since 11.09.2023</sup>
</p>

### Disclaimer

This application is made for educational purposes only. The primary goal of the app is to optimize gathering information with time from various websites, sort and check for changes, and push local notifications when needed to grab the user's attention, only for non-commercial usage. The application is limited with a minimum of 30 seconds of website check, so there couldn't be any additional server pressure caused.

---

### About

Check for available Hamburg apartments from Saga & Vonovia. Locate the apartment you like with Google Maps and open its application page with a single button.

> Found it helpful? Please, grant me a star: it costs nothing to you but means a lot to me!

---

### Features
- The app uses a walkaround not to be terminated in the background with a silent audio player (it plays soundless mp3 file endlessly) you have to grant permission on the first run. Please be sure to be ready that your iPhone will consume more battery than usual. This is the price that has to be paid for the app to be able to run the main logic (background new apartments remote check) even if it is not in the foreground
- Quickly expandable: make a new module for any other real estate provider conforming to Landlord protocol and add it to the available providers list. To do that you need only two things: create your landlord's class conforming to Landlord protocol (/Networking/Landlords/Landlord.swift) and modify initial options (/Models/DefaultOptions.swift) to add it. Can't be simpler!
> Your pull requests are welcome!
- Filter apartments for your needs with options in the sheets presented view controller (swipe up from down to appear); save options as default for the next runs of the app
- Get a notification when the new apartment appears and the application is not in the foreground of two types which could be selected in the options (system default for your push notifications or custom sound)
- You can pause the app (or shut it down) at night and on weekends and it won't drain the internet until the play button is tapped
- In the 1.1 version you can remove active providers on the fly

---

### Requirements
1. Mac with OS Monteray 12.5+
2. iPhone with iOS 16+
3. XCode 14+

> Don't have a Mac with Xcode but only an iPhone? Find my contacts on my GitHub [home page](https://github.com/advanc3dUA) - I will try to help you.

---

### How to install
1. Google how to join the Apple Developers Program with your Apple ID. There is no need for a paid account - free is fine. The only limitation in this case is that you have to reinstall the app every 7 days but it will take a few minutes.
2. Go to preferences of Xcode - Account tab. Press "+" and add your Apple ID.
3. Clone the repository or press the green "Code" button at the top of this page and then "Download Zip". Unzip the downloaded file.
4. Open the project with the .xcworkspace file (double-click it).
5. In the File inspector (left side of XCode) select the "WohnungSuchen" project (first line) and select the "Signing & Capabilities" tab in the top center part of XCode. Set your account (select your Apple ID) and "Bundle Identifier". For "Bundle Identifier" any unique name is good but the more common way is the format "x.y" where x - is your reversed domain (e.g. "com.site" instead of "site.com") and y - is the name of the project. Example: ua.mysite.wohnungsuchen or com.younickname.wohnungsuchen.
6. Connect your iPhone with the cable and grant access to contact your Mac if needed.
7. Using your iPhone, open Settings - Privacy & Security - Turn on Developer Mode. You will be asked to restart your phone - do it.
8. Select your phone at the top of the screen of XCode where "Any iOS Device (arm64)" is currently set.
9. Press the play button in the top left of the XCode to install the app.
10. If the app WohnungSuchen successfully appears on your springboard, you can unplug the phone from the Mac.
11. On your phone, open Settings - General - VPN and Device Management. Tap on your Apple ID under the Developer App heading and allow the use of the app you have installed.

---

### Preview
<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-1.png" alt= "project Logo" width="250">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-2.png" alt= "project Logo" width="250">
</p>

---

### Developers
[advanc3dUA](https://github.com/advanc3dUA)
