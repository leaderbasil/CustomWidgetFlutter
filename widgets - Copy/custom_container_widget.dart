import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final String? label;
  final TextStyle? labelStyle;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? gradientTop;
  final Color? gradientBottom;
  final List<double>? gradientStops;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final VoidCallback? onTap;
  final bool isCircle;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;

  const CustomContainer({
    super.key,
    this.child,
    this.label,
    this.labelStyle,
    this.width,
    this.height,
    this.constraints,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = AppStyles.cornerRadius,
    this.gradientTop,
    this.gradientBottom,
    this.gradientStops,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = AppStyles.borderWidth,
    this.shadowColor,
    this.shadowBlur = 6.0,
    this.shadowOffset = const Offset(0, 3),
    this.onTap,
    this.isCircle = false,
    this.icon,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final BoxShape boxShape = isCircle ? BoxShape.circle : BoxShape.rectangle;
    final BorderRadius? effectiveRadius = isCircle
        ? null
        : BorderRadius.circular(borderRadius);
    final effectiveGradientTop = gradientTop ?? AppStyles.gradientTop;
    final effectiveGradientBottom = gradientBottom ?? AppStyles.gradientBottom;

    final bool useGradient =
        gradientTop != null ||
        gradientBottom != null ||
        backgroundColor == null;

    final Color? effectiveBgColor = useGradient
        ? null
        : (backgroundColor ?? AppStyles.background);

    final Color effectiveBorderColor = borderWidth == 0
        ? Colors.transparent
        : (borderColor ?? AppStyles.border);

    Widget? effectiveChild = child;
    if (effectiveChild == null && icon != null) {
      effectiveChild = Center(
        child: Icon(icon, color: iconColor ?? Colors.white, size: iconSize),
      );
    }

    Widget containerWidget = Container(
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        shape: boxShape,
        borderRadius: effectiveRadius,
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  blurRadius: shadowBlur,
                  offset: shadowOffset,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        shape: isCircle
            ? const CircleBorder()
            : RoundedRectangleBorder(borderRadius: effectiveRadius!),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: effectiveBgColor,
            shape: boxShape,
            borderRadius: effectiveRadius,
            border: Border.all(color: effectiveBorderColor, width: borderWidth),
            gradient: useGradient
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [effectiveGradientTop, effectiveGradientBottom],
                    stops: gradientStops,
                  )
                : null,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveRadius,
            customBorder: isCircle ? const CircleBorder() : null,
            child: Padding(padding: padding, child: effectiveChild),
          ),
        ),
      ),
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label!, style: labelStyle ?? AppStyles.textBold()),
          const SizedBox(height: 8),
          containerWidget,
        ],
      );
    }

    return containerWidget;
  }
}
