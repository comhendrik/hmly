import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/features/charts/data/models/historical_data_model.dart';
import 'package:hmly/features/charts/data/models/pie_chart_data_model.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class ChartsDataSource {
  Future<List<HistoricalDataModel>> getHistoricalData(String userID);
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
  Future<List<HistoricalDataModel>> getHistoricalData(String userID) async {
    try {
      final result = await pointRecordService.getFullList(filter: 'user="$userID"', sort: 'created');
      List<HistoricalDataModel> historicalDataList = [];
      for (final day in result) {
        historicalDataList.add(HistoricalDataModel(id: day.id, value: day.data["value"], created: DateTime.parse(day.created)));
      }
      return historicalDataList;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<List<PieChartDataModel>> getDailyPieChartData(String userID, String householdID) async {
    try {
      final userResult = await userRecordService.getFullList(filter: 'household="$householdID"');
      List<PieChartDataModel> pieChartDataModelList = [];
      for (final user in userResult) {
        final userPieChartData = await pointRecordService.getFullList(filter: 'user="${user.id}" && created >= "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}" && created < "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day +1}"');

        if (userPieChartData.isEmpty) {
          pieChartDataModelList.add(PieChartDataModel.fromJSON({"value" : 0, "user" : user.id }, userID, user.data['name']));
        } else {
          pieChartDataModelList.add(PieChartDataModel.fromJSON(userPieChartData[0].data, userID, user.data['name']));
        }
      }
      return pieChartDataModelList;
    } on ClientException catch(err) {
      throw ServerException(response: err.response);
    } catch (_) {
      throw UnknownException();
    }

  }
}