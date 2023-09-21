void main() {
  int currentDayOfWeek = DateTime.now().weekday;

  // Create a list of weekdays as strings
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];


  for (var i = 6; i >= currentDayOfWeek; i -= 1) {
    print(weekdays[6]);
    weekdays.insert(0, weekdays[6]);
    weekdays.removeLast();
  }

  print(weekdays);
}