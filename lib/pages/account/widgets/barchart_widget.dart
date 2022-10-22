import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/barchart_data_custom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarChartWidget extends StatefulWidget {
  final List<BarchartDataCustom> listData;

  const BarChartWidget({
    Key? key,
    required this.listData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    final maxValue = _getMaxValue(widget.listData);
    final interval = _getInterval(maxValue);
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: EdgeInsets.only(
            top: AppConstant.kSpaceVerticalSmallExtraExtra,
            left: AppConstant.kSpaceHorizontalMediumExtra,
            right: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Triệu đồng',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: AppColors.grey),
            ),
            AppConstant.spaceVerticalSmallExtraExtraExtra,
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  maxY: interval * 5 + (interval / 2),
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 10, color: AppColors.grey),
                      margin: 10,
                      getTitles: (double value) {
                        final index = value.toInt();
                        if (index < widget.listData.length) {
                          return widget.listData[index].title;
                        } else {
                          return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: interval,
                      getTextStyles: (context, value) => Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: 10.sp, color: AppColors.grey450),
                      margin: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                    ),
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: interval,
                    checkToShowHorizontalLine: (value) => true,
                    getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.grey50,
                        strokeWidth: 1,
                        dashArray: [3, 2]),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  groupsSpace: 40.w,
                  barGroups: widget.listData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getInterval(double maxValue) {
    final value = (maxValue / 5).truncateToDouble();
    return value == 0 ? 1 : value;
  }

  ///
  /// Tìm giá trị lớn nhất
  ///
  double _getMaxValue(List<BarchartDataCustom> listData) {
    double maxValue = 0.0;

    for (var itemChart in listData) {
      for (var valueChart in itemChart.barRods) {
        if (valueChart.y > maxValue) {
          maxValue = valueChart.y;
        }
      }
    }

    /// Nếu số liệu = 0 thì mặc định gán = 5 để vẽ biểu đồ
    if (maxValue == 0) {
      maxValue = 5;
    }
    return maxValue;
  }
}
