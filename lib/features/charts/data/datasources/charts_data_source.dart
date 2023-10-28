import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/charts/data/models/bar_chart_data_model.dart';
import 'package:household_organizer/features/charts/data/models/pie_chart_data_model.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:household_organizer/core/entities/user.dart';
abstract class ChartsDataSource {
  Future<List<BarChartDataModel>> getWeeklyBarChartData(String userID);
  Future<List<PieChartDataModel>> getDailyPieChartData(String userID, String householdID);
}

class ChartsDataSourceImpl implements ChartsDataSource {
  final RecordService userRecordService;
  final RecordService pointRecordService;
  final RecordService householdRecordService;


  ChartsDataSourceImpl({
    required this.userRecordService,
    required this.pointRecordService,
    required this.householdRecordService
  });

  @override
  Future<List<BarChartDataModel>> getWeeklyBarChartData(String userID) async {
    try {
      final result = await pointRecordService.getFullList(filter: 'user="$userID"', sort: 'day_number');
      List<BarChartDataModel> barCharDataModelList = [];
      for (final day in result) {
        barCharDataModelList.add(BarChartDataModel.fromJSON(day.data, day.id));
      }
      return barCharDataModelList;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<List<PieChartDataModel>> getDailyPieChartData(String userID, String householdID) async {
    try {
      int currentDayOfWeek = DateTime.now().weekday;
      final userResult = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<PieChartDataModel> pieChartDataModelList = [];
      for (final user in userResult) {
        final userPieChartData = await pointRecordService.getFirstListItem('user="${user.id}" && day_number=$currentDayOfWeek');
        pieChartDataModelList.add(PieChartDataModel.fromJSON(userPieChartData.data, userPieChartData.id, userID, user.data['name']));
      }
      return pieChartDataModelList;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }
}