import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

class MockRecordService extends Mock implements RecordService {}

void main() {
  late MockRecordService mockRecordServiceUser;
  late MockRecordService mockRecordServiceTask;
  late HouseholdTaskRemoteDataSourceImpl dataSource;
  late String householdId;
  late String email;
  late String password;
  
  setUpAll(() {
    mockRecordServiceUser = MockRecordService();
    mockRecordServiceTask = MockRecordService();
    //Placeholder values
    householdId = 'id';
    email = 'email';
    password = 'password';
    dataSource = HouseholdTaskRemoteDataSourceImpl(userRecordService: mockRecordServiceUser, taskRecordService: mockRecordServiceTask, email: email, password: password, householdId: householdId);
  });
  
  group('getAllTasksForHousehold', () {

    final tHouseholdTaskModelJSON =  {
      "id":"id",
      "created":"2023-07-25 18:59:34.004Z",
      "updated":"2023-07-25 18:59:34.004Z",
      "collectionId":"test collection id",
      "collectionName":"tasks",
      "expand":{},
      "assigned_user":"",
      "due_to":"2023-07-14 12:00:00.000Z",
      "household":"test household",
      "points_worth":3,
      "title":"Waschen",
      "isDone": false
    };

    final tHouseholdTaskModelList = [HouseholdTaskModel.fromJSON(tHouseholdTaskModelJSON, 'id')];

    final tHouseholdTaskListRecordModel = [
      RecordModel(
        data: {
          "id":"id",
          "created":"2023-07-25 18:59:34.004Z",
          "updated":"2023-07-25 18:59:34.004Z",
          "collectionId":"test collection id",
          "collectionName":"tasks",
          "expand":{},
          "assigned_user":"",
          "due_to":"2023-07-14 12:00:00.000Z",
          "household":"test household",
          "points_worth":3,
          "title":"Waschen",
          "isDone": false
        },
      )
    ];

    final RecordAuth tAuth = RecordAuth(
        token :"test token",
        record : RecordModel(data: {
          "id":"test id",
          "created":"2023-06-05 14:45:58.896Z",
          "updated":"2023-06-05 14:45:58.896Z",
          "collectionId":"_pb_users_auth_",
          "collectionName":"users",
          "expand":{},
          "avatar":"",
          "email":"test@test.com",
          "emailVisibility":false,"name":"Test name",
          "username":"test username","verified":true
        }),
        meta :{}
    );
    test('should return data when call is successful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceTask.getFullList(filter: 'household="$householdId"')).thenAnswer((_) async => tHouseholdTaskListRecordModel);

      final result = await dataSource.getAllTaskForHousehold();

      verify(() => mockRecordServiceTask.getFullList(filter: 'household="$householdId"'));

      verify(() => mockRecordServiceUser.authWithPassword(email, password));

      expect(result.length, tHouseholdTaskModelList.length);


    });

    test('should return ServerException when call is unsuccessful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceTask.getFullList(filter: 'household="$householdId"')).thenThrow(ServerException());


      expect(dataSource.getAllTaskForHousehold(), throwsA(const TypeMatcher<ServerException>()));


    });
  });
}