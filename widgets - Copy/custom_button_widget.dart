import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? fillColor;
  final Color? disabledFillColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final Color? shadowColor;
  final double shadowBlur;
  final TextStyle? textStyle;
  final Color? textColor;
  final IconData? icon;
  final bool isDisabled;
  final bool isCircle;
  final double? iconSize;
  final Color? iconColor;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const CustomButtonWidget({
    super.key,
    this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fillColor,
    this.disabledFillColor = AppStyles.containerTop,
    this.borderColor,
    this.borderWidth = 0.0,
    this.borderRadius = AppStyles.cornerRadius,
    this.shadowColor,
    this.shadowBlur = 8.0,
    this.textStyle,
    this.textColor,
    this.icon,
    this.isDisabled = false,
    this.isCircle = false,
    this.iconSize,
    this.iconColor,
    this.textAlign,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveShadowColor =
        shadowColor ?? AppStyles.shadow.withValues(alpha: 0.3);

    final double effectiveHeight = height ?? 48.0;

    final Color effectiveFillColor = isDisabled
        ? (disabledFillColor ?? AppStyles.grey)
        : (fillColor ?? AppStyles.blue);

    final TextStyle baseStyle =
        textStyle ?? AppStyles.textBold(color: Colors.white);

    final Color effectiveContentColor = isDisabled
        ? Colors.white.withValues(alpha: 0.7)
        : (textColor ?? baseStyle.color ?? Colors.white);

    final TextStyle effectiveTextStyle = baseStyle.copyWith(
      color: effectiveContentColor,
    );

    final double effectiveIconSize =
        iconSize ?? (effectiveTextStyle.fontSize ?? 14.0) + 4;

    return Container(
      width: width,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
        boxShadow: shadowBlur > 0
            ? [
                BoxShadow(
                  color: effectiveShadowColor,
                  blurRadius: shadowBlur,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: isCircle
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
          onTap: isDisabled ? null : onPressed,
          child: Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: width == null ? 16.0 : 0.0),
            child: Center(
              widthFactor: 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor ?? effectiveContentColor,
                      size: effectiveIconSize,
                    ),
                    if (text != null) const SizedBox(width: 8),
                  ],
                  if (text != null)
                    Text(
                      text!,
                      style: effectiveTextStyle,
                      textAlign: textAlign,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
