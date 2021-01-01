# Security Scanner

An app for scanning other apps for secure vulnerabilities.

Link to the official publications on the ResearchGate portal: https://www.researchgate.net/publication/347977433_Security_and_Privacy_concepts_methodologies_and_suggestions_for_personal_data_to_analyze_and_check_installed_apps_on_our_mobile_devices_how_are_they_secure_and_do_they_send_users%27_personal_data_to_som?channel=doi&linkId=5feb26bf92851c13fed05dbc&showFulltext=true

## Note: only MacOS for Desktops and Android OS for mobile phones are currently supported

## Before Downloading the Project

### Installing Flutter SDK

Here is an offical insrtuction how to download the Flutter SDK https://flutter.dev/docs/get-started/install After installing the Flutter run the following two commands in the termina

```
flutter channel dev
flutter upgrade --force
```

After that we have to enable MacOS configuration

```
flutter config --enable-macos-desktop
```

### Installing NodeJS

Here is an offical insrtuction how to download the NodeJS https://nodejs.org/en/download/ LTS version is recommended

### Installing Adnroid SDK Tools

Here is an offical insrtuction how to download the Adnroid Studio and Android SDK https://developer.android.com/studio

After installing be sure that Flutter and NodeJS in the Path. Android SDK tools probably will not be in the Path by default, and because of that fact it will be some times required to locate to the SDK folder or SDK can be moved to the math manually.

## Installing the Project

Clone the porject to the any directory bt the following command:

```
git clone https://github.com/DarkKnight1005/security_scaner.git
```

Open the project folder in the code redactor (Visual Studio Code is recommended)

After that move to the ./AnyProxy/bin whih locates inside the porject or in VS code type into the terminal following command

```
npm install --force
```

After that just in order to be on the safe side run the following command:

```
npm audit fix --force
```

### Trusting the Certificate

This project uasing AnyProxy for the proxy side. Now the Certificate must be trusted to decrypt HTTPS traffic as mentioned in the report-resoearch. In the folder ./AnyProxy/bin run the following command:

```
./anyproxy-ca 
```
After that do the required things to generate the Certificate. Then locate to the relevant folder with the generated certufucate and double click to the `rootCA.crt`. After that KeyChain will open. Double-click to the `AnyProxy` certificate in the KeyCahin and properties window will pop up. Find `Trust`, click and expand it and change When using this certificate from Use System Defaults to `Always Trust`. Run `./anyproxy-ca` to be sure that that certificate is trusted.

## Building app

### For MacOS

NOTE: Be sure that MacOS version is at least 11.0 (Big Sur) or higher, in other cases, unknown errors may occur.

Locate to the project directory and run the following command:
```
flutter pub get
```

After that just select `macOS(darwin-x64)` or just `macOS` from the down right corner of the VS code and run the App.

Configuration for the MacOS is ready, now you can Analyze all traffic of the PC. 
By clicking `Connect` App will start the server and connect PC to the proxy server. 
By clicking `Disconnect` App will stop the server and disconnect PC from it.

### For Android OS

NOTE: Be sure that Android version is at least 5.1 (SDK 21) or higher, in other cases, unknown errors may occur.

#### Trusting the Certificate
The fisrt thing which is requred to do is that install `certificate` tot the phone. It is the same certificate which wes generated before for the PC. To trust to certificate just send it to the mobile device then tap on it.

1) Select VPN and Apps and name as you whish, then submit.
2) Select WIFI and name as you whish, then submit.

#### Downloading Proxy connector 
After that it is highly recommended to donwload an app from the following link because of the fact that connecttion to proxy firectly from the Flutter a bit problematic and the native way is the much better. https://github.com/theappbusiness/android-proxy-toggle

#### Manual Connection
To connect manually it is requesred to go the WIFI settings of the phone, then forget disconnect from the WIFI. Then connect again, and in advanced settings during the connection select `manual` in Proxy settings and write IP and Port for the Porxy.

After the instalation of `Proxy Toggle` it is required to run MacOS application, click to the `ServerMobile`, then in the `Proxy Toggle` app write down Server's or Local Machines IP address. which can be found at the center top of the applicaiton with the label `Server IP`. 
Or the follofing command can be executed in order to find it:
```
sudo ifconfig
```

#### Seting Up

Now in `Proxy Toggle` it is needed to write the `IP` of the Local machine to the related field and Port will be `8090`. Then press connect.

After succsefull connection to the proxy, switch to our app and and in the `Text Field` write that `IP` address again and press `submit`. 
After all this steps everything is ready. You can now surf in the internet and after just visiting onw site you can switch back to the app and press `All`. And all the traffic will be shown.

NOTE: By default realtime update and push notifications are disabled. In order to see the traffic, just every time tap the `All` button, then programm will refresh captured internet traffic.

## Troubleshooting

For now troubleshooting is now supported in this documentation. If there are any questions please do not hesitate to contact with men via
```
Email: ayaz.panahov.std@bhos.edu.az
Phone: +994507935935
```
-
--------------------------------------------------------------------
Made by Ayaz Panahov.
Copyright (c) 2020 HyandrDos Inc. All rights reserved.
