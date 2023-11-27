import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';

class PieChartDataModel extends PieChartData {

  const PieChartDataModel({
    required String username,
    required int value,
    required bool isDataOfUser,
  }) : super (
    username: username,
    value: value,
    isDataOfUser: isDataOfUser,
  );


  factory PieChartDataModel.fromJSON(Map<String, dynamic> json, String userID, String username) {
    return PieChartDataModel(
      username: username,
      value: json['value'],
      isDataOfUser: userID == json['user'],
    );

  }

}