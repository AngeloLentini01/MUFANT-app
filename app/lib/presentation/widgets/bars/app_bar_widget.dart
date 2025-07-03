import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:app/presentation/styles/colors/generic.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.logger,
    required this.iconImage,
    required this.onButtonPressed,
    required this.text,
  });

  final Color textColor;
  final Color backgroundColor;
  final Logger logger;
  final IconData iconImage;
  final VoidCallback onButtonPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColor == Colors.transparent
          ? kBlackColor
          : backgroundColor,
      floating: true, // App bar will appear when scrolling up
      snap: true, // App bar will snap in/out quickly
      pinned: false,
      expandedHeight: kToolbarHeight,
      elevation: 0, // Remove default elevation, we'll add custom shadow
      shadowColor: Colors.transparent, // Remove default shadow
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 14.0),
          child: IconButton(
            icon: Icon(iconImage),
            color: kWhiteColor,
            onPressed: () {
              // TODO: Implement search functionality
              logger.info('button pressed');
              onButtonPressed();
            },
            tooltip: '',
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // For floating SliverAppBar:
          // - At top: maxHeight = expandedHeight (kToolbarHeight)
          // - When floating: maxHeight = kToolbarHeight + padding (system adds padding)
          // - We want shadow when floating, not when at top
          final isFloating = constraints.maxHeight > kToolbarHeight;
          final showShadow = isFloating;

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor == Colors.transparent
                  ? kBlackColor
                  : backgroundColor,
              boxShadow: showShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 8),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/logo_senza_scritta.png',
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Replace print with logger
                      logger.warning('Error loading logo: $error');
                      return Text(
                        'MUFANT',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
