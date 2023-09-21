import 'package:flutter/material.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatefulWidget {
  final List<BarChartData> data;
  BarChart({Key? key, required this.data}) : super(key: key);

  @override
  BarChartState createState() => BarChartState();
}

class BarChartState extends State<BarChart> {

  late TooltipBehavior _tooltip;


  @override
  void initState() {
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
        series: <ChartSeries<BarChartData, String>>[
          ColumnSeries<BarChartData, String>(
              dataSource: widget.data,
              xValueMapper: (BarChartData data, _) => data.day,
              yValueMapper: (BarChartData data, _) => data.value,
              name: 'Gold',
              color: const Color.fromRGBO(8, 142, 255, 1)
          )
        ]
    );
  }
}
