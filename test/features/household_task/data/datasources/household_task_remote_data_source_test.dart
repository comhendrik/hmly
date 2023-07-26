import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../../statics.dart';

class MockRecordService extends Mock implements RecordService {}

void main() {
  late MockRecordService mockRecordServiceUser;
  late MockRecordService mockRecordServiceHousehold;
  late HouseholdTaskRemoteDataSourceImpl dataSource;
  late String householdId;
  late String email;
  late String password;
  
  setUpAll(() {
    mockRecordServiceUser = MockRecordService();
    mockRecordServiceHousehold = MockRecordService();
    householdId = 'ehhmumqij2n1mmn';
    email = 'test@test.com';
    password = '12345678';
    dataSource = HouseholdTaskRemoteDataSourceImpl(userRecordService: mockRecordServiceUser, householdRecordService: mockRecordServiceHousehold, email: email, password: password, householdId: householdId);
  });
  
  group('getAllTasksForHousehold', () {



    test('should return data when call is successful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceHousehold.getFullList(filter: 'household=$householdId')).thenAnswer((_) async => tHouseholdTaskListRecordModel);

      final result = await dataSource.getAllTaskForHousehold();

      verify(() => mockRecordServiceHousehold.getFullList(filter: 'household=$householdId'));

      verify(() => mockRecordServiceUser.authWithPassword(email, password));

      expect(result.length, tHouseholdTaskModelList.length);


    });

    test('should return ServerException when call is unsuccessful', () async {


      when(() => mockRecordServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => mockRecordServiceHousehold.getFullList(filter: 'household=$householdId')).thenThrow(ServerException());


      expect(dataSource.getAllTaskForHousehold(), throwsA(const TypeMatcher<ServerException>()));


    });
  });
}