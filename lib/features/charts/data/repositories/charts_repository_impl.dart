import 'package:dartz/dartz.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:hmly/features/charts/data/datasources/charts_data_source.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:hmly/features/charts/domain/entities/pie_chart_data.dart';
import 'package:hmly/features/charts/domain/repositories/charts_repository.dart';

class ChartsRepositoryImpl implements ChartsRepository {

  final ChartsDataSource dataSource;

  ChartsRepositoryImpl({
    required this.dataSource
  });

  @override
  Future<Either<Failure, List<HistoricalData>>> getHistoricalData(String userID) async {
    try {
      return Right(await dataSource.getHistoricalData(userID));
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