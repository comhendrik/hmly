part of 'household_bloc.dart';


abstract class HouseholdState extends Equatable {
  const HouseholdState();
}

class HouseholdInitial extends HouseholdState {
  @override
  List<Object> get props => [];
}

class HouseholdLoading extends HouseholdState {
  @override
  List<Object> get props => [];
}

class HouseholdLoaded extends HouseholdState {
  final Household household;
  const HouseholdLoaded({required this.household});

  @override
  List<Object> get props => [];
}

class HouseholdError extends HouseholdState {
  final String errorMsg;
  const HouseholdError({required this.errorMsg});

  @override
  List<Object> get props => [];
}
