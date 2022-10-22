import 'package:fl_chart/fl_chart.dart';

class BarchartDataCustom extends BarChartGroupData {
  String title;

  BarchartDataCustom(
    this.title, {
    required int x,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  }) : super(
            x: x,
            barRods: barRods,
            barsSpace: barsSpace,
            showingTooltipIndicators: showingTooltipIndicators);
}
