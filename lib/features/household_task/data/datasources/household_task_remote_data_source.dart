import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold();
  Future<HouseholdTask> createHouseholdTask(String title, int pointsWorth);
}

class HouseholdTaskRemoteDataSourceImpl implements HouseholdTaskRemoteDataSource {
  final RecordService userRecordService;
  final RecordService taskRecordService;
  final String email;
  final String password;
  final String householdId;

  HouseholdTaskRemoteDataSourceImpl({
    required this.userRecordService,
    required this.taskRecordService,
    required this.email,
    required this.password,
    required this.householdId
  });

  @override
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold() async {
    try {
      final _ = await userRecordService.authWithPassword(email, password);
      final result = await taskRecordService.getFullList(filter: 'household="$householdId"', sort: '-created');
      List<HouseholdTaskModel> householdTaskModelList = [];
      for (final task in result) {
        householdTaskModelList.add(HouseholdTaskModel.fromJSON(task.data, task.id));
      }
      return householdTaskModelList;
    } catch(err) {
      throw ServerException();
    }

  }

  @override
  Future<HouseholdTaskModel> createHouseholdTask(String title, int pointsWorth) async {

    try {
      final body = <String, dynamic>{
        "title": title,
        "household": householdId,
        "points_worth": pointsWorth,
      };

      final record = await taskRecordService.create(body: body);
      return HouseholdTaskModel.fromJSON(record.data, record.id);
    } catch(err) {
      throw ServerException();
    }

  }
}