import 'package:flutter/painting.dart';

const double kTabBarSelectedButtonFontSize = 12;
const double kTabBarUnselectedButtonFontSize = 12;

final TextStyle kTabBarSelectedButtonTextStyle = TextStyle(
  fontSize: kTabBarSelectedButtonFontSize,
  fontWeight: FontWeight.bold,
  letterSpacing: 0.6,
);
final TextStyle kTabBarUnselectedButtonTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  letterSpacing: 0.6,
  fontSize: kTabBarUnselectedButtonFontSize,
);
