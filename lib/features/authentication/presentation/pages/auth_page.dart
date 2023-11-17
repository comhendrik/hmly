import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/core/widgets/custom_process_indicator_widget.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/authentication/presentation/pages/auth_main_page.dart';
import 'package:household_organizer/features/authentication/presentation/pages/auth_main_page_without_household.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/verify_widget.dart';
import 'package:household_organizer/features/authentication/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../injection_container.dart';

class AuthPage extends StatelessWidget {

  const AuthPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocProvider<AuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
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
        .add(LoadAuthEvent());
  }
}




