import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';

final RecordService tService = RecordService(PocketBase('http://127.0.0.1:8090'), 'collection');

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

final RecordModel tHouseholdTaskRecordModel  = RecordModel(
    data: {
      "id":"test id",
      "created":"2023-07-25 18:59:34.004Z",
      "updated":"2023-07-25 18:59:34.004Z",
      "collectionId":"test collection id",
      "collectionName":"tasks",
      "expand":{},
      "assigned_user":"",
      "due_to":"2023-07-14 12:00:00.000Z",
      "household":"test household",
      "points_worth":3,"title":"Waschen",
      "isDone": false
    },
);
final tHouseholdTaskListRecordModel = [
  RecordModel(
    data: {
      "id":"test id",
      "created":"2023-07-25 18:59:34.004Z",
      "updated":"2023-07-25 18:59:34.004Z",
      "collectionId":"test collection id",
      "collectionName":"tasks",
      "expand":{},
      "assigned_user":"",
      "due_to":"2023-07-14 12:00:00.000Z",
      "household":"test household",
      "points_worth":3,
      "title":"Waschen",
      "isDone": false
    },
  )
];

final tHouseholdTaskModelList = [
  HouseholdTaskModel.fromJSON(tHouseholdTaskListRecordModel[0].data, 'id')
];


final tHouseholdTask = HouseholdTask(id: '0', title: 'Waschen', date: DateTime(2023, 1,11), isDone: false);
final tHouseholdTask1 = HouseholdTask(id: '1', title: 'Waschen', isDone: false);
final tHouseholdTaskList = [tHouseholdTask, tHouseholdTask1];




final tHouseholdTaskModel = HouseholdTaskModel(id: "id", title: "Waschen", date: DateTime.tryParse("2023-07-14 12:00:00.000Z"), isDone: false);
final tHouseholdTaskModelJSON =  {
  "id":"id",
  "created":"2023-07-25 18:59:34.004Z",
  "updated":"2023-07-25 18:59:34.004Z",
  "collectionId":"test collection id",
  "collectionName":"tasks",
  "expand":{},
  "assigned_user":"",
  "due_to":"2023-07-14 12:00:00.000Z",
  "household":"test household",
  "points_worth":3,
  "title":"Waschen",
  "isDone": false
};