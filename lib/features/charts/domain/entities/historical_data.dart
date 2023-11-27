import 'package:equatable/equatable.dart';

class HistoricalData extends Equatable {
  final String id;
  final int value;
  final DateTime created;

  const HistoricalData({
    required this.id,
    required this.value,
    required this.created
  });


  @override
  List<Object> get props => [id, value, created];

}