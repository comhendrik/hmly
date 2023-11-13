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

          final result = await loadHousehold.execute("householdID");

          expect(result, Right(tHousehold));

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

  group('updateHouseholdTitle', () {

    test('should get data from loadHousehold Usecase', () async {
      when(() => updateHouseholdTitle.execute("householdID", "householdTitle")).thenAnswer((_) async => Right(tHousehold));

      bloc.add(const UpdateHouseholdTitleEvent(householdID: "householdID", householdTitle: "householdTitle"));

      final result = await updateHouseholdTitle.execute("householdID", "householdTitle");

      expect(result, Right(tHousehold));


    }
    );

    test('should emit [Initial(), Loading(), Loaded()] when the server request is succesful', () async {

      when(() => updateHouseholdTitle.execute("householdID", "householdTitle")).thenAnswer((_) async => Right(tHousehold));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdLoaded(household: tHousehold)
          ]
      ));

      bloc.add(const UpdateHouseholdTitleEvent(householdID: "householdID", householdTitle: "householdTitle"));

    }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of server failure', () async {

      when(() => updateHouseholdTitle.execute("householdID", "householdTitle")).thenAnswer((_) async => Left(tServerFailure));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdError(failure: tServerFailure)
          ]
      ));

      bloc.add(const UpdateHouseholdTitleEvent(householdID: "householdID", householdTitle: "householdTitle"));

    }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of unknown issues', () async {

      when(() => updateHouseholdTitle.execute("householdID", "householdTitle")).thenAnswer((_) async => Left(tUnknownFailure));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdError(failure: tUnknownFailure)
          ]
      ));

      bloc.add(const UpdateHouseholdTitleEvent(householdID: "householdID", householdTitle: "householdTitle"));

    }
    );
  });

  group('deleteAuthDataFromHousehold', () {

    test('should get void from deleteAuthDataFromHousehold Usecase', () async {

      when(() => deleteAuthDataFromHousehold.execute("userID")).thenAnswer((_) async => Right( () ));

      bloc.add(DeleteAuthDataFromHouseholdEvent(userID: "userID", household: tHousehold));

      final result = await deleteAuthDataFromHousehold.execute("userID");

      expect(result, const Right( () ));

      verify(() => deleteAuthDataFromHousehold.execute("userID"));


    }
    );

    test('should emit [Initial(), Loading(),] when the server request is succesful', () async {


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
          ]
      ));

      bloc.add(DeleteAuthDataFromHouseholdEvent(userID: "userID", household: tHousehold));

    }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of server failure', () async {

      when(() => deleteAuthDataFromHousehold.execute("userID")).thenAnswer((_) async => Left(tServerFailure));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdError(failure: tServerFailure)
          ]
      ));

      bloc.add(DeleteAuthDataFromHouseholdEvent(userID: "userID", household: tHousehold));

    }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of unknown issues', () async {

      when(() => deleteAuthDataFromHousehold.execute("userID")).thenAnswer((_) async => Left(tUnknownFailure));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdError(failure: tUnknownFailure)
          ]
      ));

      bloc.add(DeleteAuthDataFromHouseholdEvent(userID: "userID", household: tHousehold));

    }
    );
  });


  group('updateAdmin', () {

    test('should get data from updateAdmin Usecase', () async {
      when(() => updateAdmin.execute("householdID", "userID")).thenAnswer((_) async => Right(tHousehold));

      bloc.add(const UpdateAdminEvent(householdID: "householdID", userID: "userID"));

      final result = await updateAdmin.execute("householdID", "userID");

      expect(result, Right(tHousehold));

      verify(() => updateAdmin.execute("householdID", "userID"));


    }
    );

    test('should emit [Initial(), Loading(), Loaded()] when the server request is succesful', () async {

      when(() => updateAdmin.execute("householdID", "userID")).thenAnswer((_) async => Right(tHousehold));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdLoaded(household: tHousehold)
          ]
      ));

      bloc.add(const UpdateAdminEvent(householdID: "householdID", userID: "userID"));
    }
    );

    test('should emit [Initial(), Loading(), Error()] when the request is unsuccessful because of server failure', () async {

      when(() => updateAdmin.execute("householdID", "userID")).thenAnswer((_) async => Left(tServerFailure));


      expectLater(bloc.stream, emitsInOrder(
          [
            HouseholdInitial(),
            const HouseholdLoading(msg: "msg"),
            HouseholdError(failure: tServerFailure)
          ]
      ));

      bloc.add(const UpdateAdminEvent(householdID: "householdID", userID: "userID"));

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

      bloc.add(const UpdateAdminEvent(householdID: "householdID", userID: "userID"));

    }
    );
  });

  group('deleteHousehold', () {

    test('should execute deleteHousehold Usecase', () async {

      when(() => deleteHousehold.execute("householdID")).thenAnswer((_) async => const Right( () ));

      bloc.add(const DeleteHouseholdEvent(householdID: "householdID"));

      verify(() => deleteHousehold.execute("householdID"));


    }
    );
  });

}