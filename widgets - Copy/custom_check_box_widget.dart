import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final Color? fillColor;
  final Color? iconColor;

  const CustomCheckBoxWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.fillColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: fillColor ?? AppStyles.purple,
                checkColor: iconColor ?? AppStyles.white,
                side: BorderSide(
                  color: AppStyles.foreground.withValues(alpha: 0.5),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: AppStyles.textBold(
                  fontSize: 13,
                  color: AppStyles.foreground.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
