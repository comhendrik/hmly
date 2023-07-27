import 'package:dartz/dartz.dart';
import 'package:household_organizer/core/error/exceptions.dart';
import 'package:household_organizer/core/error/failure.dart';
import 'package:household_organizer/features/household/data/datasources/household_remote_data_source.dart';
import 'package:household_organizer/features/household/domain/entities/household.dart';
import 'package:household_organizer/features/household/domain/repositories/household_repository.dart';

class HouseholdRepositoryImpl implements HouseholdRepository {

  final HouseholdRemoteDataSource remoteDataSource;

  HouseholdRepositoryImpl({
    required this.remoteDataSource
  });

  @override
  Future<Either<Failure, Household>> loadHousehold() async {
    try {
      return Right(await remoteDataSource.loadHousehold());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}