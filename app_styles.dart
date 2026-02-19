import 'package:flutter/material.dart';

class AppStyles {
  //Colors
  static const Color red = Color(0xFFf7768e);
  static const Color green = Color(0xFF8AD08C);
  static const Color blue = Color(0xFF7DA6FF);
  static const Color lightBlue = Color(0xFFA0CBFF);
  static const Color purple = Color(0xFFbb9af7);
  static const Color orange = Color(0xFFFFAB52);
  static const Color yellow = Color(0xFFEDD55F);
  static const Color pink = Color(0xFFFF96DC);
  static const Color cyan = Color(0xFF6ADFFF);
  static const Color grey = Color.fromARGB(255, 171, 171, 171);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  static const Color foreground = Color(0xFFc0caf5);
  static const Color background = Color(0xFF202235);
  static const Color containerTop = Color(0xFF47497D);
  static const Color containerBottom = Color(0xFF30354D);
  static const Color containerTopBright = Color(0xFF5E60A7);
  static const Color containerBottomBright = Color(0xFF393F5D);
  static const Color borderColor = Color(0xFF50628B);

  static Color get border => borderColor.withValues(alpha: 0.75);
  static Color get gradientTop => containerTop.withValues(alpha: 0.8);
  static Color get gradientBottom => containerBottom.withValues(alpha: 0.65);
  static Color get shadow => Colors.black54;
  static Color get gradientTopBright =>
      containerTopBright.withValues(alpha: 0.8);
  static Color get gradientBottomBright =>
      containerBottomBright.withValues(alpha: 0.65);

  //Dimensions
  static const double borderWidth = 2.3;
  static const double cornerRadius = 33.0;
  static const double fieldRadius = 20.0;
  static const double dialogRadius = 32.0;
  static const double searchBarHeight = 55.0;
  static const double appBarHeight = 180.0;
  static const double defaultButtonWidth = 150.0;
  static const double defaultButtonHeight = 50.0;

  static const EdgeInsets innerPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 20,
  );

  static double authContainerWidth(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 0.86;
    return width > 400 ? 400 : width;
  }

  static double authContainerHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.83;
  }

  //Text Styles
  static TextStyle title({double fontSize = 22, Color color = foreground}) =>
      TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        height: 1.2,
      );

  static TextStyle textBold({double fontSize = 15, Color color = foreground}) =>
      TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600);

  static TextStyle textBolder({
    double fontSize = 15,
    Color color = foreground,
  }) =>
      TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w900);

  static Widget buildRichRow({
    String? label,
    String? value,
    Color? labelColor,
    Color? valueColor,
    double? labelSize,
    double? valueSize,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
  }) {
    final Color effectiveLabelColor = labelColor ?? foreground;
    final Color effectiveIconColor = iconColor ?? effectiveLabelColor;
    final double effectiveLabelSize = labelSize ?? 15;
    final double effectiveValueSize = valueSize ?? 15;
    final double effectiveIconSize = iconSize ?? (effectiveLabelSize + 2);

    final TextStyle labelStyle = textBold(
      fontSize: effectiveLabelSize,
      color: effectiveLabelColor,
    );

    return RichText(
      text: TextSpan(
        children: [
          if (icon != null) ...[
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: effectiveIconSize,
                ),
              ),
            ),
          ],
          if (label != null) TextSpan(text: label, style: labelStyle),
          if (value != null)
            TextSpan(
              text: value,
              style: textBolder(
                fontSize: effectiveValueSize,
                color: valueColor ?? foreground,
              ),
            ),
        ],
      ),
    );
  }
}
