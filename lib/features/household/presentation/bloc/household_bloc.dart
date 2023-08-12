import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:meta/meta.dart';

part 'household_event.dart';
part 'household_state.dart';

class HouseholdBloc extends Bloc<HouseholdEvent, HouseholdState> {
  final LoadHousehold loadHousehold;
  HouseholdBloc({required this.loadHousehold}) : super(HouseholdInitial()) {
    on<HouseholdEvent>((event, emit) async {
      emit(HouseholdInitial());
      if (event is LoadHouseholdEvent)  {
        emit(HouseholdLoading());
        final resultEither = await loadHousehold.execute(event.householdId);
        resultEither.fold(
                (failure) async {
              emit(const HouseholdError(errorMsg: 'Server Failure'));
            },
                (household) {
              emit(HouseholdLoaded(household: household));
            }
        );
      }
    });
  }
}
