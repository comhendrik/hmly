import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household/domain/usecases/delete_auth_data_from_household.dart';
import 'package:household_organizer/features/household/domain/usecases/delete_household.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:household_organizer/features/household/domain/usecases/update_admin.dart';
import 'package:household_organizer/features/household/domain/usecases/update_household_title.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoadHousehold extends Mock implements LoadHousehold {}
class MockUpdateHouseholdTitle extends Mock implements UpdateHouseholdTitle {}
class MockDeleteAuthDataFromHousehold extends Mock implements DeleteAuthDataFromHousehold {}
class MockUpdateAdmin extends Mock implements UpdateAdmin {}
class MockDeleteHousehold extends Mock implements DeleteHousehold {}


void main() {
  late MockLoadHousehold loadHousehold;
  late MockUpdateHouseholdTitle updateHouseholdTitle;
  late MockDeleteAuthDataFromHousehold deleteAuthDataFromHousehold;
  late MockUpdateAdmin updateAdmin;
  late MockDeleteHousehold deleteHousehold;
  late HouseholdBloc bloc;

  setUpAll(() {
    loadHousehold = MockLoadHousehold();
    updateHouseholdTitle = MockUpdateHouseholdTitle();
    deleteAuthDataFromHousehold = MockDeleteAuthDataFromHousehold();
    updateAdmin = MockUpdateAdmin();
    deleteHousehold = MockDeleteHousehold();

    bloc = HouseholdBloc(
        loadHousehold: loadHousehold,
        updateHouseholdTitle: updateHouseholdTitle,
        deleteAuthDataFromHousehold: deleteAuthDataFromHousehold,
        updateAdmin: updateAdmin,
        deleteHousehold: deleteHousehold
    );
  });

  group('loadHousehold', () {

    const tUser = User(id: "id", username: "username123", householdId: "id", email: "test@example.com", name: "test");

    final tUsers = [tUser];

    final tHousehold = Household(id: 'id', title: 'title', users: tUsers, minWeeklyPoints: 123);

    test(
        'should get data from getNews use case',
            () async {
          when(() => usecase.execute()).thenAnswer((_) async => Right(tHousehold));

          bloc.add(LoadHouseholdEvent());

          await untilCalled(() => usecase.execute());

          verify(() => usecase.execute());


        }
    );

    test(
        'should emit [Initial(), Loading(), Loaded()] when the server request is succesful',
            () async {

          when(() => usecase.execute()).thenAnswer((_) async => Right(tHousehold));


          expectLater(bloc.stream, emitsInOrder(
              [
                HouseholdInitial(),
                HouseholdLoading(),
                HouseholdLoaded(household: tHousehold)
              ]
          ));

          bloc.add(LoadHouseholdEvent());

        }
    );

    test(
        'should emit [Initial(), Loading(), Error()] when the request is unsuccessful',
            () async {

          when(() => usecase.execute()).thenAnswer((_) async => Left(ServerFailure()));


          expectLater(bloc.stream, emitsInOrder(
              [
                HouseholdInitial(),
                HouseholdLoading(),
                const HouseholdError(errorMsg: 'Server Failure')
              ]
          ));

          bloc.add(LoadHouseholdEvent());

        }
    );
  });
}