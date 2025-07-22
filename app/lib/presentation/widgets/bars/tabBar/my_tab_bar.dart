import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/tab_bar.dart';
import 'package:app/presentation/widgets/bars/tabBar/my_tab_bar_buttons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logging/logging.dart';

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
  static final Logger _logger = Logger('MyTabBar');
  late AnimationController _rectController;
  late Animation<double> _rectAnimation = AlwaysStoppedAnimation(0.0);
  double _rectCurrent = 0.0;
  double _rectTarget = 0.0;

  @override
  void initState() {
    super.initState();
    _rectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rectController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rectCurrent = _rectTarget;
        _logger.fine(
          'Animation completed. _rectCurrent updated to $_rectCurrent',
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabCount = tabBarButtons(widget.currentIndex).length;
    final tabBarWidth = MediaQuery.of(context).size.width;
    final tabWidth = tabBarWidth / tabCount;
    final rectWidth = tabWidth * 0.4;
    final initialTarget =
        tabWidth * widget.currentIndex + (tabWidth - rectWidth) / 2;
    _rectCurrent = initialTarget;
    _rectTarget = initialTarget;
    _rectAnimation = AlwaysStoppedAnimation(initialTarget);
    _logger.info(
      'didChangeDependencies: Set initial highlight position to $initialTarget for index ${widget.currentIndex}',
    );
  }

  @override
  void dispose() {
    _rectController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _logger.info(
      'Tab tapped: $index, widget.currentIndex=${widget.currentIndex}',
    );
    if (index == widget.currentIndex) return;
    widget.onTap?.call(index);
  }

  void _animateHighlight(int newIndex) {
    final tabCount = tabBarButtons(widget.currentIndex).length;
    final tabBarWidth = MediaQuery.of(context).size.width;
    final tabWidth = tabBarWidth / tabCount;
    final rectWidth = tabWidth * 0.4;
    final newTarget = tabWidth * newIndex + (tabWidth - rectWidth) / 2;
    _logger.fine('Animating highlight from $_rectCurrent to $newTarget');
    _rectTarget = newTarget;
    _rectAnimation = Tween<double>(begin: _rectCurrent, end: newTarget).animate(
      CurvedAnimation(parent: _rectController, curve: Curves.easeInOutCubic),
    );
    _rectController.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant MyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _logger.info(
        'didUpdateWidget: currentIndex changed from ${oldWidget.currentIndex} to ${widget.currentIndex}',
      );
      _animateHighlight(widget.currentIndex);
    }
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
        return 'home'.tr();
      case 1:
        return 'shop'.tr();
      case 2:
        return 'profile'.tr();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = tabBarButtons(widget.currentIndex);
    final tabCount = items.length;
    final tabBarHeight = 100.0;
    final tabBarWidth = MediaQuery.of(context).size.width;
    final tabWidth = tabBarWidth / tabCount;
    final rectWidth = tabWidth * 0.4;
    _logger.fine(
      'build: highlight at ${_rectAnimation.value}, selected index: ${widget.currentIndex}',
    );
    return SizedBox(
      width: tabBarWidth,
      height: tabBarHeight,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _rectAnimation,
            builder: (context, child) {
              return Positioned(
                left: _rectAnimation.value,
                top: 13,
                width: rectWidth,
                height: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: kPinkColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          Row(
            children: List.generate(tabCount, (index) {
              final isSelected = index == widget.currentIndex;
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
