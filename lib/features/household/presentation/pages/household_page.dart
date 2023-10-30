import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/core/widgets/custom_process_indicator_widget.dart';
import 'package:household_organizer/core/widgets/feauture_widget_blueprint.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household/presentation/pages/household_main_page.dart';

import '../../../../injection_container.dart';

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

  BlocProvider<HouseholdBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HouseholdBloc>(),
      child: Column(
        children: <Widget>[
          BlocBuilder<HouseholdBloc, HouseholdState>(
            builder: (context, state) {
              if (state is HouseholdInitial) {
                BlocProvider.of<HouseholdBloc>(context)
                    .add(LoadHouseholdEvent(householdID: mainUser.householdID));
                return Text("No data loaded for household id: '${mainUser.householdID}'");
              } else if (state is HouseholdLoading) {
                return CustomProcessIndicator(
                    reloadAction: () {
                      BlocProvider.of<HouseholdBloc>(context)
                          .add(LoadHouseholdEvent(householdID: mainUser.householdID));
                    }, msg: state.msg,
                );
              } else if (state is HouseholdLoaded) {
                return FeatureWidgetBlueprint(
                    title: "Household",
                    titleIcon: Icons.house,
                    reloadAction: () {
                      BlocProvider.of<HouseholdBloc>(context)
                          .add(LoadHouseholdEvent(householdID: mainUser.householdID));
                    },
                    widget: HouseholdMainPage(context: context, household: state.household, mainUser: mainUser,),
                );
              } else if (state is HouseholdError) {
                return BlocErrorWidget(failure: state.failure, reloadAction: () {
                  BlocProvider.of<HouseholdBloc>(context)
                      .add(LoadHouseholdEvent(householdID: mainUser.householdID));
                });
              } else {
                return const Text("...");
              }
            },
          ),
        ],
      ),
    );
  }
}

