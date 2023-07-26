import 'package:household_organizer/features/household_task/domain/entities/household_task.dart';

class HouseholdTaskModel extends HouseholdTask {

  HouseholdTaskModel({
    required String id,
    required String title,
    required DateTime? date,
    required bool isDone,
  }) : super (
    id: id,
    title: title,
    date: date,
    isDone: isDone,
  );
   
   
   factory HouseholdTaskModel.fromJSON(Map<String, dynamic> json, String id) {
     String? dueToString = json['due_to'];
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
         isDone: json['isDone']);
   }

}