# Ada Flutter Plugin

A Flutter plugin for using the native Ada SDK.

## Getting Started

Here are steps to configure a fresh project:

1. Add plugin dependency to the `pubspec.yaml` file:

```yaml
dependencies:
    ada: ^1.4.0+2
```
2. Initialize `AdaSDK` framework:

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
