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
          final highlightCenter =
              selectedIndex * (tabWidth + 8) + tabWidth / 2 + 4;
          return SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedAlign(
                  alignment: Alignment(
                    -1.0 + 2.0 * selectedIndex / (tabCount - 1),
                    0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: Container(
                    width: tabWidth,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
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
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: LayoutBuilder(
                              builder: (context, tabConstraints) {
                                final tabOffset = index * (tabWidth + 8);
                                final highlightLeft =
                                    (highlightCenter - tabOffset - tabWidth / 2)
                                        .clamp(0.0, tabWidth);
                                final highlightWidth = tabWidth;
                                if (isSelected) {
                                  return CustomPaint(
                                    painter: _TabHighlightTextPainter(
                                      text: label,
                                      highlightLeft: highlightLeft,
                                      highlightWidth: highlightWidth,
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: tabConstraints.maxHeight,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                              },
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

class _TabHighlightTextPainter extends CustomPainter {
  final String text;
  final double highlightLeft;
  final double highlightWidth;
  final TextStyle textStyle;

  _TabHighlightTextPainter({
    required this.text,
    required this.highlightLeft,
    required this.highlightWidth,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpanWhite = TextSpan(text: text, style: textStyle);
    final tpWhite = TextPainter(
      text: textSpanWhite,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tpWhite.layout(minWidth: 0, maxWidth: size.width);
    final dx = (size.width - tpWhite.width) / 2;
    final dy = (size.height - tpWhite.height) / 2;
    tpWhite.paint(canvas, Offset(dx, dy));
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(highlightLeft, 0, highlightWidth, size.height),
    );
    final textSpanBlack = TextSpan(
      text: text,
      style: textStyle.copyWith(color: Colors.black),
    );
    final tpBlack = TextPainter(
      text: textSpanBlack,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tpBlack.layout(minWidth: 0, maxWidth: size.width);
    tpBlack.paint(canvas, Offset(dx, dy));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TabHighlightTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        highlightLeft != oldDelegate.highlightLeft ||
        highlightWidth != oldDelegate.highlightWidth ||
        textStyle != oldDelegate.textStyle;
  }
}
