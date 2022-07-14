# Resource Provider

A simple resource provider to get objects by type (or by both name and type). Right now it eagerly creates an object on get.


## Features

Resource providers maintains collection of resources in its instance and all of them can be disposed after usage.

## Getting started

1. Add dependency with `dart pub add resource_provider` or `flutter pub add resource_provider`.

2. Import the package

```
import 'package:resource_provider/resource_provider.dart';
```

3. Create an instance of ResourceProvider.

```dart
final resource = ResourceProvider();
```

4. Get a resource (Will always return same instance).
```dart
resource(ResourceData(onCreate: someValueCallback))}
```

5. You can update the returning resource's value by providing a value.
```dart
resource(ResourceData(onCreate: someValueCallback), value: someUpdatedValue)}
```

6. clear resources after usage to dispose.
```dart
resource.clear(); // or resource.dispose();
```
