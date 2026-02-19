import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_button_widget.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget child;
  final Widget? actionWidget;
  final CustomButtonWidget confirmButton;
  final CustomButtonWidget cancelButton;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? gradientTop;
  final Color? gradientBottom;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final double blurAmount;
  final Color overlayColor;

  const CustomDialogWidget({
    super.key,
    required this.title,
    this.titleColor,
    required this.child,
    this.actionWidget,
    required this.confirmButton,
    required this.cancelButton,
    this.width = 320.0,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.borderRadius = AppStyles.dialogRadius,
    this.gradientTop,
    this.gradientBottom,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = AppStyles.borderWidth,
    this.shadowColor,
    this.shadowBlur = 10.0,
    this.shadowOffset = const Offset(0, 5),
    this.blurAmount = 7.0,
    this.overlayColor = const Color(0x36000000),
  });

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGradientTop = gradientTop ?? AppStyles.gradientTop;
    final effectiveGradientBottom = gradientBottom ?? AppStyles.gradientBottom;

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: overlayColor),
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width,
              height: height,
              padding: padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [effectiveGradientTop, effectiveGradientBottom],
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor ?? AppStyles.border,
                  width: borderWidth,
                ),
                boxShadow: shadowColor != null
                    ? [
                        BoxShadow(
                          color: shadowColor!,
                          blurRadius: shadowBlur,
                          offset: shadowOffset,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppStyles.shadow,
                          blurRadius: shadowBlur,
                          offset: shadowOffset,
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title.isNotEmpty || actionWidget != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (actionWidget != null)
                          Opacity(
                            opacity: 0,
                            child: IgnorePointer(child: actionWidget),
                          )
                        else
                          const SizedBox(width: 24), // Placeholder if needed

                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppStyles.title(
                              color: titleColor ?? AppStyles.foreground,
                            ),
                          ),
                        ),

                        if (actionWidget != null)
                          actionWidget!
                        else
                          const SizedBox(width: 24), // Balance the placeholder
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  child,
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: cancelButton),
                      const SizedBox(width: 12),
                      Expanded(child: confirmButton),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
