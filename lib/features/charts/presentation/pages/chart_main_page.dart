import 'package:flutter/material.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/entities/pie_chart_data.dart';
import 'package:household_organizer/features/charts/presentation/widgets/bar_chart.dart';
import 'package:household_organizer/features/charts/presentation/widgets/pie_chart.dart';
import 'package:household_organizer/features/charts/presentation/widgets/reminder_button.dart';

class ChartMainPage extends StatefulWidget {

  final List<BarChartData> barChartData;
  final List<PieChartData> pieChartData;

  const ChartMainPage({
    super.key,
    required this.barChartData,
    required this.pieChartData
  });

  @override
  State<ChartMainPage> createState() => _ChartMainPageState();
}

class _ChartMainPageState extends State<ChartMainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0)
          ),
          child: Card(
              elevation: 0.125,
              // No elevation for the Card; we'll use the shadow from the Container
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.only(left: 25.0,top: 15.0,right: 25.0,bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                      ),
                      child: Text(
                        "${widget.barChartData.last.value}",

                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),
                      )
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Points reached today', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              )
          ),
        ),

        BarChart(data: widget.barChartData),
        HouseholdPieChart(data: widget.pieChartData),
        ReminderButton(dailyPoints: widget.barChartData.last.value),
      ],
    );
  }
}
