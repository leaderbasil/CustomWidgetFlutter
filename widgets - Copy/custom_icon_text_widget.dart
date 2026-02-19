import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomIconTextWidget extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final String? value;
  final bool isVertical;
  final double gap;
  final VoidCallback? onPressed;
  final VoidCallback? onIconTap;
  final double iconSize;
  final Color? iconColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isExpanded;
  final TextAlign textAlign;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final double? textSize;
  final Color? textColor;
  final double? valueSize;
  final Color? valueColor;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final bool isCircle;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final bool iconAfterText;

  const CustomIconTextWidget({
    super.key,
    this.icon,
    this.text,
    this.value,
    this.isVertical = false,
    this.gap = 8.0,
    this.onPressed,
    this.onIconTap,
    this.iconSize = 20.0,
    this.iconColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isExpanded = false,
    this.textAlign = TextAlign.center,
    this.backgroundColor,
    this.borderRadius = 50.0,
    this.padding,
    this.borderColor,
    this.borderWidth = 0.0,
    this.textStyle,
    this.textSize,
    this.textColor,
    this.valueSize,
    this.valueColor,
    this.width,
    this.height,
    this.alignment,
    this.isCircle = false,
    this.shadowColor,
    this.shadowBlur = 6.0,
    this.shadowOffset = const Offset(0, 3),
    this.iconAfterText = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = textStyle ?? AppStyles.textBold();
    final TextStyle effectiveLabelStyle = baseStyle.copyWith(
      fontSize: textSize,
      color: textColor,
    );
    final TextStyle effectiveValueStyle = effectiveLabelStyle.copyWith(
      fontSize: valueSize,
      color: valueColor,
      fontWeight: FontWeight.w900,
    );

    Widget? textContentWidget;
    bool hasText = text != null && text!.isNotEmpty;
    bool hasValue = value != null && value!.isNotEmpty;

    if (hasText && hasValue) {
      textContentWidget = Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "$text ", style: effectiveLabelStyle),
            TextSpan(text: value, style: effectiveValueStyle),
          ],
        ),
        textAlign: textAlign,
        overflow: isExpanded ? TextOverflow.ellipsis : null,
      );
    } else if (hasText) {
      textContentWidget = Text(
        text!,
        style: effectiveLabelStyle,
        textAlign: textAlign,
        overflow: isExpanded ? TextOverflow.ellipsis : null,
      );
    } else if (hasValue) {
      textContentWidget = Text(
        value!,
        style: effectiveValueStyle,
        textAlign: textAlign,
        overflow: isExpanded ? TextOverflow.ellipsis : null,
      );
    }

    if (isExpanded && textContentWidget != null) {
      textContentWidget = Flexible(child: textContentWidget);
    }

    Widget? iconWidget;
    if (icon != null) {
      iconWidget = Icon(
        icon,
        size: iconSize,
        color: iconColor ?? (textColor ?? AppStyles.foreground),
      );

      if (onIconTap != null) {
        iconWidget = GestureDetector(
          onTap: onIconTap,
          behavior: HitTestBehavior.opaque,
          child: iconWidget,
        );
      }
    }

    final List<Widget> children = [];
    final Widget spacer = SizedBox(
      width: isVertical ? 0 : gap,
      height: isVertical ? gap : 0,
    );

    if (iconAfterText) {
      if (textContentWidget != null) children.add(textContentWidget);
      if (textContentWidget != null && iconWidget != null) children.add(spacer);
      if (iconWidget != null) children.add(iconWidget);
    } else {
      if (iconWidget != null) children.add(iconWidget);
      if (textContentWidget != null && iconWidget != null) children.add(spacer);
      if (textContentWidget != null) children.add(textContentWidget);
    }

    Widget container = Flex(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );

    final bool needsContainer =
        backgroundColor != null ||
        (borderWidth > 0) ||
        padding != null ||
        width != null ||
        height != null ||
        alignment != null ||
        isCircle ||
        shadowColor != null;

    if (needsContainer) {
      container = Container(
        width: width,
        height: height,
        alignment: alignment,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
          border: borderWidth > 0
              ? Border.all(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth,
                )
              : null,
          boxShadow: shadowColor != null
              ? [
                  BoxShadow(
                    color: shadowColor!,
                    blurRadius: shadowBlur,
                    offset: shadowOffset,
                  ),
                ]
              : null,
        ),
        child: container,
      );
    }

    if (onPressed != null) {
      return InkWell(
        onTap: onPressed,
        customBorder: isCircle ? const CircleBorder() : null,
        borderRadius: isCircle
            ? null
            : BorderRadius.circular(borderRadius > 0 ? borderRadius : 8),
        child: backgroundColor == null
            ? Padding(padding: const EdgeInsets.all(4.0), child: container)
            : container,
      );
    }

    return container;
  }
}
