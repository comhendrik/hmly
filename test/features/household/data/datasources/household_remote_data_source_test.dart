import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

class MockRecordService extends Mock implements RecordService {}

void main() {
  late MockRecordService mockUserRecordService;
  late MockRecordService mockHouseholdRecordService;
  late HouseholdRemoteDataSourceImpl dataSource;
  late String householdID;
  
  setUpAll(() {
    mockUserRecordService = MockRecordService();
    mockHouseholdRecordService = MockRecordService();
    dataSource = HouseholdRemoteDataSourceImpl(userRecordService: mockUserRecordService, householdRecordService: mockHouseholdRecordService);
    householdID = 'tHouseholdID';
  });
  
  group('loadHousehold', () {


    final tHouseholdRecordModel = RecordModel(
      id: "jpjp0avrs60d0sl",
      data: {
        "id":"jpjp0avrs60d0sl",
        "created":"2023-10-17 17:41:26.595Z",
        "updated":"2023-11-04 13:00:56.240Z",
        "collectionId":"gvartmnoybe3m81",
        "collectionName":"household",
        "expand": {"admin":
          { "id":"wsjo0uutd3jgb67",
            "created":"2023-10-18 16:34:44.858Z",
            "updated":"2023-11-04 13:06:45.145Z",
            "collectionId":"_pb_users_auth_",
            "collectionName":"users",
            "expand":{},
            "avatar":"",
            "email":"hendrik3@test.com",
            "emailVisibility":true,
            "household":"jpjp0avrs60d0sl",
            "name":"Test",
            "username":"Mara",
            "verified":true
          }
        },
        "admin":"wsjo0uutd3jgb67",
        "title":"Test "
      },
      expand: {"admin": [RecordModel(
          id: "wsjo0uutd3jgb67",
          data: {
            "id":"wsjo0uutd3jgb67",
            "created":"2023-10-18 16:34:44.858Z",
            "updated":"2023-11-04 13:06:45.145Z",
            "collectionId":"_pb_users_auth_",
            "collectionName":"users",
            "expand":{},
            "avatar":"",
            "email":"hendrik3@test.com",
            "emailVisibility":true,
            "household":"jpjp0avrs60d0sl",
            "name":"Test",
            "username":"username",
            "verified":true
            },
          )
        ]
      },
    );

    final tUserRecordModel = RecordModel(
      id: "wsjo0uutd3jgb67",
      data: {
        "id":"wsjo0uutd3jgb67",
        "created":"2023-10-18 16:34:44.858Z",
        "updated":"2023-11-04 13:06:45.145Z",
        "collectionId":"_pb_users_auth_",
        "collectionName":"users",
        "expand":{},
        "avatar":"",
        "email":"hendrik3@test.com",
        "emailVisibility":true,
        "household":"jpjp0avrs60d0sl",
        "name":"Test",
        "username":"username",
        "verified":true
      },
    );

    final List<User> tUsers = [User.fromJSON(tUserRecordModel.data, tUserRecordModel.id)];


    final tHouseholdModel = HouseholdModel.fromJSON(tHouseholdRecordModel.data, tHouseholdRecordModel.id, tUsers, tHouseholdRecordModel.expand['admin']!.first.data, tHouseholdRecordModel.expand['admin']!.first.id);

    test('should return data when call is successful', () async {


      when(() => mockHouseholdRecordService.getOne(householdID, expand: 'admin')).thenAnswer((_) async => tHouseholdRecordModel);

      when(() => mockUserRecordService.getFullList(filter: 'household="$householdID"')).thenAnswer((_) async => [tUserRecordModel]);


      final result = await dataSource.loadHousehold(householdID);


      expect(tHouseholdModel, equals(result));


    });

    test('should throw ServerException when something happens when loading normal household', () async {
      when(() => mockHouseholdRecordService.getOne(householdID, expand: 'admin')).thenThrow(ClientException());

      expect(dataSource.loadHousehold(householdID), throwsA(const TypeMatcher<ServerException>()));

    });

    test('should throw ServerException when something happens when loading user ', () async {
      when(() => mockHouseholdRecordService.getOne(householdID, expand: 'admin')).thenAnswer((_) async => tHouseholdRecordModel);

      when(() => mockUserRecordService.getFullList(filter: 'household="$householdID"')).thenThrow(ClientException());

      expect(dataSource.loadHousehold(householdID), throwsA(const TypeMatcher<ServerException>()));

    });
    
  });

  group('updateHouseholdTitle', () {

    const String newTitle = "New Title";

    final tBody = <String, dynamic> {
      "title" : newTitle,
    };


    final tupdatedHouseholdRecordModel = RecordModel(
      id: "jpjp0avrs60d0sl",
      data: {
        "id":"jpjp0avrs60d0sl",
        "created":"2023-10-17 17:41:26.595Z",
        "updated":"2023-11-04 13:00:56.240Z",
        "collectionId":"gvartmnoybe3m81",
        "collectionName":"household",
        "expand": {"admin":
        { "id":"wsjo0uutd3jgb67",
          "created":"2023-10-18 16:34:44.858Z",
          "updated":"2023-11-04 13:06:45.145Z",
          "collectionId":"_pb_users_auth_",
          "collectionName":"users",
          "expand":{},
          "avatar":"",
          "email":"hendrik3@test.com",
          "emailVisibility":true,
          "household":"jpjp0avrs60d0sl",
          "name":"Test",
          "username":"Mara",
          "verified":true
        }
        },
        "admin":"wsjo0uutd3jgb67",
        "title": newTitle
      },
      expand: {"admin": [RecordModel(
        id: "wsjo0uutd3jgb67",
        data: {
          "id":"wsjo0uutd3jgb67",
          "created":"2023-10-18 16:34:44.858Z",
          "updated":"2023-11-04 13:06:45.145Z",
          "collectionId":"_pb_users_auth_",
          "collectionName":"users",
          "expand":{},
          "avatar":"",
          "email":"hendrik3@test.com",
          "emailVisibility":true,
          "household":"jpjp0avrs60d0sl",
          "name":"Test",
          "username":"username",
          "verified":true
        },
      )
      ]
      },
    );

    final tUserRecordModel = RecordModel(
      id: "wsjo0uutd3jgb67",
      data: {
        "id":"wsjo0uutd3jgb67",
        "created":"2023-10-18 16:34:44.858Z",
        "updated":"2023-11-04 13:06:45.145Z",
        "collectionId":"_pb_users_auth_",
        "collectionName":"users",
        "expand":{},
        "avatar":"",
        "email":"hendrik3@test.com",
        "emailVisibility":true,
        "household":"jpjp0avrs60d0sl",
        "name":"Test",
        "username":"username",
        "verified":true
      },
    );

    final List<User> tUsers = [UserModel.fromJSON(tUserRecordModel.data, tUserRecordModel.id)];


    final tupdatedHouseholdModel = HouseholdModel.fromJSON(tupdatedHouseholdRecordModel.data, tupdatedHouseholdRecordModel.id, tUsers, tupdatedHouseholdRecordModel.expand['admin']!.first.data, tupdatedHouseholdRecordModel.expand['admin']!.first.id);

    test('should return data when call is successful', () async {


      when(() => mockHouseholdRecordService.update(householdID, body: tBody, expand: 'admin')).thenAnswer((_) async => tupdatedHouseholdRecordModel);

      when(() => mockUserRecordService.getFullList(filter: 'household="$householdID"')).thenAnswer((_) async => [tUserRecordModel]);


      final result = await dataSource.updateHouseholdTitle(householdID, newTitle);


      expect(tupdatedHouseholdModel, equals(result));


    });


    test('should throw ServerException when something happens when updating normal household', () async {
      when(() => mockHouseholdRecordService.update(householdID, body: tBody, expand: 'admin')).thenThrow(ClientException());

      expect(dataSource.updateHouseholdTitle(householdID, newTitle), throwsA(const TypeMatcher<ServerException>()));

    });

    test('should throw ServerException when something happens when loading user ', () async {
      when(() => mockHouseholdRecordService.update(householdID, body: tBody, expand: 'admin')).thenAnswer((_) async => tupdatedHouseholdRecordModel);

      when(() => mockUserRecordService.getFullList(filter: 'household="$householdID"')).thenThrow(ClientException());

      expect(dataSource.updateHouseholdTitle(householdID, newTitle), throwsA(const TypeMatcher<ServerException>()));

    });



  });

  group('deleteAuthDataFromHousehold', () {


    final tBody = <String, dynamic> {
      "household" : "",
    };

    final tupdatedUserRecordModel = RecordModel(
      id: "wsjo0uutd3jgb67",
      data: {
        "id":"wsjo0uutd3jgb67",
        "created":"2023-10-18 16:34:44.858Z",
        "updated":"2023-11-04 13:06:45.145Z",
        "collectionId":"_pb_users_auth_",
        "collectionName":"users",
        "expand":{},
        "avatar":"",
        "email":"hendrik3@test.com",
        "emailVisibility":true,
        "household":"",
        "name":"Test",
        "username":"username",
        "verified":true
      },
    );

    const String userID = "userID";

    test('should return void when call is successful', () async {

      when(() => mockUserRecordService.update(userID, body: tBody)).thenAnswer((_) async => tupdatedUserRecordModel);

      await dataSource.deleteAuthDataFromHousehold(userID);

      verify(() => mockUserRecordService.update(userID, body: tBody));

    });

    test('should throw ServerException when call is unsuccessful', () async {

      when(() => mockUserRecordService.update(userID, body: tBody)).thenThrow(ClientException());

      expect(dataSource.deleteAuthDataFromHousehold(userID), throwsA(const TypeMatcher<ServerException>()));


    });







  });


  group('updateAdmin', () {

  });

  group('deleteHousehold', () {

    const String householdID = "householdID";

    test('should return void when call is successful', () async {

      when(() => mockHouseholdRecordService.delete(householdID)).thenAnswer((_) async => ());

      await dataSource.deleteHousehold(householdID);

      verify(() => mockHouseholdRecordService.delete(householdID));

    });

    test('should throw ServerException when call is unsuccessful', () async {

      when(() => mockHouseholdRecordService.delete(householdID)).thenThrow(ClientException());

      expect(dataSource.deleteHousehold(householdID), throwsA(const TypeMatcher<ServerException>()));

    });







  });



}