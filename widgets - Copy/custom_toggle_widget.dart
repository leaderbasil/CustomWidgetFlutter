import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomToggleWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final double width;
  final double height;
  final double thumbPadding;
  final Duration animationDuration;

  const CustomToggleWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.width = 52.0,
    this.height = 30.0,
    this.thumbPadding = 3.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveTrack = activeTrackColor ?? AppStyles.purple;
    final effectiveInactiveTrack =
        inactiveTrackColor ?? Colors.grey.withValues(alpha: 0.5);
    final effectiveThumb = AppStyles.foreground;

    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: AnimatedContainer(
        duration: animationDuration,
        width: width,
        height: height,
        padding: EdgeInsets.all(thumbPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? effectiveActiveTrack : effectiveInactiveTrack,
          border: Border.all(color: AppStyles.border, width: 1),
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - (thumbPadding * 2),
            height: height - (thumbPadding * 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? (activeThumbColor ?? effectiveThumb)
                  : (inactiveThumbColor ?? effectiveThumb),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
