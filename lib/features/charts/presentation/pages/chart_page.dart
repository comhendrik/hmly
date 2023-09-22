import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:household_organizer/features/charts/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household/presentation/widgets/pie_chart.dart';


import '../../../../injection_container.dart';

class ChartPage extends StatelessWidget {
  final User mainUser;

  const ChartPage({
    super.key,
    required this.mainUser
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<ChartBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChartBloc>(),
      child: BlocBuilder<ChartBloc, ChartState>(
        builder: (context, state) {
          if (state is ChartInitial) {
            BlocProvider.of<ChartBloc>(context)
                .add(GetWeeklyChartDataEvent(userId: mainUser.id, householdId: mainUser.householdId));
            return const Text("Data is loading...");
          } else if (state is ChartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChartLoaded) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.insert_chart, weight: 5.0),
                        Text(
                          " Statistics",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () {
                      BlocProvider.of<ChartBloc>(context)
                          .add(GetWeeklyChartDataEvent(userId: mainUser.id, householdId: mainUser.householdId));
                    }, icon: const Icon(Icons.update)),
                  ],
                ),
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
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(left: 25.0,top: 15.0,right: 25.0,bottom: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
                            ),
                              child: Text(
                                "${state.barChartDataList.last.value}",

                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),
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

                BarChart(data: state.barChartDataList),
                HouseholdPieChart(),
                ReminderButton(dailyPoints: state.barChartDataList.last.value,),
              ],
            );
          } else if (state is ChartError) {
            return Text(state.errorMsg);
          } else {
            return const Text("...");
          }
        },
      ),
    );

  }


}