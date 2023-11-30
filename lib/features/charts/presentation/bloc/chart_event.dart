part of 'chart_bloc.dart';


abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class GetWeeklyChartDataEvent extends ChartEvent {
  final String userID;
  final String householdID;
  final BuildContext context;
  final String msg;


  GetWeeklyChartDataEvent({
    required this.userID,
    required this.householdID,
    required this.context
  }) : msg = AppLocalizations.of(context)!.getChartDataEvent;
}

class ReloadInitChartEvent extends ChartEvent {}
