import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'custom_button_widget.dart';

class CustomScrollDownButton extends StatefulWidget {
  final ScrollController scrollController;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  final IconData icon;

  const CustomScrollDownButton({
    super.key,
    required this.scrollController,
    this.size = 40.0,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.keyboard_arrow_down_rounded,
  });

  @override
  State<CustomScrollDownButton> createState() => _CustomScrollDownButtonState();
}

class _CustomScrollDownButtonState extends State<CustomScrollDownButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!widget.scrollController.hasClients) return;
    final position = widget.scrollController.position;
    final bool canScrollDown =
        position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent > 0;
    if (_isVisible != canScrollDown) {
      setState(() {
        _isVisible = canScrollDown;
      });
    }
  }

  void _scrollToNext() {
    if (!widget.scrollController.hasClients) return;
    final double current = widget.scrollController.offset;
    final double max = widget.scrollController.position.maxScrollExtent;
    final double moveAmount = 300.0;
    final double target = (current + moveAmount).clamp(0.0, max);

    widget.scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveBgColor =
        widget.backgroundColor ??
        AppStyles.containerTopBright.withValues(alpha: 0.85);

    final Color effectiveIconColor = widget.iconColor ?? AppStyles.foreground;

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: !_isVisible,
        child: CustomButtonWidget(
          isCircle: true,
          width: widget.size,
          height: widget.size,
          fillColor: effectiveBgColor,
          iconColor: effectiveIconColor,
          icon: widget.icon,
          iconSize: widget.size * 0.57,
          shadowColor: Colors.black26,
          shadowBlur: 8,
          onPressed: _scrollToNext,
        ),
      ),
    );
  }
}
