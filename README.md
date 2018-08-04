# Feedback App on Flutter

Flutter iOS&#x2F;Android Client Application for Feedback Application Busi

## Getting Started
- Install `android-studio` through this [mirror](https://developer.android.com/studio/i)

- Install the full `flutter` environment through this [mirror](https://flutter.io/get-started/install/)
  - Ensure that the `flutter SDK` installation step is satisfied
  - Ensure that the `Android toolchain` requirement in the `flutter doctor` step is satisfied
  - Ensure that the `android-studio` installation step is satisfied
  - In order to have the app build and run in live mode, can either ensure that either your own android device is set up to work with `android-studio` OR 
  - Ensure that you have completed the instructions to set up an AVD (Android Virtual Device), a mobile device emulator that runs on a VM on top of your computer. 
    - Ensure that you have configured VM acceleration (hardware VM acceleration is recommended) to work. 
    - VM acceleration comprises 2 parts: 1. Graphics Acceleration - use your computer hardware to render the android device emulator's graphics (this step can be quite trivial) AND
    - 2. Hardware Acceleration - use your CPU chip to support virtual machine behind the emulator. This step can be a little involved and take up 30 mins to 1 hour. Easier for linux, medium for Mac, harder for Windows. 
    - Note that Hardware Acceleration is quite important if you want your VM clockspeed to approach expected performance. To get a sense, a cheap smartphone out of the box can be expected to have 4 CPU cores, 1.8 GHz. Without configuring it, a simple operation on your Android emulator can take many minutes to run.  
  - Follow the link "Next step: Configure Editor" for instructions to install the `Dart` and `Flutter` plugins for `android-studio`
  - Follow the link "Next step: Test drive Flutter" to use `android-studio` to configure a virtual device (if you are not planning to use your own Android device and haven't already completed this step when setting up VM Acceleration!).
  - Run a "hello world" Flutter program as recommended.
  - Kudos for reaching this point. Run `flutter doctor` and ensure that all boxes are checked off. Ta-da, you're done!

- Build and run this app from source
  - Clone this repository into a nice working directory you'd like
  - Launch `android-studio` and add the working directory as a new Android project
  - Locate AVD (Android Device Manager) in `android-studio` and launch the device you have configured. Alternatively, use your own Android Device if you'd like.
  - Locate the green `run` button in `android-studio` user interface. It is located in a toolbar at the upper right area of the studio. Make sure `main.dart` is selected from the main code file dropdown menu. Make sure the name of your configured device is selected from the device dropdown menu.
  - Hit the `run` button. 
  - The app will compile and build from the code library through `main.dart`, using instructions from the gradle files located at the root level and that at the `/android` level. iOS app is compiled different.
  - Ta-da, prime time!

- Reach out to gunny@rice.edu or zitzrus@gmail.com for bugs and cookies.
   
## Getting Started with FLutter

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
