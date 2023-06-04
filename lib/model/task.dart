class Task {
  String id;
  String title;
  DateTime date;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.isDone = false
  });

  static List<Task> getTasks() {
    return [
      Task(id: '0', title: 'Waschen', date: DateTime(2023, 1,11)),
      Task(id: '1', title: 'Fugen', date: DateTime(2023, 5,3)),
      Task(id: '2', title: 'Fugen', date: DateTime(2023,5,4)),
      Task(id: '3', title: 'Fugen', date: DateTime(2023,5,7)),
      Task(id: '4', title: 'Fugen', date: DateTime(2023,12,31)),
      Task(id: '5', title: 'Waschen', date: DateTime(2023,12,45))
    ];
  }

}

List<Task> getNumberOfTasks(List<Task> list, int number) {
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