# WidgetThatFits

A Flutter widget that displays the first child that fits the available space, inspired by SwiftUI's [ViewThatFits](https://developer.apple.com/documentation/swiftui/viewthatfits). This package allows you to provide multiple layout options and automatically shows the most preferred one that fits the current constraints.

<p align="center">
  <img src="https://raw.githubusercontent.com/ky1vstar/widget_that_fits/refs/heads/master/assets/demo.gif" alt="">
</p>

## Features

- Display the first child that fits the available space along the specified axes (horizontal, vertical, or both)
- Easily provide multiple layout options for responsive UIs
- Simple API, similar in spirit to SwiftUI's ViewThatFits
- No scaling or wrapping — just picks the first child that fits

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  widget_that_fits: <latest_version>
```

Import it in your Dart code:

```dart
import 'package:widget_that_fits/widget_that_fits.dart';
```

## Usage

Wrap your widgets with `WidgetThatFits` and provide alternative layouts as children. The widget will display the first child that fits the available space along the specified axes.

```dart
WidgetThatFits(
  axes: const {Axis.horizontal}, // or {Axis.vertical}, or both
  children: [
    Row(
      children: [
        Text('Detailed layout'),
        SizedBox(width: 100, child: LinearProgressIndicator(value: 0.75)),
      ],
    ),
    SizedBox(
      width: 100,
      child: LinearProgressIndicator(value: 0.75),
    ),
    Text('Compact'),
  ],
)
```

### Example: Upload Progress Widget

```dart
class UploadProgressWidget extends StatelessWidget {
  const UploadProgressWidget({super.key, required this.uploadProgress});

  static final _percentFormatter = NumberFormat.percentPattern();
  final double uploadProgress;

  @override
  Widget build(BuildContext context) {
    return WidgetThatFits(
      axes: const {Axis.horizontal},
      children: [
        Row(
          children: [
            Text(_percentFormatter.format(uploadProgress)),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(value: uploadProgress),
            ),
          ],
        ),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(value: uploadProgress),
        ),
        Text(_percentFormatter.format(uploadProgress)),
      ],
    );
  }
}
```

## Additional information

- Inspired by SwiftUI's [ViewThatFits](https://developer.apple.com/documentation/swiftui/viewthatfits)
- See the `/example` folder for a complete working example
- Contributions and issues are welcome! Please file them on the [GitHub repository](https://github.com/your-repo/widget_that_fits)
- Licensed under the MIT License
