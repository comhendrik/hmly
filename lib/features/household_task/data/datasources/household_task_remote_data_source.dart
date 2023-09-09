import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:household_organizer/core/entities/user.dart';
abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold(String householdId);
  Future<HouseholdTask> createHouseholdTask(String householdId, String title, int pointsWorth);
}

class HouseholdTaskRemoteDataSourceImpl implements HouseholdTaskRemoteDataSource {
  final RecordService userRecordService;
  final RecordService taskRecordService;


  HouseholdTaskRemoteDataSourceImpl({
    required this.userRecordService,
    required this.taskRecordService,
  });

  @override
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold(String householdId) async {
    try {
      final result = await taskRecordService.getFullList(filter: 'household="$householdId"', sort: '-created');
      List<HouseholdTaskModel> householdTaskModelList = [];
      for (final task in result) {
        householdTaskModelList.add(HouseholdTaskModel.fromJSON(task.data, task.id));
      }
      return householdTaskModelList;
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<HouseholdTaskModel> createHouseholdTask(String householdId, String title, int pointsWorth) async {
    final body = <String, dynamic>{
      "title": title,
      "household": householdId,
      "points_worth": pointsWorth,
    };
    try {
      final record = await taskRecordService.create(body: body);
      return HouseholdTaskModel.fromJSON(record.data, record.id);
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }
}