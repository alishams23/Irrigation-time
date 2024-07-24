// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_super_parameters, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: EventCalendar(
          calendarType: CalendarType.JALALI,
          calendarLanguage: 'fa',
          headerOptions: HeaderOptions(
              headerTextColor: Colors.white,
              resetDateColor: Colors.white,
              navigationColor: Colors.white,
              calendarIconColor: const Color.fromARGB(255, 68, 62, 62)),
          dayOptions: DayOptions(
            disableFadeEffect: true,
            eventCounterViewType: DayEventCounterViewType.DOT,
            selectedTextColor: Color.fromARGB(255, 255, 255, 255),
            weekDaySelectedColor: const Color.fromARGB(255, 255, 255, 255),
            eventCounterTextColor: Color.fromARGB(0, 250, 250, 250),
            selectedBackgroundColor: Color.fromARGB(255, 2, 168, 24),
            eventCounterColor: Color.fromARGB(0, 244, 193, 253),
            disabledTextColor: const Color.fromARGB(255, 123, 123, 123),
            unselectedTextColor: Color.fromARGB(255, 162, 162, 162),
            weekDayUnselectedColor: Color.fromARGB(255, 149, 148, 148),
            unselectedBackgroundColor: Color.fromARGB(255, 19, 19, 19),
          ),
          calendarOptions: CalendarOptions(
              viewType: ViewType.DAILY,
              font: "Vazir",
              headerMonthShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(0),
                ),
              ),
              headerMonthShadowColor: Color.fromARGB(255, 0, 0, 0),
              bottomSheetBackColor: Colors.black,
              headerMonthBackColor: Color.fromARGB(255, 20, 26, 16)),
          showEvents: false,
          events: [
            Event(
              child: const Text('Laravel Event'),
              dateTime: CalendarDateTime(
                year: 1403,
                color: Colors.black,
                month: 4,
                day: 25,
                calendarType: CalendarType.JALALI,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
