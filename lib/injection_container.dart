import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:household_organizer/features/authentication/data/datasources/auth_data_source.dart';
import 'package:household_organizer/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:household_organizer/features/authentication/domain/repositories/auth_repository.dart';
import 'package:household_organizer/features/authentication/domain/usecases/add_auth_data_to_household.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_auth_data.dart';
import 'package:household_organizer/features/authentication/domain/usecases/create_auth_data_on_server.dart';
import 'package:household_organizer/features/authentication/domain/usecases/delete_auth_data_from_household.dart';
import 'package:household_organizer/features/authentication/domain/usecases/load_auth_data.dart';
import 'package:household_organizer/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:household_organizer/features/charts/data/datasources/charts_data_source.dart';
import 'package:household_organizer/features/charts/data/repositories/charts_repository_impl.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';
import 'package:household_organizer/features/charts/domain/usecases/get_weekly_chart_data.dart';
import 'package:household_organizer/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/data/repositories/household_repository_impl.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';
import 'package:household_organizer/features/household/domain/usecases/load_household.dart';
import 'package:household_organizer/features/household/presentation/bloc/household_bloc.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/data/repositories/household_task_repository_impl.dart';
import 'package:household_organizer/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:household_organizer/features/household_task/domain/usecases/create_household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/delete_household_task.dart';
import 'package:household_organizer/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:household_organizer/features/household_task/domain/usecases/update_household_task.dart';
import 'package:household_organizer/features/household_task/presentation/bloc/household_task_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';
final sl = GetIt.instance;

Future<void> init() async {
  //! Features -
  // Bloc
  sl.registerFactory(
        () => HouseholdTaskBloc(
          getTasks: sl(),
          createTask: sl(),
          updateTask: sl(),
          deleteTask: sl(),
    ),
  );
  sl.registerFactory(
        () => HouseholdBloc(
      loadHousehold: sl(),
    ),
  );

  sl.registerFactory(
        () => AuthBloc(createAuth: sl(), loadAuth: sl(), createAuthDataOnServer: sl(), addAuthDataToHousehold: sl(), deleteAuthDataFromHousehold: sl())
  );

  sl.registerFactory(
        () => ChartBloc(
            getWeeklyChartData: sl()
        ,)
  );



  // Use cases
  sl.registerLazySingleton(() => GetAllTasksForHousehold(sl()));
  sl.registerLazySingleton(() => CreateHouseholdTask(repository: sl()));
  sl.registerLazySingleton(() => UpdateHouseholdTask(repository: sl()));
  sl.registerLazySingleton(() => DeleteHouseholdTask(repository: sl()));


  sl.registerLazySingleton(() => LoadHousehold(repository: sl()));

  sl.registerLazySingleton(() => AddAuthDataToHousehold(repository: sl()));
  sl.registerLazySingleton(() => DeleteAuthDataFromHousehold(repository: sl()));
  sl.registerLazySingleton(() => CreateAuthData(repository: sl()));
  sl.registerLazySingleton(() => LoadAuthData(repository: sl()));
  sl.registerLazySingleton(() => CreateAuthDataOnServer(repository: sl()));

  sl.registerLazySingleton(() => GetWeeklyBarChartData(repository: sl()));

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

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      dataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ChartsRepository>(
        () => ChartsRepositoryImpl(
      dataSource: sl(),
    ),
  );

  final pb = PocketBase('http://127.0.0.1:8090');

  const storage = FlutterSecureStorage();
  // Data sources
  sl.registerLazySingleton<HouseholdTaskRemoteDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => HouseholdTaskRemoteDataSourceImpl(userRecordService: RecordService(pb, 'users'), taskRecordService: RecordService(pb, 'tasks')),
  );

  sl.registerLazySingleton<HouseholdRemoteDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => HouseholdRemoteDataSourceImpl(userRecordService: RecordService(pb, 'users'), householdRecordService: RecordService(pb, 'household')),
  );



  sl.registerLazySingleton<AuthDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => AuthDataSourceImpl(storage: storage, userRecordService: RecordService(pb, 'users'), householdRecordService: RecordService(pb, 'household')),
  );

  sl.registerLazySingleton<ChartsDataSource>(
    //TODO: Need to make it possible to use different accounts
        () => ChartsDataSourceImpl(userRecordService: RecordService(pb, 'users'), pointRecordService: RecordService(pb, 'points')),
  );
  //! Cor
  //
  //! External
}