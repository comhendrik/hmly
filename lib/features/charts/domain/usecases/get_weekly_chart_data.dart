import 'package:household_organizer/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';

class GetWeeklyChartData {
  final ChartsRepository repository;

  GetWeeklyChartData({
    required this.repository
  });

  Future<Either<Failure, void>> execute(String userId, String householdId) async {
    //TODO: fetch data for bar and pie chart at the same time
    return await repository.getWeeklyBarChartData(userId);
  }
}