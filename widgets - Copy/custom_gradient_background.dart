import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomGradientBackground extends StatelessWidget {
  const CustomGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            AppStyles.purple.withValues(alpha: 0.25),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
