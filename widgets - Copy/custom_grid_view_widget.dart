import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_container_widget.dart';
import 'package:polaris_mobile/core/widgets/custom_icon_text_widget.dart';

class DashboardGridView extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;
  final Function(Map<String, dynamic>) onItemTap;

  const DashboardGridView({
    super.key,
    required this.menuItems,
    required this.onItemTap,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.85,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildGridItem(context, item);
      },
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    final String label = item['label'] ?? 'Untitled';
    final IconData icon = item['icon'] ?? Icons.circle;
    final Color baseColor = item['color'] ?? AppStyles.blue;

    return CustomContainer(
      onTap: () => onItemTap(item),
      gradientTop: baseColor.withValues(alpha: 0.45),
      gradientBottom: baseColor.withValues(alpha: 0.05),
      borderColor: baseColor.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(8),
      child: Center(
        child: CustomIconTextWidget(
          icon: icon,
          text: label,
          isVertical: true,
          iconSize: 40,
          iconColor: baseColor,
          textStyle: AppStyles.textBolder(fontSize: 12),
          gap: 12,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
