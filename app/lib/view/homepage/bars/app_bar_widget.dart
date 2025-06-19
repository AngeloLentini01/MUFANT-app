import 'package:app/view/homepage/others/search_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.logger,
  });

  final Color textColor;
  final Color backgroundColor;
  final Logger logger;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Image.asset(
          'assets/images/logo.png',
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Replace print with logger
            logger.warning('Error loading logo: $error');
            return Text(
              'MUFANT',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      actions: [SearchIconButton()],
    );
  }
}
