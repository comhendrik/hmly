import 'package:hmly/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';

abstract class ChartsRepository {
  Future<Either<Failure, List<HistoricalData>>> getHistoricalData(String userID);
  Future<Either<Failure, List<PieChartData>>> getDailyPieChartData(String userID, String householdID);
}