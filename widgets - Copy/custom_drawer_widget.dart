import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_divider_widget.dart';
import 'package:polaris_mobile/core/widgets/custom_icon_text_widget.dart';

class CustomDrawerWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? gradientTop;
  final Color? gradientBottom;
  final Color? shadowColor;
  final double shadowBlur;
  final String? headerTitle;
  final IconData? headerIcon;

  const CustomDrawerWidget({
    super.key,
    required this.child,
    this.width = 300.0,
    this.borderRadius = AppStyles.cornerRadius,
    this.borderWidth = AppStyles.borderWidth,
    this.borderColor,
    this.gradientTop,
    this.gradientBottom,
    this.shadowColor,
    this.shadowBlur = 10.0,
    this.headerTitle,
    this.headerIcon,
  });

  static void show(
    BuildContext context, {
    required Widget widget,
    double blurAmount = 7.0,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, a1, a2) => widget,
      transitionBuilder: (ctx, a1, a2, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOutCubic));

        return Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: a1,
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurAmount,
                        sigmaY: blurAmount,
                      ),
                      child: Container(color: Colors.transparent),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        color: const Color.fromARGB(54, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SlideTransition(
                position: slideAnimation,
                child: Material(color: Colors.transparent, child: child),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientTop ?? AppStyles.gradientTop,
            gradientBottom ?? AppStyles.gradientBottom,
          ],
        ),
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(borderRadius),
        ),
        border: Border(
          top: BorderSide(
            color: borderColor ?? AppStyles.border,
            width: borderWidth,
          ),
          bottom: BorderSide(
            color: borderColor ?? AppStyles.border,
            width: borderWidth,
          ),
          right: BorderSide(
            color: borderColor ?? AppStyles.border,
            width: borderWidth,
          ),
        ),
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  blurRadius: shadowBlur,
                  offset: const Offset(2, 0),
                ),
              ]
            : [],
      ),
      child: SafeArea(
        child: (headerTitle != null && headerIcon != null)
            ? Column(
                children: [
                  const SizedBox(height: 40),
                  CustomIconTextWidget(
                    isVertical: true,
                    icon: headerIcon!,
                    text: headerTitle!,
                    iconSize: 45,
                    textStyle: AppStyles.title(fontSize: 28),
                    gap: 12,
                  ),
                  const SizedBox(height: 20),
                  const CustomDividerWidget(indent: 30, endIndent: 30),
                  Expanded(child: child),
                ],
              )
            : child,
      ),
    );
  }
}
