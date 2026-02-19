import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_icon_text_widget.dart';

class TabItem {
  final String label;
  final IconData? icon;
  final Color? selectedColor;
  final Widget content;

  const TabItem({
    required this.label,
    required this.content,
    this.icon,
    this.selectedColor,
  });
}

class CustomTabPageView extends StatefulWidget {
  final List<TabItem> tabs;
  final ValueChanged<int>? onTabChanged;
  const CustomTabPageView({super.key, required this.tabs, this.onTabChanged});

  @override
  State<CustomTabPageView> createState() => _CustomTabPageViewState();
}

class _CustomTabPageViewState extends State<CustomTabPageView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isProgrammaticScroll = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: _CustomTabSlider(
            tabs: widget.tabs,
            selectedIndex: _currentIndex,
            onTabSelected: (index) {
              setState(() {
                _currentIndex = index;
                _isProgrammaticScroll = true;
              });
              widget.onTabChanged?.call(index);

              _pageController
                  .animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  )
                  .then((_) {
                    _isProgrammaticScroll = false;
                  });
            },
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.tabs.length,
            onPageChanged: (index) {
              if (!_isProgrammaticScroll) {
                setState(() => _currentIndex = index);
                widget.onTabChanged?.call(index);
              }
            },
            itemBuilder: (context, index) {
              return widget.tabs[index].content;
            },
          ),
        ),
      ],
    );
  }
}

class _CustomTabSlider extends StatelessWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const _CustomTabSlider({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: isSelected ? Curves.easeOutBack : Curves.easeOut,
                margin: EdgeInsets.symmetric(horizontal: isSelected ? 4 : 0),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 12 : 8,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isSelected
                      ? (tab.selectedColor ?? AppStyles.foreground)
                      : AppStyles.containerTop.withValues(alpha: 0.7),
                ),
                child: CustomIconTextWidget(
                  icon: tab.icon ?? Icons.circle,
                  text: tab.label,
                  iconColor: isSelected
                      ? AppStyles.background
                      : AppStyles.foreground,
                  textStyle: AppStyles.textBold(
                    color: isSelected
                        ? AppStyles.background
                        : AppStyles.foreground,
                    fontSize: isSelected ? 15 : 14,
                  ),
                  gap: 6,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
