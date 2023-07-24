class HouseholdTask {
  String id;
  String title;
  DateTime date;
  bool isDone;

  HouseholdTask({
    required this.id,
    required this.title,
    required this.date,
    this.isDone = false
  });

  String getCurrentDate() {
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

