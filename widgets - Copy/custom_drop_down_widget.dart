import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomDropdownWidget extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final Color? textColor;
  final Color? fillColor;
  final Color? borderColor;
  final double? fontSize;
  final double borderRadius;
  final double menuBorderRadius;
  final IconData? prefixIcon;
  final Color? iconColor;
  final String? label;
  final TextStyle? labelStyle;

  const CustomDropdownWidget({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.textColor,
    this.fillColor,
    this.borderColor,
    this.fontSize,
    this.borderRadius = AppStyles.fieldRadius,
    this.menuBorderRadius = AppStyles.fieldRadius,
    this.prefixIcon,
    this.iconColor,
    this.label,
    this.labelStyle,
  });

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = _createOverlayEntry(size);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry(Size buttonSize) {
    final Color menuColor = AppStyles.gradientTop;
    final Color effectiveTextColor = widget.textColor ?? AppStyles.foreground;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.opaque,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withValues(alpha: 0.2)),
              ),
            ),
          ),

          Positioned(
            width: buttonSize.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, buttonSize.height + 8.0),
              child: Material(
                elevation: 8,
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: menuColor,
                    borderRadius: BorderRadius.circular(
                      widget.menuBorderRadius,
                    ),
                    border: Border.all(color: AppStyles.border, width: 1),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.items.map((item) {
                      final bool isSelected = item == widget.value;
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item);
                          _closeDropdown();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppStyles.foreground.withValues(alpha: 0.1)
                                : Colors.transparent,
                          ),
                          child: _buildItemText(
                            item,
                            color: effectiveTextColor,
                            fontSize: widget.fontSize,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemText(String text, {required Color color, double? fontSize}) {
    if (widget.prefixIcon != null) {
      return Row(
        children: [
          Icon(
            widget.prefixIcon,
            size: 20,
            color: widget.iconColor ?? AppStyles.foreground,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppStyles.textBold(color: color, fontSize: fontSize ?? 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: AppStyles.textBold(color: color, fontSize: fontSize ?? 15),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor = widget.textColor ?? AppStyles.foreground;
    final Color effectiveFillColor = widget.fillColor ?? AppStyles.containerTop;
    final Color effectiveBorderColor = widget.borderColor ?? AppStyles.border;
    final String displayText =
        widget.value ?? (widget.hint ?? widget.items.first);
    final bool isHint = widget.value == null;

    Widget dropdown = CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: AppStyles.searchBarHeight,
          decoration: BoxDecoration(
            color: effectiveFillColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isOpen ? AppStyles.purple : effectiveBorderColor,
              width: AppStyles.borderWidth,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildItemText(
                  displayText,
                  color: isHint
                      ? effectiveTextColor.withValues(alpha: 0.5)
                      : effectiveTextColor,
                  fontSize: widget.fontSize,
                ),
              ),
              Icon(
                _isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: effectiveTextColor,
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label!, style: widget.labelStyle ?? AppStyles.textBold()),
          const SizedBox(height: 8),
          dropdown,
        ],
      );
    }

    return dropdown;
  }
}
