import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold();
}

class HouseholdTaskRemoteDataSourceImpl implements HouseholdTaskRemoteDataSource {
  final RecordService userRecordService;
  final RecordService householdRecordService;
  final String email;
  final String password;
  final String householdId;

  HouseholdTaskRemoteDataSourceImpl({
    required this.userRecordService,
    required this.householdRecordService,
    required this.email,
    required this.password,
    required this.householdId
  });

  @override
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold() async {
    final _ = await userRecordService.authWithPassword(email, password);
    try {
      final result = await householdRecordService.getFullList(filter: 'household=$householdId');
      List<HouseholdTaskModel> householdTaskModelList = [];
      for (final task in result) {
        householdTaskModelList.add(HouseholdTaskModel.fromJSON(task.data));
      }
      return householdTaskModelList;
    } catch(err) {
      throw ServerException();
    }

  }
}