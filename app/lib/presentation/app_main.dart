import 'package:app/presentation/views/tabBarPages/profilePage/profile_page_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/views/tabBarPages/home_page.dart';
import 'package:app/presentation/views/tabBarPages/shop_page.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:app/presentation/styles/colors/generic.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _MainAppState();
}

class _MainAppState extends State<AppMain> {
  int _currentIndex = 0;

  final List<Widget> _tabBarPages = [
    const HomePage(),
    const ShopPage(),
    const ProfilePageAuth(),
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
