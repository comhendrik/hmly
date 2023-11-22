import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/charts/data/datasources/charts_data_source.dart';
import 'package:hmly/features/charts/domain/entities/bar_chart_data.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';
import 'package:hmly/features/charts/domain/repositories/charts_repository.dart';

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
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, List<PieChartData>>> getDailyPieChartData(String userID, String householdID) async {
    try {
      return Right(await dataSource.getDailyPieChartData(userID, householdID));
    } on ServerException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.server));
    } on UnknownException catch (e) {
      return Left(Failure(data: e.response, type: FailureType.unknown));
    }
  }
}