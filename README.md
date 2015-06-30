# chatApp
Chat Application for Project Work 1

Parse set up for Xcode

1. Create a new account in Parse website
2. Create a new application in Parse website
3. Download & unzip the Parse SDK into the Xcode project files
4. Add the following libraries in the App 'Build Phases' tab:

- AudioToolbox.framework
- CFNetwork.framework
- CoreGraphics.framework
- CoreLocation.framework
- MobileCoreServices.framework
- QuartzCore.framework
- Security.framework
- StoreKit.framework
- SystemConfiguration.framework
- libz.dylib
- libsqlite3.dylib

5. Copy the aplicationID and clientID and paste it in the AppDelegate file of your Xcode Project inside the function application:didFinishLaunchingWithOptions:
6. To use parse in your classes import it in the first lines of code with import Parse

Parse tables creation

1. Login into your Parse account
2. Go to your Parse application
3. Click the 'Core' Tab
4. To add a new table click the 'Add class' button
5. To add more columns click the '+ Col' button
6. To add a new row click the '+ Row' button and fill it with information
