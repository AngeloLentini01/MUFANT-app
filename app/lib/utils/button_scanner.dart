import 'package:flutter/material.dart';

/// Represents a button found in the widget tree
class ButtonInfo {
  final String buttonType;
  final String? buttonText;
  final IconData? buttonIcon;
  final String widgetLocation;
  final bool hasOnPressed;
  final bool isOnPressedNull;
  final bool isOnPressedEmpty;

  ButtonInfo({
    required this.buttonType,
    this.buttonText,
    this.buttonIcon,
    required this.widgetLocation,
    required this.hasOnPressed,
    required this.isOnPressedNull,
    required this.isOnPressedEmpty,
  });

  bool get isUnimplemented =>
      hasOnPressed && (isOnPressedNull || isOnPressedEmpty);

  @override
  String toString() {
    return 'ButtonInfo(type: $buttonType, text: $buttonText, location: $widgetLocation, unimplemented: $isUnimplemented)';
  }
}

/// Utility class to scan the widget tree for buttons and detect unimplemented onPressed events
class ButtonScanner {

  /// Scans the widget tree and returns all buttons found
  static List<ButtonInfo> scanWidgetTree(Widget widget, String location) {
    final List<ButtonInfo> buttons = [];
    _scanWidget(widget, location, buttons);
    return buttons;
  }

  /// Recursively scans a widget and its children for buttons
  static void _scanWidget(
    Widget widget,
    String location,
    List<ButtonInfo> buttons,
  ) {
    if (widget is ElevatedButton) {
      buttons.add(_extractButtonInfo(widget, 'ElevatedButton', location));
    } else if (widget is TextButton) {
      buttons.add(_extractButtonInfo(widget, 'TextButton', location));
    } else if (widget is OutlinedButton) {
      buttons.add(_extractButtonInfo(widget, 'OutlinedButton', location));
    } else if (widget is IconButton) {
      buttons.add(_extractIconButtonInfo(widget, location));
    } else if (widget is FloatingActionButton) {
      buttons.add(_extractFloatingActionButtonInfo(widget, location));
    } else if (widget is MaterialButton) {
      buttons.add(_extractButtonInfo(widget, 'MaterialButton', location));
    } else if (widget is GestureDetector) {
      // Check if GestureDetector has onTap
      if (widget.onTap != null) {
        buttons.add(
          ButtonInfo(
            buttonType: 'GestureDetector',
            buttonText: _extractTextFromWidget(widget.child),
            widgetLocation: location,
            hasOnPressed: true,
            isOnPressedNull: false,
            isOnPressedEmpty: false,
          ),
        );
      }
    }

    // Recursively scan child widgets - simplified approach
    if (widget is SingleChildScrollView && widget.child != null) {
      _scanWidget(widget.child!, '$location > SingleChildScrollView', buttons);
    } else if (widget is Column) {
      for (int i = 0; i < widget.children.length; i++) {
        _scanWidget(widget.children[i], '$location > Column[$i]', buttons);
      }
    } else if (widget is Row) {
      for (int i = 0; i < widget.children.length; i++) {
        _scanWidget(widget.children[i], '$location > Row[$i]', buttons);
      }
    } else if (widget is Stack) {
      for (int i = 0; i < widget.children.length; i++) {
        _scanWidget(widget.children[i], '$location > Stack[$i]', buttons);
      }
    } else if (widget is Container && widget.child != null) {
      _scanWidget(widget.child!, '$location > Container', buttons);
    } else if (widget is SizedBox && widget.child != null) {
      _scanWidget(widget.child!, '$location > SizedBox', buttons);
    }
  }

  /// Extracts button information from standard buttons
  static ButtonInfo _extractButtonInfo(
    dynamic button,
    String buttonType,
    String location,
  ) {
    final hasOnPressed = button.onPressed != null;
    final isOnPressedNull = button.onPressed == null;
    final isOnPressedEmpty = hasOnPressed && _isEmptyCallback(button.onPressed);

    String? buttonText = _extractTextFromWidget(button.child);
    IconData? buttonIcon = _extractIconFromWidget(button.child);

    return ButtonInfo(
      buttonType: buttonType,
      buttonText: buttonText,
      buttonIcon: buttonIcon,
      widgetLocation: location,
      hasOnPressed: hasOnPressed,
      isOnPressedNull: isOnPressedNull,
      isOnPressedEmpty: isOnPressedEmpty,
    );
  }

  /// Extracts button information from IconButton
  static ButtonInfo _extractIconButtonInfo(IconButton button, String location) {
    final hasOnPressed = button.onPressed != null;
    final isOnPressedNull = button.onPressed == null;
    final isOnPressedEmpty = hasOnPressed && _isEmptyCallback(button.onPressed);

    return ButtonInfo(
      buttonType: 'IconButton',
      buttonIcon: button.icon is Icon ? (button.icon as Icon).icon : null,
      widgetLocation: location,
      hasOnPressed: hasOnPressed,
      isOnPressedNull: isOnPressedNull,
      isOnPressedEmpty: isOnPressedEmpty,
    );
  }

  /// Extracts button information from FloatingActionButton
  static ButtonInfo _extractFloatingActionButtonInfo(
    FloatingActionButton button,
    String location,
  ) {
    final hasOnPressed = button.onPressed != null;
    final isOnPressedNull = button.onPressed == null;
    final isOnPressedEmpty = hasOnPressed && _isEmptyCallback(button.onPressed);

    IconData? buttonIcon = _extractIconFromWidget(button.child);

    return ButtonInfo(
      buttonType: 'FloatingActionButton',
      buttonIcon: buttonIcon,
      widgetLocation: location,
      hasOnPressed: hasOnPressed,
      isOnPressedNull: isOnPressedNull,
      isOnPressedEmpty: isOnPressedEmpty,
    );
  }

  /// Extracts text from a widget
  static String? _extractTextFromWidget(Widget? widget) {
    if (widget is Text) {
      return widget.data;
    } else if (widget is RichText) {
      // For RichText, we can't easily extract text, so return null
      return null;
    }
    return null;
  }

  /// Extracts icon from a widget
  static IconData? _extractIconFromWidget(Widget? widget) {
    if (widget is Icon) {
      return widget.icon;
    }
    return null;
  }

  /// Checks if a callback is empty (does nothing)
  static bool _isEmptyCallback(VoidCallback? callback) {
    if (callback == null) return true;

    // This is a simplified check - in practice, you might want to use reflection
    // or other methods to inspect the actual callback implementation
    // For now, we'll assume that if onPressed is not null, it's implemented
    return false;
  }

  /// Shows an alert for unimplemented buttons
  static void showUnimplementedAlert(
    BuildContext context,
    String buttonType,
    String location,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feature Coming Soon'),
          content: Text(
            'The $buttonType at $location will be implemented soon!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

/// Mixin to add button scanning capabilities to StatefulWidget
mixin ButtonScannerMixin<T extends StatefulWidget> on State<T> {
  /// Scans the current widget tree for buttons
  List<ButtonInfo> scanCurrentButtons() {
    return ButtonScanner.scanWidgetTree(widget, runtimeType.toString());
  }

  /// Shows alert for unimplemented buttons
  void showUnimplementedButtonAlert(String buttonType, String location) {
    ButtonScanner.showUnimplementedAlert(context, buttonType, location);
  }
}
