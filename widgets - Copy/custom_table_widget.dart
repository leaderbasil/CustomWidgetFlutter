import 'package:flutter/material.dart';
import 'package:polaris_mobile/core/theming/app_styles.dart';
import 'package:polaris_mobile/core/widgets/custom_container_widget.dart';

class CustomTableWidget extends StatelessWidget {
  final String? title;
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final double rowHeight;
  final TextStyle? headerStyle;
  final Color headerColor;
  final TextStyle? cellStyle;
  final Color oddRowColor;
  final Color evenRowColor;
  final int displayedRows;

  CustomTableWidget({
    super.key,
    this.title,
    required this.columns,
    required this.rows,
    this.rowHeight = 50.0,
    this.headerStyle,
    Color? headerColor,
    this.cellStyle,
    this.oddRowColor = Colors.transparent,
    Color? evenRowColor,
    this.displayedRows = 5,
  }) : headerColor = headerColor ?? AppStyles.containerTopBright,
       evenRowColor =
           evenRowColor ?? AppStyles.containerTop.withValues(alpha: 0.5);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(title!, style: AppStyles.title(fontSize: 20)),
          ),
          const SizedBox(height: 8),
        ],
        CustomContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: rowHeight,
                decoration: BoxDecoration(
                  color: headerColor,
                  border: Border(
                    bottom: BorderSide(color: AppStyles.border, width: 1),
                  ),
                ),
                child: Row(
                  children: columns.map((col) {
                    return Expanded(
                      child: Text(
                        col,
                        style:
                            headerStyle ??
                            AppStyles.textBolder(
                              fontSize: 14,
                              color: AppStyles.white,
                            ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (rows.isEmpty)
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    "No data available",
                    style: AppStyles.textBold(
                      color: AppStyles.containerTopBright.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height:
                      rowHeight *
                      (rows.length < displayedRows
                          ? rows.length
                          : displayedRows),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      final bool isEven = index % 2 == 0;
                      final Color rowColor = isEven
                          ? oddRowColor
                          : evenRowColor;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: rowHeight,
                        decoration: BoxDecoration(
                          color: rowColor,
                          border: index != rows.length - 1
                              ? Border(
                                  bottom: BorderSide(
                                    color: AppStyles.border,
                                    width: 0.5,
                                  ),
                                )
                              : null,
                        ),
                        child: Row(
                          children: columns.map((col) {
                            final value = row[col]?.toString() ?? '-';
                            return Expanded(
                              child: Text(
                                value,
                                style:
                                    cellStyle ??
                                    AppStyles.textBold(
                                      fontSize: 12.5,
                                      color: AppStyles.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
