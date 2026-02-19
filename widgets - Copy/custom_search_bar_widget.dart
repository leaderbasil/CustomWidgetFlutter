import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomSearchBarWidget extends StatefulWidget {
  final List<Map<String, dynamic>> allItems;
  final Function(List<Map<String, dynamic>>) onSearchResults;
  final List<String> searchKeys;
  final double? width;
  final double height;
  final String hintText;
  final IconData icon;
  final Color? fillColor;

  const CustomSearchBarWidget({
    super.key,
    required this.allItems,
    required this.onSearchResults,
    required this.searchKeys,
    this.width,
    this.height = AppStyles.searchBarHeight,
    this.hintText = "Search...",
    this.icon = Icons.search,
    this.fillColor,
  });

  @override
  State<CustomSearchBarWidget> createState() => _CustomSearchBarWidgetState();
}

class _CustomSearchBarWidgetState extends State<CustomSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      widget.onSearchResults(widget.allItems);
      return;
    }

    final lowerQuery = query.toLowerCase().trim();

    List<Map<String, dynamic>> dummyListData = widget.allItems.where((item) {
      for (String key in widget.searchKeys) {
        if (item.containsKey(key) && item[key] != null) {
          final String value = item[key].toString().toLowerCase();
          if (value.contains(lowerQuery)) {
            return true;
          }
        }
      }
      return false;
    }).toList();

    widget.onSearchResults(dummyListData);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double desiredFontSize = 15.5;
    const double desiredIconSize = 26.0;

    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.fillColor ?? AppStyles.background.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(
          color: AppStyles.border,
          width: AppStyles.borderWidth,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: _filterSearchResults,
        style: AppStyles.textBold(fontSize: desiredFontSize),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppStyles.textBold(
            fontSize: desiredFontSize,
            color: AppStyles.foreground.withValues(alpha: 0.8),
          ),
          prefixIcon: Icon(
            widget.icon,
            color: AppStyles.foreground,
            size: desiredIconSize,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
