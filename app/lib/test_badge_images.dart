import 'package:flutter/material.dart';

class BadgeImageTest extends StatelessWidget {
  const BadgeImageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badge Image Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Testing Badge Images:'),
            const SizedBox(height: 20),
            _buildTestImage(
              'assets/images/badge/badge_space_pioner.png',
              'Space Pioneer',
            ),
            const SizedBox(height: 10),
            _buildTestImage(
              'assets/images/badge/badge_galatic_speaker.png',
              'Galactic Speaker',
            ),
            const SizedBox(height: 10),
            _buildTestImage(
              'assets/images/badge/badge_time_voyager.png',
              'Time Voyager',
            ),
            const SizedBox(height: 10),
            _buildTestImage(
              'assets/images/badge/badge_identify_shifter.png',
              'Identity Shifter',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestImage(String imagePath, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    Text(
                      'Error',
                      style: TextStyle(fontSize: 8, color: Colors.red),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(name)),
      ],
    );
  }
}
