import 'package:household_organizer/features/charts/domain/entities/pie_chart_data.dart';

class PieChartDataModel extends PieChartData {

  const PieChartDataModel({
    required String id,
    required String username,
    required int value,
    required bool isDataOfUser,
  }) : super (
    id: id,
    username: username,
    value: value,
    isDataOfUser: isDataOfUser,
  );


  factory PieChartDataModel.fromJSON(Map<String, dynamic> json, String id, String userId, String username) {
    return PieChartDataModel(
      id: id,
      username: username,
      value: json['value'],
      isDataOfUser: userId == json['user'],
    );

  }

}