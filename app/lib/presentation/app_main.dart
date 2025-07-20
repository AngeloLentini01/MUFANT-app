import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/views/tabBarPages/home_page.dart';
import 'package:app/presentation/views/tabBarPages/shop_page.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:logging/logging.dart';

final _logger = Logger('AppMain');
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => MainAppState();
}

class MainAppState extends State<AppMain>
    with TickerProviderStateMixin, RouteAware {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _logger.info(
      'didPopNext called. PageController page: ${_pageController.page}',
    );
    // If the profile page is visible, set the tab to Profile
    if (_pageController.hasClients && _pageController.page?.round() == 2) {
      _logger.info(
        'Profile page is visible after pop. Setting tab to 2 (Profile).',
      );
      setTab(2);
    }
  }

  void setTab(int index) {
    _logger.info(
      'setTab called with index: ${index}, currentIndex: ${currentIndex}',
    );
    if (index == currentIndex) return;

    final distance = (index - currentIndex).abs();

    setState(() {
      _logger.info(
        'setTab setState: changing currentIndex from ${currentIndex} to ${index}',
      );
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
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          _logger.info(
            'PageView onPageChanged: index=${index}, previous currentIndex=${currentIndex}',
          );
          setState(() {
            currentIndex = index;
            if (index == 0) {
              homePageKey = UniqueKey();
            }
          });
          _logger.info(
            'PageView onPageChanged: new currentIndex=${currentIndex}',
          );
        },
        children: tabBarPages,
      ),
      bottomNavigationBar: MyTabBar(
        backgroundColor: kBlackColor,
        currentIndex: currentIndex,
        onTap: (index) {
          int previousIndex = currentIndex;
          _logger.info(
            'TabBar onTap: switching from ${previousIndex} to ${index}',
          );
          setTab(index);
        },
      ),
    );
  }
}
