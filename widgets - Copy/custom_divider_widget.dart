import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomDividerWidget extends StatelessWidget {
  final double indent;
  final double endIndent;
  final Color? color;
  final double? thickness;

  const CustomDividerWidget({
    super.key,
    this.indent = 20.0,
    this.endIndent = 20.0,
    this.color,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = color ?? AppStyles.border;

    return Divider(
      thickness: thickness ?? AppStyles.borderWidth,
      color: effectiveColor.withValues(alpha: 0.5),
      height: 1,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
