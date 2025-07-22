import 'package:flutter/material.dart';
import 'package:app/utils/button_scanner.dart';
import 'package:app/presentation/styles/all.dart';
import 'package:easy_localization/easy_localization.dart';

/// Demo page showing how to use the ButtonScanner
class ButtonScannerDemo extends StatefulWidget {
  const ButtonScannerDemo({super.key});

  @override
  State<ButtonScannerDemo> createState() => _ButtonScannerDemoState();
}

class _ButtonScannerDemoState extends State<ButtonScannerDemo>
    with ButtonScannerMixin {
  List<ButtonInfo> _foundButtons = [];
  List<ButtonInfo> _unimplementedButtons = [];

  @override
  void initState() {
    super.initState();
    // Scan for buttons after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanButtons();
    });
  }

  void _scanButtons() {
    final buttons = scanCurrentButtons();
    setState(() {
      _foundButtons = buttons;
      _unimplementedButtons = buttons.where((b) => b.isUnimplemented).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: const Text(
          'Button Scanner Demo',
          style: TextStyle(color: kWhiteColor),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Demo buttons with different states
            _buildDemoSection(),
            const SizedBox(height: 32),

            // Results section
            _buildResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Demo Buttons:',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Implemented button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('button_implemented'.tr())),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPinkColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Implemented Button',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Unimplemented button (null onPressed)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null, // This will be detected as unimplemented
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Unimplemented Button (null)',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Icon button
        IconButton(
          onPressed: () {
            showUnimplementedButtonAlert('IconButton', 'Demo Page');
          },
          icon: const Icon(Icons.info, color: kPinkColor),
        ),
        const SizedBox(height: 12),

        // Text button
        TextButton(
          onPressed: () {
            showUnimplementedButtonAlert('TextButton', 'Demo Page');
          },
          child: const Text(
            'Text Button',
            style: TextStyle(color: kPinkColor, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),

        // Outlined button
        OutlinedButton(
          onPressed: () {
            showUnimplementedButtonAlert('OutlinedButton', 'Demo Page');
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kPinkColor),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Outlined Button',
            style: TextStyle(color: kPinkColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan Results:',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total buttons found: ${_foundButtons.length}',
                  style: const TextStyle(color: kWhiteColor, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unimplemented buttons: ${_unimplementedButtons.length}',
                  style: TextStyle(
                    color: _unimplementedButtons.isNotEmpty
                        ? Colors.orange
                        : kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Button details
          Expanded(
            child: ListView.builder(
              itemCount: _foundButtons.length,
              itemBuilder: (context, index) {
                final button = _foundButtons[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: button.isUnimplemented
                        ? Colors.orange.withValues(alpha: 0.2)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: button.isUnimplemented
                          ? Colors.orange
                          : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type: ${button.buttonType}',
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (button.buttonText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Text: ${button.buttonText}',
                          style: const TextStyle(color: kWhiteColor),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Location: ${button.widgetLocation}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${button.isUnimplemented ? "UNIMPLEMENTED" : "Implemented"}',
                        style: TextStyle(
                          color: button.isUnimplemented
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
