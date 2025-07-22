import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';

class AnimatedTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const AnimatedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabCount = tabs.length;
          final tabWidth = (constraints.maxWidth - 8 * tabCount) / tabCount;
          final highlightLeft = selectedIndex * (tabWidth + 8) + 4;
          const ellipseTop = 8.0; // offset verticale per tutte le ellissi
          return SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Ellisse animata sotto la tab selezionata, stessa dimensione delle altre
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  left: highlightLeft,
                  top: ellipseTop,
                  width: tabWidth,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPinkColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Row(
                  children: tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final label = entry.value;
                    final isSelected = selectedIndex == index;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => onTabSelected(index),
                          child: Container(
                            margin: const EdgeInsets.only(top: ellipseTop),
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
