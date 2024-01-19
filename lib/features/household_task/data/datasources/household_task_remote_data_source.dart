import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/widgets/helper_functions.dart';
import 'package:hmly/features/household_task/data/models/household_task_model.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';


abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold(String householdID);
  Future<HouseholdTask> createHouseholdTask(String householdID, String title, int pointsWorth, String dueTo);
  Future<void> toggleIsDoneHouseholdTask(HouseholdTask task, String userID);
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
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold(String householdID) async {
    try {
      final result = await taskRecordService.getFullList(filter: 'household="$householdID"', sort: 'isDone');
      List<HouseholdTaskModel> householdTaskModelList = [];
      for (final task in result) {
        householdTaskModelList.add(HouseholdTaskModel.fromJSON(task.data, task.id));
      }
      return householdTaskModelList;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      throw UnknownException();
    }

  }

  @override
  Future<HouseholdTaskModel> createHouseholdTask(String householdID, String title, int pointsWorth, String dueTo) async {
    final body = <String, dynamic>{
      "title": title,
      "household": householdID,
      "points_worth": pointsWorth,
      "due_to" : dueTo,
    };
    try {
      final record = await taskRecordService.create(body: body);
      return HouseholdTaskModel.fromJSON(record.data, record.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> toggleIsDoneHouseholdTask(HouseholdTask task, String userID) async {
    if (task.doneBy != userID && task.isDone) {
    throw KnownException("You haven't done the task, so cant undo it. Please delete it and create a new one, if you want to have it undone");
    }
    final taskBody = <String, dynamic>{
      "isDone": !task.isDone,
      "done_by" : userID
    };
    try {
      final _ = await taskRecordService.update(task.id, body: taskBody);
      String operator = '+';

      //task.isDone is static which is why this will be executed, when you undo the task
      if (task.isDone == true) {
        operator = '-';
      }
      final pointBody = <String, dynamic> {
        "value$operator" : task.pointsWorth,
        "user" : userID
      };
      final today = DateTime.now();
      final todayFilter = createFilterDate(today);
      final tomorrowFilter = createFilterDate(today.add(const Duration(days: 1)));

      final String filter = 'user = "$userID" && created >= "$todayFilter" && created < "$tomorrowFilter"';
      final pointToUpdate = await pointRecordService.getFullList(filter: filter);
      if (pointToUpdate.isEmpty) {
        pointRecordService.create(body: pointBody);
      } else {
        pointRecordService.update(pointToUpdate[0].id, body: pointBody);
      }
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> deleteHouseholdTask(String taskId) async {
    try {
      final _ = await taskRecordService.delete(taskId);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData) async {
    try {
      final _ = await taskRecordService.update(task.id, body: updateData);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }
}