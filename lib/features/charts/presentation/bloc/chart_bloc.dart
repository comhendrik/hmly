
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';
import 'package:hmly/features/charts/domain/usecases/get_historical_data.dart';
import 'package:hmly/features/charts/domain/usecases/get_daily_pie_chart_data.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetHistoricalData getHistoricalData;
  final GetDailyPieChartData getDailyPieChartData;
  ChartBloc({
    required this.getHistoricalData,
    required this.getDailyPieChartData
  }) : super(ChartInitial()) {
    on<ChartEvent>((event, emit) async {
      if (event is GetWeeklyChartDataEvent)  {
        emit(ChartLoading(msg: event.msg));
        final historicalDataResultEither = await getHistoricalData.execute(event.userID);
        await historicalDataResultEither.fold(
              (failure) async {
              emit(ChartError(failure: failure));
            },
            (historicalData) async {
              final pieChartResultEither = await getDailyPieChartData.execute(event.userID, event.householdID);
              await pieChartResultEither.fold(
                      (failure) async {
                    emit(ChartError(failure: failure));
                  },
                      (pieChartList) async {
                    emit(ChartLoaded(pieChartDataList: pieChartList, historicalDataList: historicalData));
                  }
              );
            }
        );
      } else if (event is LogoutChartEvent) {
        emit(ChartInitial());
      }
    });
  }
}
