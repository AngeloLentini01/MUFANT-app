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
    this.showAppBarCTAButton = true, // Default to true, hide only on shop page
    this.additionalContent, // Optional additional content below the title
  });

  final Color textColor;
  final Color backgroundColor;
  final Logger logger;
  final IconData iconImage;
  final VoidCallback onButtonPressed;
  final String text;
  final bool showLogo;
  final bool showAppBarCTAButton;
  final Widget? additionalContent;

  @override
  Widget build(BuildContext context) {
    const double appBarTextfontSize = 16;

    // Calculate the height needed for additional content
    // Search bar: 16 (padding top/bottom) + 15*2 (content padding) + 8 (vertical padding) = 54
    // Category tabs: 16 (padding top/bottom) + 12*2 (content padding) + 8 (vertical padding) = 48
    // Total additional height: 54 + 48 + 28 (buffer for safe spacing) = 130
    const double additionalContentHeight = 130;

    return SliverAppBar(
      backgroundColor: backgroundColor == Colors.transparent
          ? kBlackColor
          : backgroundColor,
      floating: true, // App bar will appear when scrolling up
      snap: true, // App bar will snap in/out quickly
      pinned: false,
      // Set proper expandedHeight based on content
      expandedHeight: additionalContent != null
          ? kToolbarHeight + additionalContentHeight
          : kToolbarHeight,
      elevation: 0, // Remove default elevation, we'll add custom shadow
      shadowColor: Colors.transparent, // Remove default shadow
      actions: showAppBarCTAButton
          ? [
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
            ]
          : null,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // For floating SliverAppBar:
          // - At top: maxHeight = expandedHeight
          // - When floating: maxHeight = kToolbarHeight + padding (system adds padding)
          // - We want shadow when floating, not when at top
          final expectedHeight = additionalContent != null
              ? kToolbarHeight + additionalContentHeight
              : kToolbarHeight;
          final isFloating = constraints.maxHeight > expectedHeight;
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
            child: additionalContent != null
                ? SizedBox(
                    width: double.infinity,
                    height: expectedHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Standard AppBar content
                        Container(
                          height: kToolbarHeight,
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: showLogo
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Logo on the left
                                      Image.asset(
                                        'assets/images/logo_senza_scritta.png',
                                        height: 40,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              logger.warning(
                                                'Error loading logo: $error',
                                              );
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
                                      // Text next to logo
                                      Expanded(
                                        child: Text(
                                          text,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: appBarTextfontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: appBarTextfontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        // Additional content (search bar and tabs)
                        Expanded(
                          child: additionalContent!,
                        ),
                      ],
                    ),
                  )
                : FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 8),
                    title: showLogo
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Logo on the left
                              Image.asset(
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
                              const SizedBox(width: 16),
                              // Text next to logo
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: appBarTextfontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: appBarTextfontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
          );
        },
      ),
    );
  }
}
