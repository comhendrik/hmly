class Tasks {
  String id;
  String title;
  DateTime date;
  bool isDone;

  Tasks({
    required this.id,
    required this.title,
    required this.date,
    this.isDone = false
  });

  static List<Tasks> getTasks() {
    return [
      Tasks(id: '0', title: 'Waschen', date: DateTime(2023, 1,11)),
      Tasks(id: '1', title: 'Fugen', date: DateTime(2023, 5,3)),
      Tasks(id: '2', title: 'Fugen', date: DateTime(2023,5,4)),
      Tasks(id: '3', title: 'Fugen', date: DateTime(2023,5,7)),
      Tasks(id: '4', title: 'Fugen', date: DateTime(2023,12,31)),
      Tasks(id: '5', title: 'Waschen', date: DateTime(2023,12,45))
    ];
  }

}

List<Tasks> getNumberOfTasks(List<Tasks> list, int number) {
  if (list.length >= number) {
    return list.take(number).toList();
  }
  return list;
}

String getCurrentDate(DateTime date) {
  var currentDate = date.toString();

  var dateParse = DateTime.parse(currentDate);

  var formattedDate = "${dateParse.day}.${dateParse.month}.${dateParse.year}";

  return formattedDate;
}