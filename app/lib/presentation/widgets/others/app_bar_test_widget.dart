import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/presentation/widgets/bars/app_bar_widget.dart';

/// Test widget to visualize and validate the AppBar logo centering
/// This widget provides visual guides to check if the logo is perfectly centered
class LogoCenteringTestPage extends StatelessWidget {
  const LogoCenteringTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger('LogoCenteringTestPage');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Test the AppBar with logo
          AppBarWidget(
            textColor: Colors.white,
            backgroundColor: Colors.black,
            logger: logger,
            iconImage: Icons.search,
            onButtonPressed: () {
              logger.info('Search button pressed');
            },
            text: 'MUFANT Museum',
            showLogo: true, // Show logo in test page
          ),

          // Add content to test scrolling behavior
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 200,
                color: Colors.grey[900],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Logo Centering Test Page',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Check if the logo is perfectly centered',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Text should be bottom-aligned on the left',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Search icon should be on the right',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Add visual guides to help check centering
              Container(
                height: 140,
                color: Colors.grey[800],
                child: Stack(
                  children: [
                    // Center line - vertical guide
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 3,
                        color: Colors.red.withOpacity(0.8),
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 2 - 1.5,
                        ),
                      ),
                    ),
                    // Additional quarter lines for better reference
                    Positioned(
                      left: MediaQuery.of(context).size.width / 4 - 0.5,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 1,
                        color: Colors.blue.withOpacity(0.4),
                      ),
                    ),
                    Positioned(
                      left: 3 * MediaQuery.of(context).size.width / 4 - 0.5,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 1,
                        color: Colors.blue.withOpacity(0.4),
                      ),
                    ),
                    // Center guide text
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'RED LINE = True Screen Center',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'MUFANT logo should align perfectly with this line',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Blue lines = Quarter marks (25% and 75%)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue, fontSize: 11),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Scroll up to see the AppBar with logo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Test with different screen widths simulation
              Container(
                height: 150,
                color: Colors.grey[700],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Test Instructions:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '1. Scroll up to see the AppBar',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2. Check if the logo aligns with the red line',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3. Verify text is left-aligned and icon is right-aligned',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '4. Test scrolling behavior (floating AppBar)',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Add more content to test scrolling
              ...List.generate(
                8,
                (index) => Container(
                  height: 120,
                  color: index % 2 == 0 ? Colors.grey[600] : Colors.grey[500],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Content Block ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scroll up to test floating AppBar behavior',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
