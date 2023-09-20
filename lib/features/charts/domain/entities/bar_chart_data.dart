import 'package:equatable/equatable.dart';

class BarChartData extends Equatable {
  final String id;
  final String day;
  final int value;

  const BarChartData({
    required this.id,
    required this.day,
    required this.value
  });


  @override
  List<Object> get props => [id, day, value];

}