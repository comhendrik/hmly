part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();
}

class ChartInitial extends ChartState {
  @override
  List<Object> get props => [];
}

class ChartLoading extends ChartState {
  final String msg;

  const ChartLoading({required this.msg});
  @override
  List<Object> get props => [msg];
}

class ChartLoaded extends ChartState {
  final List<PieChartData> pieChartDataList;
  final List<HistoricalData> historicalDataList;
  const ChartLoaded({
    required this.pieChartDataList,
    required this.historicalDataList
  });

  @override
  List<Object> get props => [];
}

class ChartError extends ChartState {
  final Failure failure;
  const ChartError({
    required this.failure
  });

  @override
  List<Object> get props => [];
}