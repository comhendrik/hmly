import 'package:household_organizer/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';

class GetWeeklyChartData {
  final ChartsRepository repository;

  GetWeeklyChartData({
    required this.repository
  });

  Future<Either<Failure, List<BarChartData>>> execute(String userId, String householdId) async {
    return await repository.getWeeklyBarChartData(userId);
  }
}