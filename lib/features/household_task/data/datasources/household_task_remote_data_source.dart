import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class HouseholdTaskRemoteDataSource {
  Future<List<HouseholdTask>> getAllTaskForHousehold();
}

class HouseholdTaskRemoteDataSourceImpl implements HouseholdTaskRemoteDataSource {
  final PocketBase pb;
  final String email;
  final String password;
  final String householdId;

  HouseholdTaskRemoteDataSourceImpl({
    required this.pb,
    required this.email,
    required this.password,
    required this.householdId
  });

  @override
  Future<List<HouseholdTaskModel>> getAllTaskForHousehold() async {


    final _ = await pb.collection('users').authWithPassword(email, password);
    try {
      final result = await pb.collection('household').getFullList(filter: 'household=$householdId');
      List<HouseholdTaskModel> householdTaskModelList = [];
      for (final task in result) {
        householdTaskModelList.add(HouseholdTaskModel.fromJSON(task.data));
      }
      return householdTaskModelList;
    } catch(_) {
      throw ServerException();
    }

  }
}