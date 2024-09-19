import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmly/features/household_task/domain/entities/household_task.dart';

class HouseholdTaskModel extends HouseholdTask {

  HouseholdTaskModel({
    required String id,
    required String title,
    required DateTime? date,
    required bool isDone,
    required int pointsWorth,
    required String doneBy
  }) : super (
    id: id,
    title: title,
    date: date,
    isDone: isDone,
    pointsWorth: pointsWorth,
    doneBy: doneBy
  );


  factory HouseholdTaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    return HouseholdTaskModel(
        id: snap.id,
        title: snap.data()?["title"] ?? "no title",
        date: snap.data()?["date"] ?? DateTime.now(),
        isDone: snap.data()?["isDone"] ?? false,
        pointsWorth: snap.data()?["pointsWorth"] ?? 0,
        doneBy: snap.data()?["doneBy"]?.id ?? ""
    );
  }
   
   factory HouseholdTaskModel.fromJSON(Map<String, dynamic> json, String id) {
     String? dueToString = json['dueTo'];
     DateTime? dueTo;
     if (dueToString == "") {
       dueTo = null;
     } else {
       dueTo = DateTime.tryParse(dueToString!);
     }
     return HouseholdTaskModel(
       id: id,
       title: json['title'],
       date: dueTo,
       isDone: json['isDone'],
       pointsWorth: json['pointsWorth'],
       doneBy: json['doneBy'] ?? ""
     );
   }

}