import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomFigureEightAnimation extends StatefulWidget {
  final double opacity;
  final Duration fadeDuration;

  const CustomFigureEightAnimation({
    super.key,
    this.opacity = 1.0,
    this.fadeDuration = Duration.zero,
  });

  @override
  State<CustomFigureEightAnimation> createState() =>
      _CustomFigureEightAnimationState();
}

class _CustomFigureEightAnimationState extends State<CustomFigureEightAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = AppStyles.containerTopBright;
    final double circleSize = size.width * 1.0;

    return RepaintBoundary(
      child: Positioned.fill(
        child: AnimatedOpacity(
          duration: widget.fadeDuration,
          opacity: widget.opacity,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              final t = _floatController.value * 2 * math.pi;
              final dx = math.sin(t) * (size.width * 0.2);
              final dy = math.cos(t * 0.5) * (size.height * 0.15);

              return Transform.translate(
                offset: Offset(dx, dy),
                child: Center(
                  child: RotationTransition(
                    turns: _rotationController,
                    child: SizedBox(
                      width: circleSize,
                      height: circleSize * 1.6,
                      child: _FigureEightStack(
                        circleSize: circleSize,
                        primaryColor: primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FigureEightStack extends StatelessWidget {
  final double circleSize;
  final Color primaryColor;

  const _FigureEightStack({
    required this.circleSize,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppStyles.containerTopBright.withValues(alpha: 0.6),
                  AppStyles.containerTopBright.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppStyles.containerTopBright.withValues(alpha: 0.6),
                  AppStyles.containerTopBright.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
