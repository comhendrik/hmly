import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import '../../../../statics.dart';

void main() {

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