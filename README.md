# Ada Flutter Plugin

A Flutter plugin for using the native Ada SDK.

## Getting Started

Here are steps to configure a fresh project:

1. Add plugin dependency to the `pubspec.yaml` file:

```yaml
dependencies:
    ada: ^1.0.0-beta01
```

2. Create `AdaViewController` instance:

```dart
class _MyState extends State<MyApp> {
  final _controller = AdaViewController(
    publisherId: "publisher-id",
    tagId: "tag-id",
  );

  // ...
}
```

3. Create `AdaView` widget:

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
