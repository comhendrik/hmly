import 'package:pocketbase/pocketbase.dart';

void deleteUserFromHousehold(RecordService userRecordService, String userID) async {
  final body = <String, dynamic>{
    "household" : ""
  };
  final _ = await userRecordService.update(userID, body: body);
}