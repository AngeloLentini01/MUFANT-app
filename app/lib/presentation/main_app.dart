import 'package:app/presentation/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/views/home_page.dart';
import 'package:app/presentation/views/shop_page.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:app/presentation/styles/colors/generic.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _tabBarPages = [
    const HomePage(),
    const ShopPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabBarPages),
      bottomNavigationBar: MyTabBar(
        backgroundColor: kBlackColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
