import 'package:household_organizer/core/error/failure.dart';
import '../entities/household.dart';
import 'package:dartz/dartz.dart';

abstract class HouseholdRepository {
  Future<Either<Failure, Household>> loadHousehold(String householdId);
}