String createFilterDate(DateTime date) {
  ///Needed because normal date cant be used.
  /// Pocketbase uses the format yyyy-mm-dd, when i use the normal date and the date.month and date.day function without further computation,
  /// I can get a format like this yyyy-m-d, for example on 2024-1-1, so you need to add the 0, to achieve the right format
  final yearString = date.year;
  final monthInt = date.month;
  final dayInt = date.day;
  String monthString = "$monthInt";
  String dayString = "$dayInt";
  if (monthInt < 10) monthString = "0$monthString";
  if (dayInt < 10) dayString = "0$dayString";
  return "$yearString-$monthString-$dayString";
}