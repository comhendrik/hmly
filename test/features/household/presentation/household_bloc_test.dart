import 'package:dartz/dartz.dart';
import 'package:household_organizer/features/household/domain/usecases/delete_auth_data_from_household.dart';
import 'package:household_organizer/features/household/domain/usecases/delete_household.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:household_organizer/features/household/domain/usecases/update_admin.dart';
import 'package:household_organizer/features/household/domain/usecases/update_household_title.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../test_data.dart';

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

    test('should get data from loadHousehold Usecase', () async {
          when(() => loadHousehold.execute("householdID")).thenAnswer((_) async => Right(tHousehold));

          bloc.add(const LoadHouseholdEvent(householdID: "householdID"));

          await untilCalled(() => loadHousehold.execute("householdID"));

          verify(() => loadHousehold.execute("householdID"));


        }
    );

    test('should emit [Initial(), Loading(), Loaded()] when the server request is succesful', () async {

          when(() => loadHousehold.execute("householdID")).thenAnswer((_) async => Right(tHousehold));


          expectLater(bloc.stream, emitsInOrder(
              [
                HouseholdInitial(),
                const HouseholdLoading(msg: "msg"),
                HouseholdLoaded(household: tHousehold)
              ]
          ));

          bloc.add(const LoadHouseholdEvent(householdID: "householdID"));

        }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of server failure', () async {

          when(() => loadHousehold.execute("householdID")).thenAnswer((_) async => Left(tServerFailure));


          expectLater(bloc.stream, emitsInOrder(
              [
                HouseholdInitial(),
                const HouseholdLoading(msg: "msg"),
                HouseholdError(failure: tServerFailure)
              ]
          ));

          bloc.add(const LoadHouseholdEvent(householdID: "householdID"));

        }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of unknown issues', () async {

      when(() => loadHousehold.execute("householdID")).thenAnswer((_) async => Left(tUnknownFailure));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdError(failure: tUnknownFailure)
          ]
      ));

      bloc.add(const LoadHouseholdEvent(householdID: "householdID"));

    }
    );
  });
}