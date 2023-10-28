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
  final List<BarChartData> barChartDataList;
  final List<PieChartData> pieChartDataList;
  const ChartLoaded({required this.barChartDataList, required this.pieChartDataList});

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