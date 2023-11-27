import 'package:flutter/material.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:hmly/features/charts/presentation/widgets/pie_chart.dart';
import 'package:hmly/features/charts/presentation/widgets/reminder_button.dart';
import 'package:hmly/features/charts/presentation/widgets/historical_data_calendar.dart';

class ChartMainPage extends StatefulWidget {

  final List<PieChartData> pieChartData;
  final List<HistoricalData> historicalData;

  const ChartMainPage({
    super.key,
    required this.pieChartData,
    required this.historicalData
  });

  @override
  State<ChartMainPage> createState() => _ChartMainPageState();
}

class _ChartMainPageState extends State<ChartMainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HouseholdPieChart(data: widget.pieChartData),
        HistoricalDataCalendar(data: widget.historicalData),
        ReminderButton(dailyPoints: 20),
      ],
    );
  }
}
