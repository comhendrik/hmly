part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();
}

class ChartInitial extends ChartState {
  @override
  List<Object> get props => [];
}

class ChartLoading extends ChartState {
  @override
  List<Object> get props => [];
}

class ChartLoaded extends ChartState {
  final List<BarChartData> barChartDataList;
  final List<PieChartData> pieChartDataList;
  const ChartLoaded({required this.barChartDataList, required this.pieChartDataList});

  @override
  List<Object> get props => [];
}

class ChartError extends ChartState {
  final String errorMsg;
  const ChartError({required this.errorMsg});

  @override
  List<Object> get props => [];
}