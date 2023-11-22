import 'package:hmly/features/charts/domain/entities/bar_chart_data.dart';

class BarChartDataModel extends BarChartData {

  const BarChartDataModel({
    required String id,
    required String day,
    required int value,
  }) : super (
      id: id,
      day: day,
      value: value,
  );


  factory BarChartDataModel.fromJSON(Map<String, dynamic> json, String id) {
    return BarChartDataModel(
        id: id,
        day: json['day'],
        value: json['value'],
    );
  }

}