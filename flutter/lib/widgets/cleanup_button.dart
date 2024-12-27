import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/transcription_service.dart';
import '../services/haptic_service.dart';

class CleanupButton extends StatefulWidget {
  final TranscriptionService service;
  final VoidCallback? onCleanupComplete;

  const CleanupButton({
    super.key,
    required this.service,
    this.onCleanupComplete,
  });

  @override
  State<CleanupButton> createState() => _CleanupButtonState();
}

class _CleanupButtonState extends State<CleanupButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _handleCleanup() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    HapticService.medium();
    _controller.forward();

    try {
      await widget.service.cleanup();

      if (mounted) {
        HapticService.success();
        _showSuccessOverlay();
        widget.onCleanupComplete?.call();
      }
    } catch (e) {
      if (mounted) {
        HapticService.error();
        _showErrorSnackbar();
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
        _controller.reverse();
      }
    }
  }

  void _showSuccessOverlay() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Text rensad'),
        backgroundColor: Colors.green,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kunde inte rensa texten'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCleanup =
        widget.service.transcription.isNotEmpty && !_isProcessing;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: ElevatedButton.icon(
          onPressed: canCleanup ? _handleCleanup : null,
          icon: _isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(CupertinoIcons.wand_stars),
          label: Text(_isProcessing ? 'Rensar...' : 'Rensa text'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
