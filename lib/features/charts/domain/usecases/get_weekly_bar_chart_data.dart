import 'package:hmly/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:hmly/features/charts/domain/entities/bar_chart_data.dart';
import 'package:hmly/features/charts/domain/repositories/charts_repository.dart';

class GetWeeklyBarChartData {
  final ChartsRepository repository;

  GetWeeklyBarChartData({
    required this.repository
  });

  Future<Either<Failure, List<BarChartData>>> execute(String userID, String householdID) async {
    return await repository.getWeeklyBarChartData(userID);
  }
}