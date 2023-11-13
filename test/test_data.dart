import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';


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
      "username":"Mara",
      "verified":true
    }
    },
    "admin":"wsjo0uutd3jgb67",
    "title":"Test "
  },
  expand: {"admin": [RecordModel(
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

final tUserRecordModel = RecordModel(
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
);

final List<User> tUsers = [User.fromJSON(tUserRecordModel.data, tUserRecordModel.id)];

final List<UserModel> tUserModels = [UserModel.fromJSON(tUserRecordModel.data, tUserRecordModel.id)];


final tHouseholdModel = HouseholdModel.fromJSON(tHouseholdRecordModel.data, tHouseholdRecordModel.id, tUsers, tHouseholdRecordModel.expand['admin']!.first.data, tHouseholdRecordModel.expand['admin']!.first.id);

final Household tHousehold = tHouseholdModel;

final tFailureTypeServerResponseStructure = {
  //This structure is not the real structure from the server
  "message" : "Failure message",
  "code" : 200
};

final tFailureTypeUnknownResponseStructure = {
  //This structure is not the real structure from the server
  "message" : "The Failure is based on some unknown error. Please explain your failure in detail and send it to our support.",
};

final Failure tServerFailure = Failure(data: tFailureTypeServerResponseStructure, type: FailureType.server);

final Failure tUnknownFailure = Failure(data: tFailureTypeUnknownResponseStructure, type: FailureType.unknown);