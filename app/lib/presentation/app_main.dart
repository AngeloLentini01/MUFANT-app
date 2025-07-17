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

class MainAppState extends State<AppMain> with TickerProviderStateMixin {
  int currentIndex = 0;
  Key homePageKey = UniqueKey(); // Force rebuild when needed
  late final PageController _pageController;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void setTab(int index) {
    if (index == currentIndex) return;

    final distance = (index - currentIndex).abs();

    setState(() {
      currentIndex = index;
      if (index == 0) {
        homePageKey = UniqueKey();
      }
    });

    // Animate with a scrolling-like effect
    _animationController.reset();
    _animationController.forward();

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300 + (distance * 50)),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goToProfileTab() {
    setTab(2);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabBarPages = [
      HomePage(key: homePageKey),
      ShopPage(onGoToProfile: _goToProfileTab),
      const ProfilePage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
            if (index == 0) {
              homePageKey = UniqueKey();
            }
          });
        },
        children: tabBarPages,
      ),
      bottomNavigationBar: MyTabBar(
        backgroundColor: kBlackColor,
        currentIndex: currentIndex,
        onTap: (index) {
          int previousIndex = currentIndex;
          _logger.info('Tab switched from $previousIndex to $index');
          setTab(index);
        },
      ),
    );
  }
}
