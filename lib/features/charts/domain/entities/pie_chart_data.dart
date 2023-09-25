import 'package:equatable/equatable.dart';

class PieChartData extends Equatable {
  final String id;
  final String username;
  final int value;
  final bool isDataOfUser;

  const PieChartData({
    required this.id,
    required this.username,
    required this.value,
    required this.isDataOfUser
  });

  @override
  List<Object> get props => [id, username, value, isDataOfUser];

}