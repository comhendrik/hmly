import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';

void main() {
  final tHouseholdModelJSON =  {
    "id": "RECORD_ID",
    "collectionId": "gvartmnoybe3m81",
    "collectionName": "household",
    "created": "2022-01-01 01:00:00.123Z",
    "updated": "2022-01-01 23:59:59.456Z",
    "title": "test",
    "users": [
      "RELATION_RECORD_ID"
    ],
    "minWeeklyPoints": 123
  };

  final tHouseholdModel = HouseholdModel.fromJSON(tHouseholdModelJSON);

  test('should be an instance of type householdTask', ()  async {
    expect(tHouseholdModel, isA<Household>());
  });

  group('fromJSON', () {
    test('should return HouseholdTaskModel from JSON', () async {
      final result = HouseholdModel.fromJSON(tHouseholdModelJSON);
      expect(result, equals(tHouseholdModel));
    });
  });
}