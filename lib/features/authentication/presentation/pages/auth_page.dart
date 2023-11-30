import 'package:hmly/core/widgets/bloc_error_widget.dart';
import 'package:hmly/core/widgets/custom_process_indicator_widget.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:hmly/features/authentication/presentation/pages/auth_main_page.dart';
import 'package:hmly/features/authentication/presentation/pages/auth_main_page_without_household.dart';
import 'package:hmly/features/authentication/presentation/widgets/verify_widget.dart';
import 'package:hmly/features/authentication/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hmly/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:hmly/features/household/presentation/bloc/household_bloc.dart';
import 'package:hmly/features/household_task/presentation/bloc/household_task_bloc.dart';
import '../../../../injection_container.dart';

class AuthPage extends StatelessWidget {

  const AuthPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  MultiBlocProvider buildBody(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => sl<AuthBloc>(),
        ),
        BlocProvider<HouseholdBloc>(
          create: (BuildContext context) => sl<HouseholdBloc>(),
        ),
        BlocProvider<ChartBloc>(
          create: (BuildContext context) => sl<ChartBloc>(),
        ),
        BlocProvider<HouseholdTaskBloc>(
          create: (BuildContext context) => sl<HouseholdTaskBloc>(),
        ),

      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial) {
            loadingFunction(context);
            return Text(AppLocalizations.of(context)!.authPageInit);
          } else if (state is AuthLoading) {
            return CustomProcessIndicator(reloadAction: () => loadingFunction(context), msg: state.msg);
          } else if (state is AuthLoaded) {
            return !state.authData.verified ? VerifyWidget(mainUser: state.authData) : state.authData.householdID == "" ? AuthMainPageWithoutHousehold(mainUser: state.authData) : AuthMainPage(mainUser: state.authData, startCurrentPageIndex: state.startCurrentPageIndex);
          } else if (state is AuthError) {
            return BlocErrorWidget(failure: state.failure, reloadAction: () =>  loadingFunction(context),);
          } else if (state is AuthCreate){
            return const AuthenticationWidget();
          } else if (state is AuthNoConnection) {
            return Text(AppLocalizations.of(context)!.noConnection);
          } else {
            return Text(AppLocalizations.of(context)!.supportErrorMessage);
          }
        },
      ),
    );
  }

  void loadingFunction(BuildContext bContext) {
    BlocProvider.of<AuthBloc>(bContext)
        .add(LoadAuthEvent(context: bContext));
  }

  void loadEveryBloc(BuildContext bContext, String userID, String householdID) {
    BlocProvider.of<ChartBloc>(bContext)
        .add(GetWeeklyChartDataEvent(userID: userID, householdID: householdID, context: bContext));
    BlocProvider.of<HouseholdBloc>(bContext)
        .add(LoadHouseholdEvent(householdID: householdID, context: bContext));
    BlocProvider.of<HouseholdTaskBloc>(bContext)
        .add(GetAllTasksForHouseholdEvent(householdID: householdID, context: bContext));
  }
}




