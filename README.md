<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/LaunchLogo.png" alt= "project Logo" width="350">
</p>

<p align="center">
   <img src="https://img.shields.io/badge/iOS-16.0%2B-blueviolet" alt="iOS Version">
   <img src="https://img.shields.io/badge/Version-1.22-blue" alt="Game Version">
   <img src="https://img.shields.io/badge/License-CC_BY--NC_4.0-darkgreen.svg" alt="License">
</p>
<p align="center">
<a href='https://github.com/MShawon/github-clone-count-badge'><img alt='GitHub Clones' src='https://img.shields.io/badge/dynamic/json?color=success&label=Clone&query=count&url=https://gist.githubusercontent.com/advanc3dUA/64246d82f8d3073cec7968493dbeb97c/raw/clone.json&logo=github'></a> <sup>since 11.09.2023</sup>
</p>

### Attention
This application is deprecated and no longer works. The new one is currently in closed beta.

Try this Telegram bot instead: [@ImmoZillaBot](https://t.me/immozillabot/).


### Disclaimer

This application is made for educational purposes only. The primary goal of the app is to optimize gathering information with time from various websites, sort and check for changes, and push local notifications when needed to grab the user's attention, only for non-commercial usage. The application is limited with a minimum of 45 seconds of website check, so there couldn't be any additional server pressure caused.

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
- In the 1.2 version you are able to select the application theme (dark or light) or leave it auto. In the last case, it will be the same as your selected system preference

---

### Requirements
1. Mac with OS Monterey 12.5+
2. iPhone with iOS 16+
3. XCode 14+
---

### Preview
<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-1.png" alt= "project Logo" width="250">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-2.png" alt= "project Logo" width="250">
</p>
<p align="center">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-3.png" alt= "project Logo" width="250">
      <img src="https://github.com/advanc3dUA/WohnungSuchen/blob/main/WohnungSuchen/Logos/preview-4.gif" alt= "project Logo" width="250">
</p>

---

### Developers
[advanc3dUA](https://github.com/advanc3dUA)

### License
[Not for commercial usage](https://creativecommons.org/licenses/by-nc/4.0/).
