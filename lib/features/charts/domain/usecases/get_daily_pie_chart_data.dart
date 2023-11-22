import 'package:hmly/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';
import 'package:hmly/features/charts/domain/repositories/charts_repository.dart';

class GetDailyPieChartData {
  final ChartsRepository repository;

  GetDailyPieChartData({
    required this.repository
  });

  Future<Either<Failure, List<PieChartData>>> execute(String userID, String householdID) async {
    return await repository.getDailyPieChartData(userID, householdID);
  }
}