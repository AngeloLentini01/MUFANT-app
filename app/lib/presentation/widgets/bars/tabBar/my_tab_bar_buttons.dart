import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/presentation/styles/colors/generic.dart';

List<BottomNavigationBarItem> tabBarButtons(int selectedIndex) => [
  BottomNavigationBarItem(
    icon: selectedIndex == 0
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: kPinkColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: kPinkColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.home, color: kPinkColor, size: 26),
          )
        : const Icon(Icons.home_outlined, size: 26),
    label: 'home'.tr(),
  ),
  BottomNavigationBarItem(
    icon: selectedIndex == 1
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: kPinkColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: kPinkColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.shopping_cart, color: kPinkColor, size: 26),
          )
        : const Icon(Icons.shopping_cart_outlined, size: 26),
    label: 'shop'.tr(),
  ),
  BottomNavigationBarItem(
    icon: selectedIndex == 2
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: kPinkColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: kPinkColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.person, color: kPinkColor, size: 26),
          )
        : const Icon(Icons.person_outline, size: 26),
    label: 'profile'.tr(),
  ),
];
