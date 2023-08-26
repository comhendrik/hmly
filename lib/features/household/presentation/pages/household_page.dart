import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:household_organizer/features/household_task/presentation/pages/household_task_page.dart';
import '../widgets/widget.dart';

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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              BlocBuilder<HouseholdBloc, HouseholdState>(
                builder: (context, state) {
                  if (state is HouseholdInitial) {
                    BlocProvider.of<HouseholdBloc>(context)
                        .add(LoadHouseholdEvent(householdId: mainUser.householdId));
                    return Text("No data loaded for household id: '${mainUser.householdId}'");
                  } else if (state is HouseholdLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is HouseholdLoaded) {
                    return HouseholdTaskPage(mainUser: mainUser);
                  } else if (state is HouseholdError) {
                    return Text(state.errorMsg);
                  } else {
                    return const Text("...");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

