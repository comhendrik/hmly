import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:household_organizer/core/entities/user.dart';
abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold(String householdId);
  Future<HouseholdTask> createHouseholdTask(String householdId, String title, int pointsWorth, String dueTo);
  Future<void> toggleIsDoneHouseholdTask(HouseholdTask task, String userId);
  Future<void> deleteHouseholdTask(String taskId);
  Future<void> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData);
}

class HouseholdTaskRemoteDataSourceImpl implements HouseholdTaskRemoteDataSource {
  final RecordService userRecordService;
  final RecordService taskRecordService;
  final RecordService pointRecordService;


  HouseholdTaskRemoteDataSourceImpl({
    required this.userRecordService,
    required this.taskRecordService,
    required this.pointRecordService
  });

  @override
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold(String householdId) async {
    try {
      final result = await taskRecordService.getFullList(filter: 'household="$householdId"', sort: 'isDone');
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
  Future<HouseholdTaskModel> createHouseholdTask(String householdId, String title, int pointsWorth, String dueTo) async {
    final body = <String, dynamic>{
      "title": title,
      "household": householdId,
      "points_worth": pointsWorth,
      "due_to" : dueTo,
    };
    try {
      final record = await taskRecordService.create(body: body);
      return HouseholdTaskModel.fromJSON(record.data, record.id);
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<void> toggleIsDoneHouseholdTask(HouseholdTask task, String userId) async {
    final taskBody = <String, dynamic>{
      "isDone": !task.isDone
    };
    try {
      final record = await taskRecordService.update(task.id, body: taskBody);
      String operator = '+';

      //task.isDone is static which is why this will be executed, when you undo the task
      if (task.isDone == true) {
        operator = '-';
      }
      final pointBody = <String, dynamic> {
        "value$operator" : task.pointsWorth
      };
      int currentDayOfWeek = DateTime.now().weekday;
      final pointToUpdate = await pointRecordService.getFirstListItem('day_number=$currentDayOfWeek && user="$userId"');
      final _ = await pointRecordService.update(pointToUpdate.id, body: pointBody);
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<void> deleteHouseholdTask(String taskId) async {
    try {
      final record = await taskRecordService.delete(taskId);
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<void> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData) async {
    try {
      final _ = await taskRecordService.update(task.id, body: updateData);
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }
}