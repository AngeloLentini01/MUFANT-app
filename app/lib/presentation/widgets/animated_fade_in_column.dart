import 'package:flutter/material.dart';

/// A widget that animates its children in with a fade/slide from top to bottom.
class AnimatedFadeInColumn extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration delayBetween;
  final Curve curve;

  const AnimatedFadeInColumn({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
    this.delayBetween = const Duration(milliseconds: 120),
    this.curve = Curves.easeOut,
  });

  @override
  State<AnimatedFadeInColumn> createState() => _AnimatedFadeInColumnState();
}

class _AnimatedFadeInColumnState extends State<AnimatedFadeInColumn>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(vsync: this, duration: widget.duration),
    );
    _fadeAnimations = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: widget.curve))
        .toList();
    _slideAnimations = _controllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: c, curve: widget.curve)),
        )
        .toList();
    _runAnimations();
  }

  Future<void> _runAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(widget.delayBetween);
      if (mounted) _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(widget.children.length, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) => FadeTransition(
            opacity: _fadeAnimations[i],
            child: SlideTransition(position: _slideAnimations[i], child: child),
          ),
          child: widget.children[i],
        );
      }),
    );
  }
}
