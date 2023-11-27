import 'package:flutter/material.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoricalChart extends StatefulWidget {
  final List<HistoricalData> data;
  const HistoricalChart({Key? key, required this.data}) : super(key: key);

  @override
  HistoricalChartState createState() => HistoricalChartState();
}

class HistoricalChartState extends State<HistoricalChart> {

  late TooltipBehavior _tooltip;


  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (HistoricalData hdata in widget.data)
          Text("${hdata.id}, ${hdata.created}, ${hdata.value}")
      ],
    );
  }
}
