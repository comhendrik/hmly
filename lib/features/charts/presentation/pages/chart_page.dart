import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/bloc_error_widget.dart';
import 'package:hmly/core/widgets/custom_process_indicator_widget.dart';
import 'package:hmly/core/widgets/feauture_widget_blueprint.dart';
import 'package:hmly/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:hmly/features/charts/presentation/pages/chart_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            loadingFunction(context, mainUser);
            return const Text("Charts initialise...");
          } else if (state is ChartLoading) {
            return CustomProcessIndicator(reloadAction: () => loadingFunction(context, mainUser), msg: state.msg);
          } else if (state is ChartLoaded) {
            return FeatureWidgetBlueprint(
                title: AppLocalizations.of(context)!.chartsTitle,
                titleIcon: Icons.insert_chart,
                reloadAction: () => loadingFunction(context, mainUser),
                widget: ChartMainPage(barChartData: state.barChartDataList, pieChartData: state.pieChartDataList)
            );
          } else if (state is ChartError) {
            return BlocErrorWidget(failure: state.failure, reloadAction: () => loadingFunction(context, mainUser));
          } else {
            return const Text("Please contact support when this occurs");
          }
        },
      ),
    );
  }

  void loadingFunction(BuildContext bContext, User mainUser) {
    BlocProvider.of<ChartBloc>(bContext)
        .add(GetWeeklyChartDataEvent(userID: mainUser.id, householdID: mainUser.householdID));
  }


}