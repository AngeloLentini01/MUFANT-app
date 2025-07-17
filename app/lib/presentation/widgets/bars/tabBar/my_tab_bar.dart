import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/tab_bar.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar_buttons.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
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
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late AnimationController _rectController;
  late Animation<double> _rectAnimation;
  int _currentTabIndex = 0;
  double _rectTarget = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rectAnimation = AlwaysStoppedAnimation(0);
    _currentTabIndex = widget.currentIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize rectangle position for the initially selected tab
    final tabCount = tabBarButtons(widget.currentIndex).length;
    final tabBarWidth = MediaQuery.of(context).size.width;
    final tabWidth = tabBarWidth / tabCount;
    final rectWidth = tabWidth * 0.4;
    _rectTarget = tabWidth * widget.currentIndex + (tabWidth - rectWidth) / 2;
    _rectAnimation = AlwaysStoppedAnimation(_rectTarget);
  }

  @override
  void didUpdateWidget(covariant MyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The animation is now handled in _onTabTapped
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    _rectController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentTabIndex) return;
    final tabCount = tabBarButtons(widget.currentIndex).length;
    final tabBarWidth = MediaQuery.of(context).size.width;
    final tabWidth = tabBarWidth / tabCount;
    final rectWidth = tabWidth * 0.4;
    final newTarget = tabWidth * index + (tabWidth - rectWidth) / 2;
    _rectAnimation = Tween<double>(begin: _rectTarget, end: newTarget).animate(
      CurvedAnimation(parent: _rectController, curve: Curves.easeInOutCubic),
    );
    _rectController.forward(from: 0);
    _rectTarget = newTarget;
    setState(() {
      _currentTabIndex = index;
    });
    widget.onTap?.call(index);
  }

  Widget _buildTabIcon(int index, bool isSelected) {
    IconData iconData;
    switch (index) {
      case 0:
        iconData = isSelected ? Icons.home : Icons.home_outlined;
        break;
      case 1:
        iconData = isSelected
            ? Icons.shopping_cart
            : Icons.shopping_cart_outlined;
        break;
      case 2:
        iconData = isSelected ? Icons.person : Icons.person_outline;
        break;
      default:
        iconData = Icons.home_outlined;
    }

    return Icon(
      iconData,
      color: isSelected ? kPinkColor : kWhiteColor.withValues(alpha: 0.7),
      size: 26,
    );
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Shop';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = tabBarButtons(_currentTabIndex);
    final tabCount = items.length;
    final tabBarHeight = 100.0;
    final tabBarWidth = MediaQuery.of(context).size.width;
    final tabWidth = tabBarWidth / tabCount;
    final rectWidth = tabWidth * 0.4;
    return SizedBox(
      width: tabBarWidth,
      height: tabBarHeight,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _rectAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_rectAnimation.value, 13),
                child: Container(
                  width: rectWidth,
                  height: 32,
                  decoration: BoxDecoration(
                    color: kPinkColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          // Tab items - full tappable area
          Row(
            children: List.generate(tabCount, (index) {
              final isSelected = index == _currentTabIndex;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onTabTapped(index),
                    child: Container(
                      height: tabBarHeight,
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildTabIcon(index, isSelected),
                          const SizedBox(height: 4),
                          Text(
                            _getTabLabel(index),
                            style:
                                (isSelected
                                        ? kTabBarSelectedButtonTextStyle
                                        : kTabBarUnselectedButtonTextStyle)
                                    .copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : kWhiteColor.withValues(alpha: 0.7),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
