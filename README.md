<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/LaunchLogo.png" alt= "project Logo" width="350">
</p>

<p align="center">
   <img src="https://img.shields.io/badge/iOS-16.0%2B-blueviolet" alt="iOS Version">
   <img src="https://img.shields.io/badge/Version-1.0-blue" alt="Game Version">
   <img src="https://img.shields.io/badge/License-MIT-source" alt="License">
</p>

### Disclaimer

This application is made for educational purposes only. The main purpose of the app is to optimize gathering information with time from various websites, sort and check for changes, and push local notifications when it is needed to grab the user's attention. It is not for commercial usage. The application is limited with a minimum of 30 seconds of website check, so there couldn't be any additional server pressure caused.

---

### About

Check for available Hamburg apartments from Saga & Vonovia. Locate the apartment you like with Google Maps and open its application page with a single button.

> Found it helpful? Please, grant me a star: it costs nothing to you but means a lot to me!

---

### Features
- The app uses a walkaround not to be terminated in the background with a silent audio player (it plays soundless mp3 file endlessly) you have to grant permission on the first run. Be ready that your iPhone will consume more battery than usual. This is the price that has to be paid for the app to be able to run the main logic (background new apartments check) even if it is not in the foreground
- Quickly expandable: make a new module for any other real estate provider conforming to Landlord protocol, add it to the array of providers in LandlordsManager and you are done
> Your pull requests are welcome!
- Filter apartments for your needs with options in the sheets presented view controller (swipe up from down to appear); save options as default for the next runs of the app
- Get a notification when the new apartment appears and the application is not in the foreground of two types which could be selected in the options (system default for your push notifications or custom sound)
- You can pause the app at night and on weekends and it won't drain the internet until the play button will be tapped

---

### Requirements
1. Mac with OS Monteray 12.5+
2. iPhone with iOS 16+
3. XCode 14+

---

### How to install
1. Google how to join Apple Developers Program with your Apple ID. There is no need for a paid account - free is totally fine. The only limitation in this case is that you have to reinstall the app every 7 days but it will take a few minutes.
2. Go to preferences of Xcode - Account tab. Log in with your Apple ID.
3. Using your iPhone, open Settings - Privacy & Security - Turn on Developer Mode.
4. Clone the repository or press the green button "Code" at the top of this page and then press "Download Zip". Unzip the downloaded file.
5. Open the project with the .xcworkspace file (double-click it)
6. In the File inspector (left side of XCode) select "WohnungSuchen" project (first line) and select "Signing & Capabilities" tab in the top center part of XCode. Set your account (select your Apple ID) and "Bundle Identifier". For "Bundle Identifier" any unique name is good but the more common way is the format "x.y" where x - is your reversed domain and y - is the name of the project. Example: ua.mysite.wohnungsuchen or com.younickname.wohnungsuchen.
7. Connect your iPhone with the cable and grant access to contact your Mac if needed.
8. Select your phone at the top of the screen of XCode where "Any iOS Device (arm64)" is currently set.
9. Press the play button in the top left of the XCode to install the app.
10. Using your iPhone, open Settings - General - VPN and Device Management. Tap on your Apple ID under the Developer App heading and allow using of the app you have installed.

---

### Preview
<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-1.png" alt= "project Logo" width="250">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-2.png" alt= "project Logo" width="250">
</p>

---

### Developers
[advanc3dUA](https://github.com/advanc3dUA)
