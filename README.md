# Open Nettest for iOS and Android

## Setup

1. Create `.env` file from `example.env` with your unique values.
2. Get a secret token from https://account.mapbox.com/access-tokens/, then set it as `MAPBOX_DOWNLOADS_TOKEN` in your `gradle.properties` file (https://docs.mapbox.com/android/maps/guides/install/) and add it to a `~/.netrc` file (https://docs.mapbox.com/ios/maps/guides/install/).
3. Add your Google Services' configs to the `android` and `ios` folders

    /ios/Runner/GoogleService-Info.plist
    /android/app/google-services.json

4. Configure the flavor's images and settings in the config folder. See `config/.nt` for example.
5. Init submodules in the `plugins` folder

    git submodule update --init

6. Run

    flutter pub get

7. To setup app icons, run

    flutter pub run flutter_launcher_icons:main -f config/<YOUR_FLAVOR_SUFFIX>/flutter_launcher_icons.yaml

8. To be able to create release builds for Android, create a signing key in Android Studio, then add a `key.properties` file to the `android` folder with contents like this:

    storePassword=<password_from_your_key_file>
    keyPassword=<password_from_your_key_file>
    keyAlias=<alias_from_your_key_file>
    storeFile=<full_path_to_you_key_file>

9. To be able to create release builds for iOS, make sure, after configuing the flavor and its package name, to open XCode and let it download your provisioning profiles from the AppStore.

## Running

To run the app use

    flutter run

with the following parameters:

1. "--dart-define=DEFINE_APP_SUFFIX=<YOUR_FLAVOR_SUFFIX>", e.g. `.nt`. The suffix will be used to differentiate the flavor you build, e.g. in the package name, server communication, flavor configuration.
2. "--dart-define="DEFINE_APP_NAME=<YOU_APP_NAME>".
3. "--dart-define=DEFINE_CONTROL_SERVER_URL=<YOUR_CONTROL_SERVER_URL>", including protocol, host, and port. The control server provides a list of measurement servers, registers measurements and stores their results.
4. "--dart-define=DEFINE_CMS_SERVER_URL=<YOUR_CMS_SERVER_URL>", including protocol, host, and port. The CMS contains texts and their translations, decides which features enable or disable for certain flavors.
5. "--dart-define=DEFINE_WEBPAGE_URL=<YOUR_WEBPAGE_URL>", including protocol, host, and port. This URL will be used as default for all the paths that require opening the web view.

If you use VSCode, those can be set in advance in `launch.json`.

## Troubleshooting

* Error building for iOS: `error: No profiles for 'com.example.nettest.nt' were found: Xcode couldn't find any iOS App Development provisioning profiles matching 'com.example.nettest.nt'`
    Solution: open `ios/Runner.xcworkspace` and let it to download profiles.

* Error when deploying to TestFlight: `exportArchive: No profiles for 'com.example.nettest.nt' were found`.
    Solution: open and validate `build/ios/archive/Runner.xcarchive`.

* Error when running tests: `The following FormatException was thrown while resolving an image:...`
    Solution: run `flutter clean`, `flutter pub get`, `flutter pub run build_runner build`.