import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/views/tabBarPages/home_page.dart';
import 'package:app/presentation/views/tabBarPages/shop_page.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:logging/logging.dart';

final _logger = Logger('AppMain');

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => MainAppState();
}

class MainAppState extends State<AppMain> {
  int currentIndex = 0;
  Key homePageKey = UniqueKey(); // Force rebuild when needed

  void _goToProfileTab() {
    setState(() {
      currentIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabBarPages = [
      HomePage(key: homePageKey),
      ShopPage(onGoToProfile: _goToProfileTab),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: tabBarPages),
      bottomNavigationBar: MyTabBar(
        backgroundColor: kBlackColor,
        currentIndex: currentIndex,
        onTap: (index) {
          // Store the previous index
          int previousIndex = currentIndex;

          _logger.info('Tab switched from $previousIndex to $index');

          setState(() {
            currentIndex = index;

            // Force rebuild HomePage when switching to it from Profile tab
            // (in case user logged in)
            if (index == 0 && previousIndex == 2) {
              _logger.info('Rebuilding HomePage after returning from Profile');
              homePageKey = UniqueKey();
            }
          });
        },
      ),
    );
  }
}
