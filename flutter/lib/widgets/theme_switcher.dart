import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/theme_service.dart';
import '../core/services/haptic_service.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);  // For continuous pulsing

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20.0,
      ),
    ]).animate(_controller);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        final isDark = themeService.isDarkMode;
        
        return GestureDetector(
          onTap: () {
            HapticService.light();
            themeService.toggleTheme();
            if (isDark) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.grey[800] 
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform.scale(
                scale: isDark ? _pulseAnimation.value : _scaleAnimation.value,
                child: RotationTransition(
                  turns: _rotationAnimation,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isDark 
                          ? CupertinoIcons.moon_fill
                          : CupertinoIcons.sun_max_fill,
                      key: ValueKey(isDark),
                      color: isDark 
                          ? Colors.blue[200]
                          : Colors.orange[400],
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 