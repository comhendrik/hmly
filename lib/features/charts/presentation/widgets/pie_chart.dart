import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HouseholdPieChart extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData(category: 'Category 1', value: 35),
    ChartData(category: 'Category 2', value: 45),
    ChartData(category: 'Category 3', value: 20),
  ];

  HouseholdPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: <CircularSeries<ChartData, String>>[
        PieSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value;

  ChartData({required this.category, required this.value});
}