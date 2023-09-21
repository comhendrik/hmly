part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class GetWeeklyChartDataEvent extends ChartEvent {
  final String userId;
  final String householdId;

  const GetWeeklyChartDataEvent({
    required this.userId, required this.householdId
  });
}
