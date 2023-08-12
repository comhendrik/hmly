part of 'household_bloc.dart';


abstract class HouseholdEvent extends Equatable {
  const HouseholdEvent();

  @override
  List<Object> get props => [];
}

class LoadHouseholdEvent extends HouseholdEvent {
  final String householdId;

  const LoadHouseholdEvent({
    required this.householdId,
  });
}
