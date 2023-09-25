import 'package:flutter/material.dart';
import 'package:household_organizer/features/charts/domain/entities/pie_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HouseholdPieChart extends StatelessWidget {
  final List<PieChartData> data;

  const HouseholdPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
        text: "Your Household's activity today",
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      series: <CircularSeries<PieChartData, String>>[
        PieSeries<PieChartData, String>(
          dataSource: data,
          xValueMapper: (PieChartData data, _) => data.isDataOfUser ? 'You' : data.username,
          yValueMapper: (PieChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      legend: Legend(isVisible: true),
    );
  }
}