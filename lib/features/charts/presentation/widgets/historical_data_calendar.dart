import 'package:flutter/material.dart';
import 'package:hmly/features/charts/domain/entities/historical_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
          border: TableBorder.all(color: Colors.transparent),
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
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        children: List.generate(7, (index) {
          return Container(
            padding: const EdgeInsets.all(8.0),
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

  //TODO: events nicht als List, da es immer nur einen Eintrag geben wird
  Widget buildDayWidget(int day, List<HistoricalData> events) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: events.isEmpty ? null : BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueGrey,
        ),
        child: Column(
          children: [
            Text(
              day.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 5),
            Column(
              children: events.map((event) {
                return Text(
                  '${event.value}',
                  style: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
          ],
        ),
      )
    );
  }

  String getWeekdayName(int index) {
    final List<String> weekdayNames = [
      AppLocalizations.of(context)!.shortMonday,
      AppLocalizations.of(context)!.shortTuesday,
      AppLocalizations.of(context)!.shortWednesday,
      AppLocalizations.of(context)!.shortThursday,
      AppLocalizations.of(context)!.shortFriday,
      AppLocalizations.of(context)!.shortSaturday,
      AppLocalizations.of(context)!.shortSunday
    ];
    return weekdayNames[index];
  }

  String getMonthName(int month) {
    final List<String> monthNames = [
      AppLocalizations.of(context)!.january,
      AppLocalizations.of(context)!.february,
      AppLocalizations.of(context)!.march,
      AppLocalizations.of(context)!.april,
      AppLocalizations.of(context)!.may,
      AppLocalizations.of(context)!.june,
      AppLocalizations.of(context)!.july,
      AppLocalizations.of(context)!.august,
      AppLocalizations.of(context)!.september,
      AppLocalizations.of(context)!.october,
      AppLocalizations.of(context)!.november,
      AppLocalizations.of(context)!.december,
    ];
    return monthNames[month - 1];
  }
}