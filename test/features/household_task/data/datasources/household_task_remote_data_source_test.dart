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
  late MockRecordService mockRecordServicePoints;
  late HouseholdTaskRemoteDataSourceImpl dataSource;
  
  setUpAll(() {
    mockRecordServiceUser = MockRecordService();
    mockRecordServiceTask = MockRecordService();
    mockRecordServicePoints = MockRecordService();
    dataSource = HouseholdTaskRemoteDataSourceImpl(userRecordService: mockRecordServiceUser, taskRecordService: mockRecordServiceTask, pointRecordService: mockRecordServicePoints)
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
        id: "id",
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

      when(() => mockRecordServiceTask.getFullList(filter: 'household="$householdId"', sort: '-created')).thenAnswer((_) async => tHouseholdTaskListRecordModel);

      final result = await dataSource.getAllTaskForHousehold();

      verify(() => mockRecordServiceTask.getFullList(filter: 'household="$householdId"', sort: '-created'));

      verify(() => mockRecordServiceUser.authWithPassword(email, password));

      expect(result, tHouseholdTaskModelList);


    });

    test('should return ServerException when call is unsuccessful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceTask.getFullList(filter: 'household="$householdId"', sort: '-created')).thenThrow(ServerException());


      expect(dataSource.getAllTaskForHousehold(), throwsA(const TypeMatcher<ServerException>()));


    });
  });

  group('createHouseholdTask', () {

    final tTitle = 'test';
    final tPointsWorth = 2;

    final tBody =  {
      "title": tTitle,
      "household": "id",
      "points_worth": tPointsWorth,
    };

    final tHouseholdTaskRecordModel = RecordModel(
      id: "id",
      data: {
        "id":"id",
        "created":"2023-07-25 18:59:34.004Z",
        "updated":"2023-07-25 18:59:34.004Z",
        "collectionId":"test collection id",
        "collectionName":"tasks",
        "expand":{},
        "assigned_user":"",
        "due_to":"2023-07-14 12:00:00.000Z",
        "household":"id",
        "points_worth":tPointsWorth,
        "title":tTitle,
        "isDone": false
      },
    );

    final tHouseholdTaskModel = HouseholdTaskModel.fromJSON(tHouseholdTaskRecordModel.data, tHouseholdTaskRecordModel.id);

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

      when(() => mockRecordServiceTask.create(body: tBody)).thenAnswer((_) async => tHouseholdTaskRecordModel);

      final result = await dataSource.createHouseholdTask(tTitle, tPointsWorth);

      verify(() => mockRecordServiceTask.create(body: tBody));

      verify(() => mockRecordServiceUser.authWithPassword(email, password));

      expect(result, tHouseholdTaskModel);


    });

    test('should return ServerException when call is unsuccessful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceTask.create(body: tBody)).thenThrow(ServerException());


      expect(dataSource.createHouseholdTask(tTitle, tPointsWorth), throwsA(const TypeMatcher<ServerException>()));


    });
  });
}