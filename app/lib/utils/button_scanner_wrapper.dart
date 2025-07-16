import 'package:flutter/material.dart';
import 'package:app/utils/button_scanner.dart';

/// Wrapper widget that automatically scans for unimplemented buttons
/// and shows alerts when they are pressed
class ButtonScannerWrapper extends StatefulWidget {
  final Widget child;
  final String pageName;

  const ButtonScannerWrapper({
    super.key,
    required this.child,
    required this.pageName,
  });

  @override
  State<ButtonScannerWrapper> createState() => _ButtonScannerWrapperState();
}

class _ButtonScannerWrapperState extends State<ButtonScannerWrapper> {
  List<ButtonInfo> _unimplementedButtons = [];

  @override
  void initState() {
    super.initState();
    // Scan for buttons after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanForUnimplementedButtons();
    });
  }

  void _scanForUnimplementedButtons() {
    final buttons = ButtonScanner.scanWidgetTree(widget.child, widget.pageName);
    final unimplemented = buttons.where((b) => b.isUnimplemented).toList();

    setState(() {
      _unimplementedButtons = unimplemented;
    });

    // Log found unimplemented buttons
    if (unimplemented.isNotEmpty) {
      for (final button in unimplemented) {
        print(
          '⚠️ Unimplemented button found: ${button.buttonType} at ${button.widgetLocation}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  /// Shows alert for unimplemented buttons
  void showUnimplementedAlert(String buttonType, String location) {
    ButtonScanner.showUnimplementedAlert(context, buttonType, location);
  }

  /// Get list of unimplemented buttons
  List<ButtonInfo> get unimplementedButtons => _unimplementedButtons;
}

/// Mixin to add button scanning capabilities to any widget
mixin ButtonScannerWrapperMixin<T extends StatefulWidget> on State<T> {
  /// Shows alert for unimplemented buttons
  void showUnimplementedButtonAlert(String buttonType, String location) {
    ButtonScanner.showUnimplementedAlert(context, buttonType, location);
  }

  /// Wraps a widget with button scanning
  Widget wrapWithButtonScanner(Widget child, String pageName) {
    return ButtonScannerWrapper(pageName: pageName, child: child);
  }
}
