import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? label;
  final String? hintText;
  final bool isPassword;
  final bool isVisible;
  final ValueChanged<bool>? onVisibilityToggle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final double? width;
  final double height;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final double borderRadius;
  final IconData? icon;
  final Color? iconColor;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onTap;
  final bool autoResize;
  final bool alignTop;
  final int? maxLines;

  const CustomTextFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.isPassword = false,
    this.isVisible = false,
    this.onVisibilityToggle,
    this.controller,
    this.keyboardType,
    this.width,
    this.height = AppStyles.searchBarHeight,
    this.fillColor = AppStyles.background,
    this.borderColor,
    this.focusedBorderColor = AppStyles.blue,
    this.borderWidth = AppStyles.borderWidth,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.borderRadius = AppStyles.fieldRadius,
    this.icon,
    this.iconColor = AppStyles.foreground,
    this.contentPadding,
    this.onTap,
    this.autoResize = false,
    this.alignTop = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color currentBorderColor = _isFocused
        ? (widget.focusedBorderColor ?? AppStyles.blue)
        : (widget.borderColor ?? AppStyles.border);

    Widget textFieldWidget = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.isPassword && !widget.isVisible,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: widget.textStyle ?? AppStyles.textBold(),
      textAlignVertical: widget.alignTop
          ? TextAlignVertical.top
          : TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            AppStyles.textBold(
              color: AppStyles.foreground.withValues(alpha: 0.5),
            ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );

    if (widget.autoResize) {
      textFieldWidget = FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(child: textFieldWidget),
      );
    }

    final EdgeInsetsGeometry geometryPadding =
        widget.contentPadding ??
        EdgeInsets.only(
          left: 16,
          right: widget.isPassword ? 10 : 16,
          top: widget.alignTop ? 12 : 0,
          bottom: widget.alignTop ? 12 : 0,
        );

    Widget field = GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          _focusNode.requestFocus();
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: geometryPadding,
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: currentBorderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Row(
          crossAxisAlignment: widget.alignTop
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Padding(
                padding: EdgeInsets.only(top: widget.alignTop ? 2 : 0),
                child: Icon(widget.icon, color: widget.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(child: textFieldWidget),
            if (widget.isPassword)
              IconButton(
                icon: Icon(
                  widget.isVisible ? Icons.visibility : Icons.visibility_off,
                  color: widget.iconColor,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  if (widget.onVisibilityToggle != null) {
                    widget.onVisibilityToggle!(!widget.isVisible);
                  }
                },
              ),
          ],
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
          field,
        ],
      );
    }

    return field;
  }
}
