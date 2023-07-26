import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/data/repositories/household_task_repository_impl.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
        () => HouseholdTaskBloc(
      getTasks: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllTasksForHousehold(sl()));

  // Repository
  sl.registerLazySingleton<HouseholdTaskRepository>(
        () => HouseholdTaskRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HouseholdTaskRemoteDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => HouseholdTaskRemoteDataSourceImpl(userRecordService: RecordService(PocketBase('http://127.0.0.1:8090'), 'users'), taskRecordService: RecordService(PocketBase('http://127.0.0.1:8090'), 'tasks'), email: "test@test.com", password: "12345678", householdId: "ehhmumqij2n1mmn"),
  );
  //! Core
  //! External
}