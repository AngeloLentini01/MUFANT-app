import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar_buttons.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    super.key,
    required this.backgroundColor,
    this.currentIndex = 0,
    this.onTap,
  });

  final Color backgroundColor;
  final int currentIndex;
  final Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Add this line
      backgroundColor: backgroundColor,
      selectedItemColor: kWhiteColor,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: kTabBarSelectedButtonTextStyle,
      unselectedLabelStyle: kTabBarUnselectedButtonTextStyle,
      currentIndex: currentIndex,
      onTap: onTap,
      items: tabBarButtons,
    );
  }
}
