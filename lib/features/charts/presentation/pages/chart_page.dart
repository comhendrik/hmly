import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:household_organizer/features/charts/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
            return BarChart(data: state.barChartDataList);
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