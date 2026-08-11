# Ada Flutter Plugin

A Flutter plugin for using the native Ada SDK.

## Requirements

| Platform | Minimum version       |
|----------|-----------------------|
| Android  | API 24 (Android 7.0)  |
| iOS      | 15.0                  |
| Flutter  | 3.24.0                |
| Dart     | 3.3.0                 |

> **Note:** Flutter 3.24.0+ is required for iOS builds (the plugin uses Swift Package Manager).

## Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
    ada:
      git:
        url: https://github.com/Aniview/ada-flutter.git
```

Then run:

```bash
flutter pub get
```

On iOS, Flutter will automatically resolve the native SDK via Swift Package Manager.
On Android, make sure the Aniview Maven repository is configured (see [Android configuration](#android-configuration) below).

## Getting Started

1. Initialize `AdaSDK` framework:

```dart
    await Ada.initialize(iosStoreUrl: "STORE_URL_TO_YOUR_APP");
```
   \* on iOS, pass your App Store URL — it is used by the SDK for attribution.

3. Create `AdaViewController` instance:

```dart
class _MyState extends State<MyApp> {
  final _controller = AdaViewController(
    config: const AdaConfig(
      publisherId: "publisher-id",
      tagId: "tag-id",
    ),
  );

  // ...
}
```

4. Create `AdaView` widget:

```dart
class _MyState extends State<MyApp> {
  // ...

  @override
  Widget build(BuildContext context) {
    return AdaView(controller: _controller);
  }
}
```

### Android configuration

Building for Android platform requires repository configuration in the `settings.gradle` file:

```groovy
dependencyResolutionManagement {
    repositories {
        maven {
            url "https://us-central1-maven.pkg.dev/mobile-sdk-fd2e4/adservr-maven"
        }
    }
}
```
