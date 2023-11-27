import 'package:hmly/features/charts/domain/entities/historical_data.dart';

class HistoricalDataModel extends HistoricalData {

  const HistoricalDataModel({
    required String id,
    required int value,
    required DateTime created,
  }) : super (
      id: id,
      value: value,
      created: created
  );


  factory HistoricalDataModel.fromJSON(Map<String, dynamic> json, String id) {
    return HistoricalDataModel(
        id: id,
        value: json["value"],
        created: DateTime.parse(json["created"])
    );
  }

}