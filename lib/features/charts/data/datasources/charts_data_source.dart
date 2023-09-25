import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/features/charts/data/models/bar_chart_data_model.dart';
import 'package:household_organizer/features/charts/data/models/pie_chart_data_model.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/household_task/data/models/household_task_model.dart';
import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:household_organizer/core/entities/user.dart';
abstract class ChartsDataSource {
  Future<List<BarChartDataModel>> getWeeklyBarChartData(String userId);
  Future<List<PieChartDataModel>> getDailyPieChartData(String userId, String householdId);
}

class ChartsDataSourceImpl implements ChartsDataSource {
  final RecordService userRecordService;
  final RecordService pointRecordService;


  ChartsDataSourceImpl({
    required this.userRecordService,
    required this.pointRecordService,
  });

  @override
  Future<List<BarChartDataModel>> getWeeklyBarChartData(String userId) async {
    try {
      final result = await pointRecordService.getFullList(filter: 'user="$userId"', sort: 'day_number');
      List<BarChartDataModel> barCharDataModelList = [];
      for (final day in result) {
        barCharDataModelList.add(BarChartDataModel.fromJSON(day.data, day.id));
      }
      return barCharDataModelList;
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }

  @override
  Future<List<PieChartDataModel>> getDailyPieChartData(String userId, String householdId) async {
    try {
      //TODO: Impleming fetch from pocketbase
      return [PieChartDataModel(id: "id", username: "fasfd", value: 35, isDataOfUser: false),PieChartDataModel(id: "id", username: "fasfd", value: 35, isDataOfUser: true)];
    } catch(err) {
      print(err);
      throw ServerException();
    }

  }
}