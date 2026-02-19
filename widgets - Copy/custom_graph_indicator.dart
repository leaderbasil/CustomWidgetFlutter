import 'dart:math';
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

enum GraphType { line, circle, pillar }

class GraphSegment {
  final String label;
  final String percentage;
  final Color color;

  const GraphSegment({
    required this.label,
    required this.percentage,
    required this.color,
  });

  double get value {
    final sanitized = percentage.replaceAll('%', '').trim();
    return double.tryParse(sanitized) ?? 0.0;
  }
}

class GraphIndicator extends StatelessWidget {
  final List<GraphSegment> segments;
  final Color backgroundColor;
  final double height;
  final GraphType type;

  const GraphIndicator({
    super.key,
    required this.segments,
    this.backgroundColor = const Color(0x55000000),
    this.height = 130.0,
    this.type = GraphType.line,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == GraphType.line)
          _buildLineGraph()
        else if (type == GraphType.circle)
          _buildCircleGraph()
        else
          _buildPillarGraph(),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: segments.map((segment) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: segment.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "${segment.label} ${segment.value.toInt()}%",
                  style: const TextStyle(
                    color: AppStyles.foreground,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLineGraph() {
    double totalInput = segments.fold(0.0, (sum, item) => sum + item.value);
    double divisor = totalInput > 100.0 ? totalInput : 100.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 8.0,
        child: Row(
          children: [
            ...segments.map((segment) {
              double normalizedValue = segment.value / divisor;

              return Expanded(
                flex: (normalizedValue * 1000).toInt(),
                child: Container(color: segment.color),
              );
            }),
            if (totalInput < 100.0)
              Expanded(
                flex: (((100.0 - totalInput) / divisor) * 1000).toInt(),
                child: Container(color: backgroundColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleGraph() {
    return SizedBox(
      height: height,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: _PieChartPainter(
              segments: segments,
              emptyColor: backgroundColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillarGraph() {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: segments.map((segment) {
          double percentageFactor = segment.value.clamp(0.0, 100.0) / 100;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(17),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: percentageFactor,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: segment.color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<GraphSegment> segments;
  final Color emptyColor;

  _PieChartPainter({required this.segments, required this.emptyColor});

  @override
  void paint(Canvas canvas, Size size) {
    double totalValue = segments.fold(0.0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var segment in segments) {
      final sweepAngle = (segment.value / 100) * 2 * pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }

    if (totalValue < 100.0) {
      final remainingAngle = 2 * pi - (startAngle + pi / 2);
      final paint = Paint()
        ..color = emptyColor
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, remainingAngle, true, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
