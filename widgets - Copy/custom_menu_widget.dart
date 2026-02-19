import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomMenuWidget extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? hoverColor;
  final double? fontSize;
  final double menuBorderRadius;
  final Map<String, IconData>? itemIcons;

  const CustomMenuWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.iconColor,
    this.backgroundColor,
    this.hoverColor,
    this.fontSize,
    this.menuBorderRadius = 25,
    this.itemIcons,
  });

  @override
  State<CustomMenuWidget> createState() => _CustomMenuWidgetState();
}

class _CustomMenuWidgetState extends State<CustomMenuWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - offset.dy - size.height;
    final bool showAbove = spaceBelow < 200;

    _overlayEntry = _createOverlayEntry(size, showAbove);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isOpen = true;
    });
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry(Size buttonSize, bool showAbove) {
    final Color menuBgColor =
        widget.backgroundColor ?? AppStyles.containerTop.withValues(alpha: 0.7);
    final Color textColor = AppStyles.foreground;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              behavior: HitTestBehavior.opaque,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
            ),
          ),
          Positioned(
            width: 180,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(
                -180 + buttonSize.width,
                showAbove ? -10.0 : buttonSize.height + 5.0,
              ),
              followerAnchor: showAbove
                  ? Alignment.bottomRight
                  : Alignment.topLeft,
              child: Material(
                elevation: 8,
                color: menuBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.menuBorderRadius),
                  side: BorderSide(color: AppStyles.border, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    children: widget.items.map((item) {
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item);
                          _closeMenu();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              if (widget.itemIcons != null &&
                                  widget.itemIcons!.containsKey(item)) ...[
                                Icon(
                                  widget.itemIcons![item],
                                  size: 20,
                                  color: textColor,
                                ),
                                const SizedBox(width: 12),
                              ],
                              Expanded(
                                child: Text(
                                  item,
                                  style: AppStyles.textBold(
                                    color: textColor,
                                    fontSize: widget.fontSize ?? 14,
                                  ),
                                ),
                              ),
                            ],
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

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          Icons.more_vert,
          color: widget.iconColor ?? AppStyles.foreground,
          size: 26,
        ),
        onPressed: _toggleMenu,
      ),
    );
  }
}
