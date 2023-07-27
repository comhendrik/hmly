import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
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

    const tHousehold = Household(id: 'id', title: 'title', users: ['users'], minWeeklyPoints: 123);

    test(
        'should get data from getNews use case',
            () async {
          when(() => usecase.execute()).thenAnswer((_) async => const Right(tHousehold));

          bloc.add(LoadHouseholdEvent());

          await untilCalled(() => usecase.execute());

          verify(() => usecase.execute());


        }
    );

    test(
        'should emit [Initial(), Loading(), Loaded()] when the server request is succesful',
            () async {

          when(() => usecase.execute()).thenAnswer((_) async => const Right(tHousehold));


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