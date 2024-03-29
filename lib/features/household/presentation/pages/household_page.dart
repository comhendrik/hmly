import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/widgets/bloc_error_widget.dart';
import 'package:hmly/core/widgets/custom_process_indicator_widget.dart';
import 'package:hmly/core/widgets/feauture_widget_blueprint.dart';
import 'package:hmly/features/household/presentation/bloc/household_bloc.dart';
import 'package:hmly/features/household/presentation/pages/household_main_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HouseholdPage extends StatelessWidget {
  final User mainUser;

  const HouseholdPage({
    super.key,
    required this.mainUser
  });
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  BlocBuilder buildBody(BuildContext context) {
    return BlocBuilder<HouseholdBloc, HouseholdState>(
      builder: (context, state) {
        if (state is HouseholdInitial) {
          loadingFunction(context, mainUser.householdID);

          return Text(AppLocalizations.of(context)!.institutionPageInit);
        } else if (state is HouseholdLoading) {
          return CustomProcessIndicator(reloadAction: () => loadingFunction(context, mainUser.householdID), msg: state.msg);
        } else if (state is HouseholdLoaded) {
          return FeatureWidgetBlueprint(
            title: AppLocalizations.of(context)!.institutionTitle,
            titleIcon: Icons.house,
            reloadAction: () => loadingFunction(context, mainUser.householdID),
            widget: HouseholdMainPage(context: context, household: state.household, mainUser: mainUser,),
          );
        } else if (state is HouseholdError) {
          return BlocErrorWidget(failure: state.failure, reloadAction: () {
            loadingFunction(context, mainUser.householdID);
          });
        } else {
          return Text(AppLocalizations.of(context)!.supportErrorMessage);
        }
      },
    );
  }

  void loadingFunction(BuildContext bContext, String householdID) {
    BlocProvider.of<HouseholdBloc>(bContext)
        .add(LoadHouseholdEvent(householdID: householdID, context: bContext));
  }
}

