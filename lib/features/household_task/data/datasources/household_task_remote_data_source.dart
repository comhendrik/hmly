import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/widgets/helper_functions.dart';
import 'package:hmly/features/household_task/data/models/household_task_model.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../../core/entities/user.dart';


abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold(String householdID);
  Future<HouseholdTask> createHouseholdTask(String householdID, String title, int pointsWorth, String dueTo);
  Future<void> toggleIsDoneHouseholdTask(HouseholdTask task, UserData user);
  Future<void> deleteHouseholdTask(String taskId);
  Future<void> updateHouseholdTask(HouseholdTask task, Map<String, dynamic> updateData);
}

class HouseholdTaskRemoteDataSourceImpl implements HouseholdTaskRemoteDataSource {
  final RecordService userRecordService;
  final RecordService taskRecordService;
  final RecordService pointRecordService;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  HouseholdTaskRemoteDataSourceImpl({
    required this.userRecordService,
    required this.taskRecordService,
    required this.pointRecordService
  });

  @override
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold(String householdID) async {
    try {
      final tasks = await firestore.collection("households").doc(householdID).collection("tasks").get();
      List<HouseholdTaskModel> householdTaskModelList = [];
      for (final task in tasks.docs) {
        householdTaskModelList.add(HouseholdTaskModel.fromDocumentSnapshot(task));
      }
      return householdTaskModelList;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      print(err.toString());
      throw UnknownException();
    }

  }

  @override
  Future<HouseholdTaskModel> createHouseholdTask(String householdID, String title, int pointsWorth, String dueTo) async {
    final body = <String, dynamic>{
      "title": title,
      "pointsWorth": pointsWorth,
      "dueTo" : dueTo,
      "isDone" : false,
    };

    try {
      final snap = await firestore.collection("households").doc(householdID).collection("tasks").add(body);
      return HouseholdTaskModel.fromJSON(body, snap.id);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<void> toggleIsDoneHouseholdTask(HouseholdTask task, UserData user) async {
    if (task.doneBy != user.id && task.isDone) {
    throw KnownException("You haven't done the task, so cant undo it. Please delete it and create a new one, if you want to have it undone");
    }
    final taskBody = <String, dynamic> {
      "isDone": !task.isDone,
      "doneBy" : user.id
    };
    try {
      await firestore.collection("households").doc(user.householdID).collection("tasks").doc(task.id).update(taskBody);
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (err) {
      print(err.toString());
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