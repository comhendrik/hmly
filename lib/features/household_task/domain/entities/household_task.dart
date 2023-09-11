import 'package:equatable/equatable.dart';

class HouseholdTask extends Equatable {
  final String id;
  final String title;
  final DateTime? date;
  final bool isDone;
  final int pointsWorth;

  const HouseholdTask({
    required this.id,
    required this.title,
    required this.date,
    required this.isDone,
    required this.pointsWorth
  });

  String getCurrentDate() {
    if (date == null) {
      return "no date";
    }
    var currentDate = date.toString();

    var dateParse = DateTime.parse(currentDate);

    var formattedDate = "${dateParse.day}.${dateParse.month}.${dateParse.year}";

    return formattedDate;
  }

  @override
  List<Object> get props => [id, title, date ?? Object(), isDone];

}



