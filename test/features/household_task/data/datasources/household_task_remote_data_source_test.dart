import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/features/household_task/data/datasources/household_task_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../../statics.dart';

class MockPocketbase extends Mock implements PocketBase {}

void main() {
  late MockPocketbase mockpb;
  late HouseholdTaskRemoteDataSourceImpl dataSource;
  late String householdId;
  late String email;
  late String password;
  
  setUpAll(() {
    mockpb = MockPocketbase();
    householdId = 'ehhmumqij2n1mmn';
    email = 'test@test.com';
    password = '12345678';
    dataSource = HouseholdTaskRemoteDataSourceImpl(pb: mockpb, email: email, password: password, householdId: householdId);
  });
  
  group('getAllTasksForHousehold', () {



    test('should return data when call is successful', () async {

      final tServiceUser = RecordService(mockpb, 'users');

      final tServiceHouseholds = RecordService(mockpb, 'households');

      when(() => mockpb.collection('users')).thenReturn(tServiceUser);

      when(() => mockpb.collection('households')).thenReturn(tServiceHouseholds);


      when(() => tServiceUser.authWithPassword(email, password)).thenAnswer((_) async => tAuth);

      when(() => tServiceHouseholds.getFullList(filter: 'household=$householdId')).thenAnswer((_) async => tHouseholdTaskList);

      final result = await dataSource.getAllTaskForHousehold();

      expect(result, equals(tHouseholdTaskList));


    });
  });
}