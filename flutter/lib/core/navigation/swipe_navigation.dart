import 'package:flutter/material.dart';
import '../services/haptic_service.dart';

class SwipeNavigation extends StatefulWidget {
  final List<Widget> pages;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;
  final bool enableSwipe;
  final Duration transitionDuration;
  final Curve transitionCurve;

  const SwipeNavigation({
    super.key,
    required this.pages,
    this.initialPage = 0,
    this.onPageChanged,
    this.enableSwipe = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
  });

  @override
  State<SwipeNavigation> createState() => _SwipeNavigationState();
}

class _SwipeNavigationState extends State<SwipeNavigation> {
  late PageController _pageController;
  late int _currentPage;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(
      initialPage: widget.initialPage,
      viewportFraction: 1.0,
    );
  }

  Future<void> _handlePageChange(int page) async {
    if (_isAnimating) return;

    _isAnimating = true;
    HapticService.light();

    if (mounted) {
      setState(() => _currentPage = page);
    }

    widget.onPageChanged?.call(page);

    await Future.delayed(widget.transitionDuration);
    _isAnimating = false;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      _isAnimating = false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: widget.enableSwipe
                ? const PageScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            onPageChanged: _handlePageChange,
            itemCount: widget.pages.length,
            itemBuilder: (context, index) {
              return widget.pages[index];
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Text('Page: $_currentPage'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}