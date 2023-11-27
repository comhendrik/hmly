import 'package:equatable/equatable.dart';

class HouseholdTask extends Equatable {
  final String id;
  final String title;
  final DateTime? date;
  final bool isDone;
  final int pointsWorth;
  final String doneBy;//Only need to safe userID

  const HouseholdTask({
    required this.id,
    required this.title,
    required this.date,
    required this.isDone,
    required this.pointsWorth,
    required this.doneBy
  });

  String getCurrentDate() {
    if (date == null) {
      return "no date";
    }
    var currentDate = date.toString();

    var dateParse = DateTime.parse(currentDate);

    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";

    return formattedDate;
  }

  @override
  List<Object> get props => [id, title, date ?? DateTime.now(), isDone, doneBy];

}



