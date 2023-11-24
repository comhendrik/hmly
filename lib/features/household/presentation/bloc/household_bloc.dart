import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/household/domain/usecases/update_allowed_users.dart';
import 'package:hmly/features/household/domain/usecases/load_household.dart';
import 'package:hmly/features/household/domain/usecases/update_household_title.dart';
import 'package:hmly/features/household/domain/usecases/delete_auth_data_from_household.dart';
import 'package:hmly/features/household/domain/usecases/update_admin.dart';
import 'package:hmly/features/household/domain/usecases/delete_household.dart';
import 'package:hmly/features/household/domain/entities/household.dart';

part 'household_event.dart';
part 'household_state.dart';

class HouseholdBloc extends Bloc<HouseholdEvent, HouseholdState> {
  final LoadHousehold loadHousehold;
  final UpdateHouseholdTitle updateHouseholdTitle;
  final DeleteAuthDataFromHousehold deleteAuthDataFromHousehold;
  final UpdateAdmin updateAdmin;
  final DeleteHousehold deleteHousehold;
  final UpdateAllowedUsers updateAllowedUsers;
  HouseholdBloc({
    required this.loadHousehold,
    required this.updateHouseholdTitle,
    required this.deleteAuthDataFromHousehold,
    required this.updateAdmin,
    required this.deleteHousehold,
    required this.updateAllowedUsers
  }) : super(HouseholdInitial()) {
    on<HouseholdEvent>((event, emit) async {
      emit(HouseholdInitial());
      if (event is LoadHouseholdEvent)  {
        emit(HouseholdLoading(msg: event.msg));
        final resultEither = await loadHousehold.execute(event.householdID);
        resultEither.fold(
                (failure) async {
                  emit(HouseholdError(failure: failure));
            },
                (household) {
              emit(HouseholdLoaded(household: household));
            }
        );
      } else if (event is UpdateHouseholdTitleEvent) {
        emit(HouseholdLoading(msg: event.msg));
        final resultEither = await updateHouseholdTitle.execute(event.householdID, event.householdTitle);
        resultEither.fold(
                (failure) async {
                  emit(HouseholdError(failure: failure));
            },
                (household) {
              emit(HouseholdLoaded(household: household));
            }
        );
      } else if (event is DeleteAuthDataFromHouseholdEvent) {
        emit(HouseholdLoading(msg: event.msg));
        final resultEither = await deleteAuthDataFromHousehold.execute(event.userID,);
        resultEither.fold(
                (failure) async {
                  emit(HouseholdError(failure: failure));
            },
                (_) {
                  add(LoadHouseholdEvent(householdID: event.household.id));
            }
        );
      } else if (event is UpdateAdminEvent) {
        emit(HouseholdLoading(msg: event.msg));
        final resultEither = await updateAdmin.execute(event.householdID, event.userID);
        resultEither.fold(
                (failure) async {
                  emit(HouseholdError(failure: failure));
            },
                (household) {
              emit(HouseholdLoaded(household: household));
            }
        );
      } else if (event is DeleteHouseholdEvent) {
        await deleteHousehold.execute(event.householdID);
      } else if (event is UpdateAllowedUsersEvent) {
        final resultEither = await updateAllowedUsers.execute(event.userID, event.household, event.delete);
        resultEither.fold(
                (failure) async {
              emit(HouseholdError(failure: failure));
            },
                (household) {
              emit(HouseholdLoaded(household: household));
            }
        );
      }
    });
  }
}
