
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/usecases/get_weekly_chart_data.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetWeeklyBarChartData getWeeklyChartData;
  ChartBloc({
    required this.getWeeklyChartData
  }) : super(ChartInitial()) {
    on<ChartEvent>((event, emit) async {
      emit(ChartInitial());
      if (event is GetWeeklyChartDataEvent)  {
        emit(ChartLoading());
        final resultEither = await getWeeklyChartData.execute(event.userId, event.householdId);
        resultEither.fold(
                (failure) async {
              emit(const ChartError(errorMsg: 'Server Failure'));
            },
                (list) {
              emit(ChartLoaded(barChartDataList: list));
            }
        );
      }
    });
  }
}
