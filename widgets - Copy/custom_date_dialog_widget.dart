import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_button_widget.dart';
import 'package:polaris_mobile/core/widgets/custom_divider_widget.dart';

class DateDialogWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateDialogWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final String? text = selectedDate == null
        ? null
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    final textColor = selectedDate == null
        ? AppStyles.foreground.withValues(alpha: 0.7)
        : AppStyles.foreground;

    return CustomButtonWidget(
      text: text ?? "",
      onPressed: () => _showCustomDatePicker(context),
      width: double.infinity,
      height: AppStyles.searchBarHeight,
      fillColor: AppStyles.gradientTopBright.withValues(alpha: 0.3),
      borderColor: AppStyles.border,
      borderWidth: AppStyles.borderWidth,
      borderRadius: AppStyles.fieldRadius,
      icon: Icons.calendar_month_rounded,
      iconColor: AppStyles.foreground,
      iconSize: 25,
      textColor: textColor,
      textStyle: AppStyles.textBold(color: textColor),
    );
  }

  void _showCustomDatePicker(BuildContext context) {
    DateTime tempDate = selectedDate ?? DateTime.now();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 340,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppStyles.gradientTop,
                            AppStyles.gradientBottom,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppStyles.dialogRadius,
                        ),
                        border: Border.all(
                          color: AppStyles.border,
                          width: AppStyles.borderWidth,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              _formatDateTitle(tempDate),
                              style: AppStyles.title(
                                fontSize: 28,
                                color: AppStyles.foreground,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const CustomDividerWidget(),
                          const SizedBox(height: 5),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppStyles.purple,
                                onPrimary: AppStyles.background,
                                onSurface: AppStyles.foreground,
                                surface: Colors.transparent,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppStyles.foreground,
                                ),
                              ),
                            ),
                            child: CalendarDatePicker(
                              initialDate: tempDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101),
                              onDateChanged: (value) {
                                setState(() {
                                  tempDate = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButtonWidget(
                                    text: "Cancel",
                                    textColor: AppStyles.background,
                                    fillColor: AppStyles.grey,
                                    borderWidth: 0,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: CustomButtonWidget(
                                    text: "OK",
                                    height: 45,
                                    fillColor: AppStyles.purple,
                                    onPressed: () {
                                      onDateSelected(tempDate);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDateTitle(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final weekdayName = weekdays[date.weekday - 1];
    final monthName = months[date.month - 1];

    return "$weekdayName, $monthName ${date.day}";
  }
}
