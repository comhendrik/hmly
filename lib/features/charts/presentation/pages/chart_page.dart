import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/core/widgets/custom_process_indicator_widget.dart';
import 'package:household_organizer/core/widgets/feauture_widget_blueprint.dart';
import 'package:household_organizer/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:household_organizer/features/charts/presentation/pages/chart_main_page.dart';
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
                .add(GetWeeklyChartDataEvent(userID: mainUser.id, householdID: mainUser.householdID));
            return const Text("Data is loading...");
          } else if (state is ChartLoading) {
            return Center(
                child: CustomProcessIndicator(
                    reloadAction: () {
                      BlocProvider.of<ChartBloc>(context)
                          .add(GetWeeklyChartDataEvent(userID: mainUser.id, householdID: mainUser.householdID));
                    }, msg: state.msg,
                ),
            );
          } else if (state is ChartLoaded) {
            return FeatureWidgetBlueprint(
                title: "Statistics",
                titleIcon: Icons.insert_chart,
                reloadAction: () {
                  BlocProvider.of<ChartBloc>(context)
                      .add(GetWeeklyChartDataEvent(userID: mainUser.id, householdID: mainUser.householdID));
                },
                widget: ChartMainPage(barChartData: state.barChartDataList, pieChartData: state.pieChartDataList)
            );
          } else if (state is ChartError) {

            return BlocErrorWidget(failure: state.failure, reloadAction: () {
              BlocProvider.of<ChartBloc>(context)
                  .add(GetWeeklyChartDataEvent(userID: mainUser.id, householdID: mainUser.householdID));
            });

          } else {
            return const Text("...");
          }
        },
      ),
    );

  }


}