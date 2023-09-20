import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/charts/data/datasources/charts_remote_data_source.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';

class ChartsRepositoryImpl implements ChartsRepository {

  final ChartsRemoteDataSource remoteDataSource;

  ChartsRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, List<BarChartData>>> getWeeklyBarChartData(String userId) async {
    try {
      return Right(await remoteDataSource.getWeeklyBarChartData(userId));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}