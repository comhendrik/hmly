import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/widgets/bloc_error_widget.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household/presentation/widgets/household_widget.dart';

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
                return const CircularProgressIndicator();
              } else if (state is HouseholdLoaded) {
                return HouseholdWidget(household: state.household, mainUser: mainUser,context: context,);
              } else if (state is HouseholdError) {
                return BlocErrorWidget(errorMsg: state.errorMsg, reloadAction: () {
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

