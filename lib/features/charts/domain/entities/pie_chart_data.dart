import 'package:equatable/equatable.dart';

class PieChartData extends Equatable {
  final String username;
  final int value;
  final bool isDataOfUser;

  const PieChartData({
    required this.username,
    required this.value,
    required this.isDataOfUser
  });

  @override
  List<Object> get props => [username, value, isDataOfUser];

}