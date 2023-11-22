import 'package:hmly/features/authentication/data/datasources/auth_data_source.dart';
import 'package:hmly/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:hmly/features/authentication/domain/repositories/auth_repository.dart';
import 'package:hmly/features/authentication/domain/usecases/add_auth_data_to_household.dart';
import 'package:hmly/features/authentication/domain/usecases/change_user_attributes.dart';
import 'package:hmly/features/authentication/domain/usecases/create_household_and_add_auth_data.dart';
import 'package:hmly/features/authentication/domain/usecases/delete_user.dart';
import 'package:hmly/features/authentication/domain/usecases/refresh_auth_data.dart';
import 'package:hmly/features/authentication/domain/usecases/request_email_change.dart';
import 'package:hmly/features/authentication/domain/usecases/request_new_password.dart';
import 'package:hmly/features/authentication/domain/usecases/request_verification.dart';
import 'package:hmly/features/authentication/domain/usecases/sign_up.dart';
import 'package:hmly/features/authentication/domain/usecases/leave_household.dart';
import 'package:hmly/features/authentication/domain/usecases/login.dart';
import 'package:hmly/features/authentication/domain/usecases/load_auth_data_with_o_auth.dart';
import 'package:hmly/features/authentication/domain/usecases/logout.dart';
import 'package:hmly/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:hmly/features/charts/data/datasources/charts_data_source.dart';
import 'package:hmly/features/charts/data/repositories/charts_repository_impl.dart';
import 'package:hmly/features/charts/domain/repositories/charts_repository.dart';
import 'package:hmly/features/charts/domain/usecases/get_daily_pie_chart_data.dart';
import 'package:hmly/features/charts/domain/usecases/get_weekly_bar_chart_data.dart';
import 'package:hmly/features/charts/presentation/bloc/chart_bloc.dart';
import 'package:hmly/features/household/data/datasources/household_remote_data_source.dart';
import 'package:hmly/features/household/data/repositories/household_repository_impl.dart';
import 'package:hmly/features/household/domain/repositories/household_repository.dart';
import 'package:hmly/features/household/domain/usecases/delete_auth_data_from_household.dart';
import 'package:hmly/features/household/domain/usecases/delete_household.dart';
import 'package:hmly/features/household/domain/usecases/load_household.dart';
import 'package:hmly/features/household/domain/usecases/update_admin.dart';
import 'package:hmly/features/household/domain/usecases/update_household_title.dart';
import 'package:hmly/features/household/presentation/bloc/household_bloc.dart';
import 'package:hmly/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:hmly/features/household_task/data/repositories/household_task_repository_impl.dart';
import 'package:hmly/features/household_task/domain/repositories/household_task_repository.dart';
import 'package:hmly/features/household_task/domain/usecases/create_household_task.dart';
import 'package:hmly/features/household_task/domain/usecases/delete_household_task.dart';
import 'package:hmly/features/household_task/domain/usecases/get_all_tasks_for_household.dart';
import 'package:hmly/features/household_task/domain/usecases/toggle_is_done_household_task.dart';
import 'package:hmly/features/household_task/domain/usecases/update_household_task.dart';
import 'package:hmly/features/household_task/presentation/bloc/household_task_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

final sl = GetIt.instance;



Future<void> init() async {

  final prefs = await SharedPreferences.getInstance();
  final store = AsyncAuthStore(
    save:    (String data) async => prefs.setString('pb_auth', data),
    initial: prefs.getString('pb_auth'),
  );

  final pb = PocketBase('https://household-organizer.hop.sh', authStore: store);

  //! Features -
  // Bloc

  sl.registerFactory(
        () => HouseholdTaskBloc(
          getTasks: sl(),
          createTask: sl(),
          toggleIsDoneHouseholdTask: sl(),
          updateTask: sl(),
          deleteTask: sl(),
    ),
  );

  sl.registerFactory(
        () => HouseholdBloc(
          loadHousehold: sl(),
          updateHouseholdTitle: sl(),
          deleteAuthDataFromHousehold: sl(),
          updateAdmin: sl(),
          deleteHousehold: sl()
    ),
  );

  sl.registerFactory(
        () => AuthBloc(
          login: sl(),
          createAuthDataOnServer: sl(),
          createHouseholdAndAddAuthData: sl(),
          addAuthDataToHousehold: sl(),
          leaveHousehold: sl(),
          loadAuthDataWithOAuth: sl(),
          logout: sl(),
          changeUserAttributes: sl(),
          requestNewPassword: sl(),
          requestEmailChange: sl(),
          requestVerification: sl(),
          refreshAuthData: sl(),
          deleteUser: sl(),
          authStore: store
        )
  );

  sl.registerFactory(
        () => ChartBloc(
          getWeeklyBarChartData: sl(),
          getDailyPieChartData: sl(),
        )
  );



  // Use cases
  sl.registerLazySingleton(() => GetAllTasksForHousehold(sl()));
  sl.registerLazySingleton(() => CreateHouseholdTask(repository: sl()));
  sl.registerLazySingleton(() => ToggleIsDoneHouseholdTask(repository: sl()));
  sl.registerLazySingleton(() => UpdateHouseholdTask(repository: sl()));
  sl.registerLazySingleton(() => DeleteHouseholdTask(repository: sl()));


  sl.registerLazySingleton(() => LoadHousehold(repository: sl()));
  sl.registerLazySingleton(() => UpdateHouseholdTitle(repository: sl()));
  sl.registerLazySingleton(() => DeleteAuthDataFromHousehold(repository: sl()));
  sl.registerLazySingleton(() => UpdateAdmin(repository: sl()));
  sl.registerLazySingleton(() => DeleteHousehold(repository: sl()));

  sl.registerLazySingleton(() => AddAuthDataToHousehold(repository: sl()));
  sl.registerLazySingleton(() => CreateHouseholdAndAddAuthData(repository: sl()));
  sl.registerLazySingleton(() => LeaveHousehold(repository: sl()));
  sl.registerLazySingleton(() => Login(repository: sl()));
  sl.registerLazySingleton(() => SignUp(repository: sl()));
  sl.registerLazySingleton(() => LoadAuthDataWithOAuth(repository: sl()));
  sl.registerLazySingleton(() => Logout(repository: sl()));
  sl.registerLazySingleton(() => ChangeUserAttributes(repository: sl()));
  sl.registerLazySingleton(() => RequestNewPassword(repository: sl()));
  sl.registerLazySingleton(() => RequestEmailChange(repository: sl()));
  sl.registerLazySingleton(() => RequestVerification(repository: sl()));
  sl.registerLazySingleton(() => RefreshAuthData(repository: sl()));
  sl.registerLazySingleton(() => DeleteUser(repository: sl()));

  sl.registerLazySingleton(() => GetWeeklyBarChartData(repository: sl()));
  sl.registerLazySingleton(() => GetDailyPieChartData(repository: sl()));

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




  // Data sources
  sl.registerLazySingleton<HouseholdTaskRemoteDataSource>(
        () => HouseholdTaskRemoteDataSourceImpl(userRecordService: RecordService(pb, 'users'), taskRecordService: RecordService(pb, 'tasks'), pointRecordService: RecordService(pb, 'points')),
  );

  sl.registerLazySingleton<HouseholdRemoteDataSource>(
        () => HouseholdRemoteDataSourceImpl(userRecordService: RecordService(pb, 'users'), householdRecordService: RecordService(pb, 'household')),
  );



  sl.registerLazySingleton<AuthDataSource>(
        () => AuthDataSourceImpl(userRecordService: RecordService(pb, 'users'), householdRecordService: RecordService(pb, 'household'), pointsRecordService: RecordService(pb, 'points'), authStore: pb.authStore),
  );

  sl.registerLazySingleton<ChartsDataSource>(
        () => ChartsDataSourceImpl(userRecordService: RecordService(pb, 'users'), pointRecordService: RecordService(pb, 'points'), householdRecordService: RecordService(pb, 'household')),
  );


  //! Cor
  //
  //! External
}