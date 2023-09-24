import 'package:equatable/equatable.dart';

class PieChartData extends Equatable {
  final String id;
  final String day;
  final int value;

  const PieChartData({
    required this.id,
    required this.day,
    required this.value
  });


  @override
  List<Object> get props => [id, day, value];

}