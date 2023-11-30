part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class GetWeeklyChartDataEvent extends ChartEvent {
  final String userID;
  final String householdID;
  final String msg = "Weekly Data is fetched";

  const GetWeeklyChartDataEvent({
    required this.userID, required this.householdID
  });
}

class LogoutChartEvent extends ChartEvent {}
