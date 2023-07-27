import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';

void main() {

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

  test('should be an instance of type householdTask', ()  async {
    expect(tHouseholdTaskModel, isA<HouseholdTask>());
  });

  group('fromJSON', () {



    test('should return HouseholdTaskModel from JSON', () async {
      final result = HouseholdTaskModel.fromJSON(tHouseholdTaskModelJSON, 'id');
      expect(result.title, equals(tHouseholdTaskModel.title));
    });
  });
}