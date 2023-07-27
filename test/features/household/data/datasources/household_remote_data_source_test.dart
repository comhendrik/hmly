import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

class MockRecordService extends Mock implements RecordService {}

void main() {
  late MockRecordService mockRecordServiceUser;
  late MockRecordService mockRecordServiceHousehold;
  late HouseholdRemoteDataSourceImpl dataSource;
  late String householdId;
  late String email;
  late String password;
  
  setUpAll(() {
    mockRecordServiceUser = MockRecordService();
    mockRecordServiceHousehold = MockRecordService();
    //Placeholder values
    householdId = 'id';
    email = 'email';
    password = 'password';
    dataSource = HouseholdRemoteDataSourceImpl(userRecordService: mockRecordServiceUser, householdRecordService: mockRecordServiceHousehold, email: email, password: password, householdId: householdId);
  });
  
  group('getAllTasksForHousehold', () {

    final tHouseholdRecordModel = RecordModel(
      data: {
        "id": "RECORD_ID",
        "collectionId": "gvartmnoybe3m81",
        "collectionName": "household",
        "created": "2022-01-01 01:00:00.123Z",
        "updated": "2022-01-01 23:59:59.456Z",
        "title": "test",
        "users": [
          "RELATION_RECORD_ID"
        ],
        "minWeeklyPoints": 123
      },
    );

    final tHouseholdModel = HouseholdModel.fromJSON(tHouseholdRecordModel.data);

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

      when(() => mockRecordServiceHousehold.getOne(householdId)).thenAnswer((_) async => tHouseholdRecordModel);

      final result = await dataSource.loadHousehold();

      verify(() => mockRecordServiceHousehold.getOne(householdId));

      verify(() => mockRecordServiceUser.authWithPassword(email, password));

      expect(result, tHouseholdModel);


    });

    test('should return ServerException when call is unsuccessful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceHousehold.getOne(householdId)).thenThrow(ServerException());


      expect(dataSource.loadHousehold(), throwsA(const TypeMatcher<ServerException>()));


    });
  });
}