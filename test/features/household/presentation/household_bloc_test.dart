import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/entities/user.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoadHousehold extends Mock implements LoadHousehold {}

void main() {
  late MockLoadHousehold usecase;
  late HouseholdBloc bloc;

  setUpAll(() {
    usecase = MockLoadHousehold();
    bloc = HouseholdBloc(loadHousehold: usecase);
  });

  group('getAllTasksForHousehold', () {

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