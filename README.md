<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/LaunchLogo.png" alt= "project Logo" width="350">
</p>

<p align="center">
   <img src="https://img.shields.io/badge/iOS-16.0%2B-blueviolet" alt="iOS Version">
   <img src="https://img.shields.io/badge/Version-1.0-blue" alt="Game Version">
   <img src="https://img.shields.io/badge/License-MIT-source" alt="License">
</p>

### Disclaimer

This application is made for educational purposes only. The main idea is to optimize gathering information with time from various websites, sort and check for changes, push local notifications when it is needed to grab the user's attention. It is not for commercial usage. The application is limited with a minimum of 30 seconds of website check, so there couldn't be any additional server pressure caused.

---

### About

Check for available Hamburg apartments from Saga & Vonovia. Locate the apartment you like with Google Maps and open its applying page with a single button.

> Found it useful? Please, give me a star: it costs nothing for you but means a lot for me!

---

### Features
- The app uses a walkaround not to be terminated in the background with a silent audio player (it plays soundless mp3 file endlessly) you have to grant permission on the first run. Be ready that your iPhone will consume more battery than usual. This is the price which has to be paid for the app to be able to run the main logic even if it is not in the foreground
- Quickly expandable: make a new module for any other real estate provider conforming to Landlord protocol, add it to the array of providers in LandlordsManager and you are done
> Your pull requests are welcome!
- Filter apartments for your needs with options in the sheets presented view controller (swipe up from down to appear); save options as default for next runs of the app
- Get local notification when the new apartment is posted and the application is not in the foreground of two types which could be selected in the options (default & custom sound)

---

### How to install
1. Get a Mac wth OS Monterey 12.5+ and iPhone with iOS 16+
2. Install XCode 14
3. Go to preferences of Xcode - Account tab. Login with your Apple ID
4. Clone the repository or download with green button "Code" at the top of this page -> "Download Zip"
5. Open the project with .xcworkspace file (double click it)
6. In the File inspector (left side of XCode) select "WohnungSuchen" project (first line) and select "Signing & Capabilities". Set your you account and "Bundle Identifier". Any unique name is fine but more common way is x.y where x - you damain, y - name of the project. Example: ua.mysite.wohnungsuchen
7. Connect your iPhone with the cable, grant access to contact your Mac if needed.
8. Select your phone in the top screen where "Any iOS Device (arm64" is currently set
9. Press play button in the top left of the XCode and you are done

---

### Preview
<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-1.png" alt= "project Logo" width="250">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-2.png" alt= "project Logo" width="250">
</p>

---

### Developers
[advanc3dUA](https://github.com/advanc3dUA)
