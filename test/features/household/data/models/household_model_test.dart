import 'package:flutter_test/flutter_test.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {

  const tUserModel = UserModel(
      id: "id",
      username: "username",
      householdID: "householdID",
      email: "email",
      name: "name",
      verified: true
  );

  final tUsers = [tUserModel];

  final tHouseholdRecordModel = RecordModel(
    id: "jpjp0avrs60d0sl",
    data: {
      "id":"jpjp0avrs60d0sl",
      "created":"2023-10-17 17:41:26.595Z",
      "updated":"2023-11-04 13:00:56.240Z",
      "collectionId":"gvartmnoybe3m81",
      "collectionName":"household",
      "expand": {"admin":
      { "id":"wsjo0uutd3jgb67",
        "created":"2023-10-18 16:34:44.858Z",
        "updated":"2023-11-04 13:06:45.145Z",
        "collectionId":"_pb_users_auth_",
        "collectionName":"users",
        "expand":{},
        "avatar":"",
        "email":"hendrik3@test.com",
        "emailVisibility":true,
        "household":"jpjp0avrs60d0sl",
        "name":"Test",
        "username":"username",
        "verified":true
      }
      },
      "admin":"wsjo0uutd3jgb67",
      "title":"Test "
    },
    expand: {"admin":
      [
        RecordModel(
          id: "wsjo0uutd3jgb67",
          data: {
            "id":"wsjo0uutd3jgb67",
            "created":"2023-10-18 16:34:44.858Z",
            "updated":"2023-11-04 13:06:45.145Z",
            "collectionId":"_pb_users_auth_",
            "collectionName":"users",
            "expand":{},
            "avatar":"",
            "email":"hendrik3@test.com",
            "emailVisibility":true,
            "household":"jpjp0avrs60d0sl",
            "name":"Test",
            "username":"username",
            "verified":true
          },
        )
      ]
    },
  );

  final tHouseholdModel = HouseholdModel.fromJSON(tHouseholdRecordModel.data, tHouseholdRecordModel.id, tUsers, tHouseholdRecordModel.expand['admin']!.first.data, tHouseholdRecordModel.expand['admin']!.first.id);

  test('should be an instance of type householdTask', ()  async {
    expect(tHouseholdModel, isA<Household>());
  });

  group('fromJSON', () {
    test('should return HouseholdTaskModel from JSON', () async {
      final result = HouseholdModel.fromJSON(tHouseholdRecordModel.data, tHouseholdRecordModel.id, tUsers, tHouseholdRecordModel.expand['admin']!.first.data, tHouseholdRecordModel.expand['admin']!.first.id);
      expect(result, equals(tHouseholdModel));
    });
  });
}