import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import '../entities/household.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdRepository {
  Future<Either<Failure, Household>> loadHousehold(String householdId);
  Future<Either<Failure, Household>> updateHouseholdTitle(String householdId, String title);
  Future<Either<Failure, void>> deleteAuthDataFromHousehold(String userID);
}