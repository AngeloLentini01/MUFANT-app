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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == widget.currentIndex) return;

    // Trigger scale animation
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Animate the background slide
    _animationController.forward().then((_) {
      _animationController.reset();
    });

    // Call the original onTap
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
    final items = tabBarButtons(widget.currentIndex);
    final tabCount = items.length;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey[800]!.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Animated background rectangle - smaller size
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            left:
                (MediaQuery.of(context).size.width / tabCount) *
                    widget.currentIndex +
                (MediaQuery.of(context).size.width / tabCount) * 0.3,
            top: 13, // moved up from 16
            child: Container(
              width: (MediaQuery.of(context).size.width / tabCount) * 0.4,
              height: 32,
              decoration: BoxDecoration(
                color: kPinkColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Tab items - full tappable area
          Row(
            children: List.generate(tabCount, (index) {
              final isSelected = index == widget.currentIndex;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onTabTapped(index),
                    child: Container(
                      height: 100,
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
                                      color: kWhiteColor.withValues(alpha: 0.7),
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
