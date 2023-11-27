import 'package:flutter/material.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';


class HistoricalDataCalendar extends StatefulWidget {
  final List<HistoricalData> data;

  const HistoricalDataCalendar({
    super.key,
    required this.data,
  });

  @override
  State<HistoricalDataCalendar> createState() => _HistoricalDataCalendarState();
}

class _HistoricalDataCalendarState extends State<HistoricalDataCalendar> {
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  currentDate = DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
                });
              },
            ),
            Text(
              '${getMonthName(currentDate.month)} ${currentDate.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          children: buildTableRows(),
        ),
      ],
    );
  }

  List<TableRow> buildTableRows() {
    List<TableRow> rows = [];

    // Header row
    rows.add(
      TableRow(
        children: List.generate(7, (index) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue,
            child: Center(
              child: Text(
                getWeekdayName(index),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }),
      ),
    );

    // Calendar days rows
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;

    for (int i = 0; i < 6; i++) {
      List<Widget> dayWidgets = [];

      for (int j = 0; j < 7; j++) {
        int dayNumber = i * 7 + j + 1 - firstDayOfMonth.weekday;
        DateTime currentDay = DateTime(currentDate.year, currentDate.month, dayNumber);

        if (dayNumber > 0 && dayNumber <= daysInMonth) {
          List<HistoricalData> eventsOnDay = getDataOnDay(currentDay);
          dayWidgets.add(
            buildDayWidget(currentDay.day, eventsOnDay),
          );
        } else {
          dayWidgets.add(Container());
        }
      }

      rows.add(
        TableRow(
          children: dayWidgets,
        ),
      );
    }

    return rows;
  }

  List<HistoricalData> getDataOnDay(DateTime day) {
    return widget.data.where((event) =>
    event.created.year == day.year &&
        event.created.month == day.month &&
        event.created.day == day.day).toList();
  }

  Widget buildDayWidget(int day, List<HistoricalData> events) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            day.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Column(
            children: events.map((event) {
              return Text(
                '${event.value}',
                style: const TextStyle(color: Colors.blue),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String getWeekdayName(int index) {
    const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdayNames[index];
  }

  String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }
}