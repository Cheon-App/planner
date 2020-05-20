# Cheon Smart Planner

## Getting Started
Create a Firebase project and add an Android or IOS app to it. You'll be given the option to download a google-services.json(Android) or GoogleService-Info.plist(IOS) file which should be placed in android/app/google-services.json or ios/Runner/GoogleService-Info.plist respectively.

If you're on Android you'll also need to [create a keystore](https://flutter.dev/docs/deployment/android#create-a-keystore) and [reference the keystore](https://flutter.dev/docs/deployment/android#create-a-keystore) via the file `android/key.properties`

## Running the app
### Android

#### Production build

`flutter run --release --flavor prod`

#### Development build

`flutter run --release -t lib/main_dev.dart --flavor dev`

### IOS

#### Production build

`flutter run --release`

#### Development build

`flutter run --release -t lib/main_dev.dart`

## Static analysis

`flutter analyze`

## Automated tests

`flutter test`
