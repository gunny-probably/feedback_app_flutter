# Feedback App on Flutter

Flutter iOS&#x2F;Android Client Application for Feedback Application Busi

## Getting Started
- Install `android-studio` through this [mirror](https://developer.android.com/studio/i)

- Install the full `flutter` environment through this [mirror](https://flutter.io/get-started/install/)
  - Ensure that the `flutter SDK` installation step is satisfied
  - Ensure that the `Android toolchain` requirement in the `flutter doctor` step is satisfied
  - Ensure that the `android-studio` installation step is satisfied
  - Ensure that either your own android device is set up to work with `android-studio`, or that you have configured VM acceleration (hardware VM acceleration is recommended) to work.
  - Find the link "Next step: Configure Editor" and install the `Dart` and `Flutter` plugins for `android-studio`
  - Find the link "Next step: Test drive Flutter" to use `android-studio` to configure a virtual device and run a "hello world" Flutter program. 
  - Kudos if you've reach this point. Run `flutter doctor` and ensure that all boxes are checked off. Ta-da, you're done!

- Getting the app running from source
  - Clone this repository into a nice working directory you'd like
  - Launch `android-studio` and add the working directory as a new Android project
  - Locate AVD (Android Device Manager) in `android-studio` and launch the device you have configured.
  - Locate the green `run` button in `android-studio`. Make sure `main.dart` is selected from the main code file dropdown menu. Make sure the name of your configured device is selected from the device dropdown menu. 
  - The app will compile and build from the code library through `main.dart`, using instructions from the gradle files located at the root level and that at the `/android` level. iOS app is compiled different.
  - Ta-da, you've got yourself a demo!

- Reach out to me at gunny@rice.edu or zitzrus@gmail.com.
   
## Getting Started with FLutter

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
