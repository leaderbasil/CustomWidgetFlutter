import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris_mobile/core/routing/app_router.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_button_widget.dart';
import 'package:polaris_mobile/core/widgets/custom_container_widget.dart';
import 'package:polaris_mobile/core/widgets/custom_icon_text_widget.dart';

class DrawerNavigationList extends StatelessWidget {
  final String currentPage;
  final List<Map<String, dynamic>> items;

  const DrawerNavigationList({
    super.key,
    required this.currentPage,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final isActive = item['label'] == currentPage;

              if (isActive) {
                return CustomContainer(
                  backgroundColor: AppStyles.foreground.withValues(alpha: 1.0),
                  borderRadius: 50,
                  borderWidth: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: _buildRow(item, isActive: true),
                );
              } else {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.go(item['route']);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: _buildRow(item, isActive: false),
                  ),
                );
              }
            },
          ),
        ),
        CustomButtonWidget(
          onPressed: () {
            Navigator.pop(context);
            context.go(AppRouter.homeScreen);
          },
          width: 150,
          height: 45,
          icon: Icons.home,
          fillColor: AppStyles.blue,
          iconColor: AppStyles.white,
          iconSize: 25,
          text: "Home",
          borderRadius: 25,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildRow(Map<String, dynamic> item, {required bool isActive}) {
    return CustomIconTextWidget(
      icon: item['icon'],
      text: item['label'],
      iconColor: isActive ? AppStyles.background : AppStyles.foreground,
      textStyle: AppStyles.textBold(
        color: isActive ? AppStyles.background : AppStyles.foreground,
      ),
      gap: 16,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }
}
