import 'package:hmly/core/entities/user.dart';
import 'package:hmly/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:hmly/features/charts/domain/repositories/charts_repository.dart';

class GetHistoricalData {
  final ChartsRepository repository;

  GetHistoricalData({
    required this.repository
  });

  Future<Either<Failure, List<HistoricalData>>> execute(UserData user) async {
    return await repository.getHistoricalData(user);
  }
}