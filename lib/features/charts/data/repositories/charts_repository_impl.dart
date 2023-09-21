import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/charts/data/datasources/charts_data_source.dart';
import 'package:household_organizer/features/charts/domain/entities/bar_chart_data.dart';
import 'package:household_organizer/features/charts/domain/repositories/charts_repository.dart';

class ChartsRepositoryImpl implements ChartsRepository {

  final ChartsDataSource dataSource;

  ChartsRepositoryImpl({
    required this.dataSource
  });

  @override
  Future<Either<Failure, List<BarChartData>>> getWeeklyBarChartData(String userId) async {
    try {
      final weeklyBarChartData = await dataSource.getWeeklyBarChartData(userId);
      //TODO: sort data so that the current day is the last item

      return Right(weeklyBarChartData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}