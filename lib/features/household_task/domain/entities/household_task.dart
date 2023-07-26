class HouseholdTask {
  String id;
  String title;
  DateTime? date;
  bool isDone;

  HouseholdTask({
    required this.id,
    required this.title,
    this.date,
    required this.isDone
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

}

  List<HouseholdTask> getSpecificNumberOfTasks(List<HouseholdTask> list, int number) {
    if (list.length >= number) {
      return list.take(number).toList();
    }
    return list;
  }

