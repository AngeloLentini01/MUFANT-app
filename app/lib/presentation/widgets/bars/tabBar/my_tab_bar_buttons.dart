import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

List<BottomNavigationBarItem> get tabBarButtons => [
  BottomNavigationBarItem(
    icon: const Icon(Icons.home_outlined),
    activeIcon: const Icon(Icons.home),
    label: 'home'.tr(),
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.shopping_cart_outlined),
    activeIcon: const Icon(Icons.shopping_cart),
    label: 'shop'.tr(),
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.person_outline),
    activeIcon: const Icon(Icons.person),
    label: 'profile'.tr(),
  ),
];
