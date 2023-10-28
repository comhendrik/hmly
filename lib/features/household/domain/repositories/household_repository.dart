import 'package:household_organizer/core/entities/user.dart';
import 'package:household_organizer/core/error/failure.dart';
import '../entities/household.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdRepository {
  Future<Either<Failure, Household>> loadHousehold(String householdID);
  Future<Either<Failure, Household>> updateHouseholdTitle(String householdID, String title);
  Future<Either<Failure, void>> deleteAuthDataFromHousehold(String userID, Household household);
  Future<Either<Failure, Household>> updateAdmin(String householdID, String userID);
}