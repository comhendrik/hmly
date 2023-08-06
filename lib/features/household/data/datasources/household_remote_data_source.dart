import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household/data/models/household_model.dart';
import 'package:household_organizer/core/models/user_model.dart';
import 'package:household_organizer/core/entities/user.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class HouseholdRemoteDataSource {
  Future<HouseholdModel> loadHousehold();
}

class HouseholdRemoteDataSourceImpl implements HouseholdRemoteDataSource {
  final RecordService userRecordService;
  final RecordService householdRecordService;
  final String email;
  final String password;
  final String householdId;

  HouseholdRemoteDataSourceImpl({
    required this.userRecordService,
    required this.householdRecordService,
    required this.email,
    required this.password,
    required this.householdId
  });

  @override
  Future<HouseholdModel> loadHousehold() async {
    final _ = await userRecordService.authWithPassword(email, password);
    try {
      final result = await householdRecordService.getOne(householdId);
      final users = await userRecordService.getFullList(filter: 'household="$householdId"');
      List<User> userList = [];
      for (final user in users) {
        final userResult = await userRecordService.getOne(user.id);
        userList.add(UserModel.fromJSON(userResult.data, user.id));
      }
      return HouseholdModel.fromJSON(result.data, result.id, userList);
    } catch(err) {
      throw ServerException();
    }

  }
}