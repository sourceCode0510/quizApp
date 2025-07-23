import 'package:flutter/material.dart';

class ItemFader extends StatefulWidget {
  const ItemFader({super.key, required this.child});
  final Widget child;

  @override
  State<ItemFader> createState() => _ItemFaderState();
}

class _ItemFaderState extends State<ItemFader> with TickerProviderStateMixin {
  late AnimationController _fadeOutController;
  late AnimationController _fadeInController;

  late Animation<double> _fadeOutAnimation;
  late Animation<Offset> _slideOutAnimation;

  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  Widget? _previousChild;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fadeInController.forward(); // Initial fade-in
  }

  void _initAnimations() {
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );

    _slideOutAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.3, 0), // slide left
        ).animate(
          CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
        );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeInController, curve: Curves.easeInOut),
    );

    _slideInAnimation =
        Tween<Offset>(
          begin: const Offset(0.3, 0), // start right
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _fadeInController, curve: Curves.easeInOut),
        );
  }

  @override
  void didUpdateWidget(covariant ItemFader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _previousChild = oldWidget.child;
      _fadeOutController.reset();
      _fadeInController.reset();

      _fadeOutController.forward().then((_) {
        setState(() {
          _previousChild = null; // clear after fade out
        });
        _fadeInController.forward(); // start new fade in
      });
    }
  }

  @override
  void dispose() {
    _fadeOutController.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_previousChild != null)
          FadeTransition(
            opacity: _fadeOutAnimation,
            child: SlideTransition(
              position: _slideOutAnimation,
              child: _previousChild,
            ),
          ),
        FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideInAnimation,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
