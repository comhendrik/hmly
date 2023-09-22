import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HouseholdPieChart extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData(category: 'Hendrik', value: 35),
    ChartData(category: 'Hannes', value: 45),
    ChartData(category: 'Mara', value: 20),
    ChartData(category: 'Lea', value: 23),
  ];

  HouseholdPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
        text: "Your Household's activity today",
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      series: <CircularSeries<ChartData, String>>[
        PieSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      legend: Legend(isVisible: true),
    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData({required this.category, required this.value});
}