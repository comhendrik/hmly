import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/charts/data/datasources/charts_data_source.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/entities/pie_chart_data.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';

class ChartsRepositoryImpl implements ChartsRepository {

  final ChartsDataSource dataSource;

  ChartsRepositoryImpl({
    required this.dataSource
  });

  @override
  Future<Either<Failure, List<BarChartData>>> getWeeklyBarChartData(String userID) async {
    try {
      final weeklyBarChartData = await dataSource.getWeeklyBarChartData(userID);

      int currentDayOfWeek = DateTime.now().weekday;


      for (var i = 6; i >= currentDayOfWeek; i -= 1) {
        weeklyBarChartData.insert(0, weeklyBarChartData[6]);
        weeklyBarChartData.removeLast();
      }

      return Right(weeklyBarChartData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<PieChartData>>> getDailyPieChartData(String userID, String householdID) async {
    try {
      return Right(await dataSource.getDailyPieChartData(userID, householdID));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}