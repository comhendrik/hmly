import 'package:household_organizer/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:household_organizer/features/charts/domain/entities/pie_chart_data.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';

class GetDailyPieChartData {
  final ChartsRepository repository;

  GetDailyPieChartData({
    required this.repository
  });

  Future<Either<Failure, List<PieChartData>>> execute(String userId, String householdId) async {
    return await repository.getDailyPieChartData(userId, householdId);
  }
}