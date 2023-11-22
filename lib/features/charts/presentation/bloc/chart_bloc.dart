
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/charts/domain/entities/bar_chart_data.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';
import 'package:hmly/features/charts/domain/usecases/get_weekly_bar_chart_data.dart';
import 'package:hmly/features/charts/domain/usecases/get_daily_pie_chart_data.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetWeeklyBarChartData getWeeklyBarChartData;
  final GetDailyPieChartData getDailyPieChartData;
  ChartBloc({
    required this.getWeeklyBarChartData,
    required this.getDailyPieChartData
  }) : super(ChartInitial()) {
    on<ChartEvent>((event, emit) async {
      emit(ChartInitial());
      if (event is GetWeeklyChartDataEvent)  {
        emit(ChartLoading(msg: event.msg));
        final barChartResultEither = await getWeeklyBarChartData.execute(event.userID, event.householdID);
        await barChartResultEither.fold(
          (failure) async {
            emit(ChartError(failure: failure));
          },
          (barChartList) async {
            final pieChartResultEither = await getDailyPieChartData.execute(event.userID, event.householdID);
            await pieChartResultEither.fold(
                (failure) async {
                  emit(ChartError(failure: failure));
                },
                (pieChartList) async {
                  emit(ChartLoaded(barChartDataList: barChartList, pieChartDataList: pieChartList));
              }
            );
          }
        );
      }
    });
  }
}
