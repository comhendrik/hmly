import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class PieData {
  String xData;
  num yData;
  String text;

  PieData({
    required this.xData,
    required this.yData,
    required this.text
  });
}


class PieChart extends StatelessWidget {
  final List<PieData> pieData;

  const PieChart({super.key, required this.pieData});

  Widget build(BuildContext context) {
    return Center(
        child: SfCircularChart(
            title: ChartTitle(text: 'Points Distribution'),
            legend: Legend(isVisible: true),
            series: <PieSeries<PieData, String>>[
              PieSeries<PieData, String>(
                  explode: true,
                  explodeIndex: 0,
                  dataSource: pieData,
                  xValueMapper: (PieData data, _) => data.xData,
                  yValueMapper: (PieData data, _) => data.yData,
                  dataLabelMapper: (PieData data, _) => data.text,
                  dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ]
        )
    );
  }
}

