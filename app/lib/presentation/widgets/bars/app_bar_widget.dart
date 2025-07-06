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
    this.showLogo = false, // Default to false, only show on homepage
  });

  final Color textColor;
  final Color backgroundColor;
  final Logger logger;
  final IconData iconImage;
  final VoidCallback onButtonPressed;
  final String text;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    const double appBarTextfontSize = 16;
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
      leading: showLogo
          ? Container()
          : null, // Empty container to suppress back button
      title: showLogo
          ? SizedBox(
              height: kToolbarHeight,
              child: Stack(
                clipBehavior: Clip.none, // Allow overflow
                children: [
                  // Logo in the center
                  Center(
                    child: Image.asset(
                      'assets/images/logo_senza_scritta.png',
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
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
                  ),
                  // Text on the left and bottom
                  Positioned(
                    left: -56, // Move text to the actual left edge of AppBar
                    bottom: 4,
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: appBarTextfontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: kToolbarHeight,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: appBarTextfontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
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
    );
  }
}
