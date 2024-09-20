import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/core/error/exceptions.dart';
import 'package:hmly/features/charts/data/models/historical_data_model.dart';
import 'package:hmly/features/charts/data/models/pie_chart_data_model.dart';

import '../../../../core/entities/user.dart';

abstract class ChartsDataSource {
  Future<List<HistoricalDataModel>> getHistoricalData(UserData user);
  Future<List<PieChartDataModel>> getDailyPieChartData(String userID, String householdID);
}

class ChartsDataSourceImpl implements ChartsDataSource {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  ChartsDataSourceImpl();

  @override
  Future<List<HistoricalDataModel>> getHistoricalData(UserData user) async {
    try {
      final result = await firestore.collection("households").doc(user.householdID).collection("tasks").where("doneBy", isEqualTo: user.id).get();
      List<HistoricalDataModel> historicalDataList = [];
      for (final day in result.docs) {
        final created = day.data()["doneAt"] as Timestamp;
        historicalDataList.add(HistoricalDataModel(
            id: day.id,
            value: day.data()["pointsWorth"] ?? 0,
            created: created.toDate())
        );
      }
      return historicalDataList;
    } on FirebaseException catch(err) {
      throw ServerException(response: {"message" : err.message });
    } catch (_) {
      throw UnknownException();
    }

  }

  @override
  Future<List<PieChartDataModel>> getDailyPieChartData(String userID, String householdID) async {
    try {
      final householdRef = firestore.collection("households").doc(householdID);
      final userResult = await firestore.collection("users").where("household", isEqualTo: householdRef).get();

      List<PieChartDataModel> pieChartDataModelList = [];
      //Filter creation
      // Get the start and end of today
      DateTime now = DateTime.now();
      DateTime startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0);
      DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Convert DateTime to Firestore Timestamps
      Timestamp startTimestamp = Timestamp.fromDate(startOfToday);
      Timestamp endTimestamp = Timestamp.fromDate(endOfToday);

      for (final user in userResult.docs) {
        final userPieChartData = await householdRef.collection("tasks")
            .where('doneAt', isGreaterThanOrEqualTo: startTimestamp)
            .where('doneAt', isLessThanOrEqualTo: endTimestamp).get();
        if (userPieChartData.docs.isEmpty) {
          pieChartDataModelList.add(
              PieChartDataModel.fromJSON(
                  {"value" : 0, "user" : user.id },
                  userID, user.data()['name']
              ));
        } else {
          num sum = 0;
          for(final data in userPieChartData.docs) {
            sum += data.data()["pointsWorth"] ?? 0;
          }
          pieChartDataModelList.add(
              PieChartDataModel.fromJSON(
                  {"value" : sum.toInt(), "user" : user.id },
                  userID, user.data()['name']
              ));
        }
      }
      return pieChartDataModelList;
    } on FirebaseException catch(err) {
      throw ServerException(response: {"message" : err.message });
    } catch (_) {
      throw UnknownException();
    }

  }
}