import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final double borderRadius;
  final Color? gradientTop;
  final Color? gradientBottom;
  final List<double>? gradientStops;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double shadowBlur;

  const CustomAppBarWidget({
    super.key,
    required this.child,
    this.height = AppStyles.appBarHeight,
    this.borderRadius = AppStyles.cornerRadius,
    this.gradientTop,
    this.gradientBottom,
    this.gradientStops,
    this.backgroundColor = AppStyles.background,
    this.borderColor,
    this.borderWidth = AppStyles.borderWidth,
    this.shadowColor,
    this.shadowBlur = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradientTop = gradientTop ?? AppStyles.containerBottom;
    final effectiveGradientBottom = gradientBottom ?? AppStyles.containerTop;
    final effectiveBorderColor = borderColor ?? AppStyles.border;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [effectiveGradientTop, effectiveGradientBottom],
          stops: gradientStops,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        border: Border(
          left: BorderSide(color: effectiveBorderColor, width: borderWidth),
          right: BorderSide(color: effectiveBorderColor, width: borderWidth),
          bottom: BorderSide(color: effectiveBorderColor, width: borderWidth),
        ),
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  blurRadius: shadowBlur,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
