import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/data/repositories/household_repository_impl.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/data/repositories/household_task_repository_impl.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
//TODO: Make it possible to fetch from different accounts and use different households
final sl = GetIt.instance;

Future<void> init() async {
  //! Features -
  // Bloc
  sl.registerFactory(
        () => HouseholdTaskBloc(
      getTasks: sl(),
    ),
  );
  sl.registerFactory(
        () => HouseholdBloc(
      loadHousehold: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllTasksForHousehold(sl()));


  sl.registerLazySingleton(() => LoadHousehold(repository: sl()));

  // Repository
  sl.registerLazySingleton<HouseholdTaskRepository>(
        () => HouseholdTaskRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<HouseholdRepository>(
        () => HouseholdRepositoryImpl(remoteDataSource: sl()
    ),
  );

  final pb = PocketBase('http://127.0.0.1:8090');

  // Data sources
  sl.registerLazySingleton<HouseholdTaskRemoteDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => HouseholdTaskRemoteDataSourceImpl(userRecordService: RecordService(pb, 'users'), taskRecordService: RecordService(pb, 'tasks'), email: "test@test.com", password: "12345678", householdId: "ehhmumqij2n1mmn"),
  );

  sl.registerLazySingleton<HouseholdRemoteDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => HouseholdRemoteDataSourceImpl(userRecordService: RecordService(pb, 'users'), householdRecordService: RecordService(pb, 'household'), email: "test@test.com", password: "12345678", householdId: "g7szpsys0r944se"),
  );
  //! Cor
  //
  //! External
}