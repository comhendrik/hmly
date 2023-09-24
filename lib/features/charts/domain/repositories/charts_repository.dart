import 'package:household_organizer/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/entities/pie_chart_data.dart';

abstract class ChartsRepository {
  Future<Either<Failure, List<BarChartData>>> getWeeklyBarChartData(String userId);
  Future<Either<Failure, List<PieChartData>>> getDailyPieChartData(String householdId);
}