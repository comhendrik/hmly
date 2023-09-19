import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatefulWidget {
  BarChart({Key? key}) : super(key: key);

  @override
  BarChartState createState() => BarChartState();
}

class BarChartState extends State<BarChart> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Mo', 5),
      _ChartData('Tue', 4),
      _ChartData('Wed', 3),
      _ChartData('Thu', 0),
      _ChartData('Fr', 10),
      _ChartData('Sa', 5),
      _ChartData('Su', 1)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: ChartTitle(text: 'Your Activity'),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0, maximum: 10, interval: 2),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
              name: 'Gold',
              color: const Color.fromRGBO(8, 142, 255, 1)
          )
        ]
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}