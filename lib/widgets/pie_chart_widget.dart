import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget(
      {Key? key, required this.dataChart, required this.radius})
      : super(key: key);

  final List<PieChartSectionData> dataChart;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: (radius / 2).ceilToDouble().r,
                sections: dataChart),
          ),
          Positioned(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle),
                  width: (radius * 1.3).ceilToDouble().r,
                  height: (radius * 1.3).ceilToDouble().r))
        ],
      ),
    );
  }
}
