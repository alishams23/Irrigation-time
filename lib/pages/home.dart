// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_super_parameters, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
// import 'package:flutter_event_calendar/flutter_event_calendar.dart';

// import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
// import 'package:time_sort/widgets/event_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_sort/api/future_farmers.dart';
import 'package:time_sort/models/sorted_member.dart';
import 'package:time_sort/widgets/calendar_card.dart';
// import 'package:time_sort/widgets/event_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiFutureFarmers apiService = ApiFutureFarmers();

  bool _isLoading = true; // Loading state
  String? username;
  List<SortedMember> _membersList = [];

  @override
  void initState() {
    super.initState();
    _getMembers();
  }

  Future<void> _getMembers() async {
    setState(() {
      _isLoading = true; // Start the loading state
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username');

      // Fetch the members
      List<SortedMember> members = await apiService.getFarmers();

      // Update the state with the fetched members
      setState(() {
        _membersList = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (kDebugMode) {
        print(e);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'مشکلی در اتصال به اینترنت پیش آمده',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventCalendar(
        calendarType: CalendarType.JALALI,
        calendarLanguage: 'fa',
        showLoadingForEvent: true,
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
          selectedBackgroundColor: Color.fromARGB(255, 57, 76, 1),
          eventCounterColor: Color.fromARGB(0, 244, 193, 253),
          disabledTextColor: const Color.fromARGB(255, 123, 123, 123),
          unselectedTextColor: Color.fromARGB(255, 209, 209, 209),
          weekDayUnselectedColor: Color.fromARGB(255, 149, 148, 148),
          unselectedBackgroundColor: Color.fromARGB(255, 37, 37, 37),
        ),
        calendarOptions: CalendarOptions(
            viewType: ViewType.DAILY,
            font: "Varzir",
            headerMonthShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
              ),
            ),
            headerMonthShadowColor: Color.fromARGB(0, 0, 0, 0),
            bottomSheetBackColor: Color.fromARGB(255, 0, 0, 0),
            headerMonthBackColor: Color.fromARGB(0, 30, 35, 30)),
        showEvents: false,
        eventOptions: EventOptions(
            showLoadingForEvent: () => _isLoading,
            loadingWidget: () {
              return Center(child: CircularProgressIndicator());
            }),
        events: [
          for (int i = 0; i < _membersList.length; i++)
            Event(
              child: CalendarCard(
                fullName: _membersList[i].member.fullName,
                status: username == _membersList[i].member.username,
                isFirst: i == 0, // This indicates if it's the first element
                hour: _membersList[i].hour!,
                minute: _membersList[i].minute!,
                duration: _membersList[i].time,
                isOn: _membersList[i].isOn!,
                day: _membersList[i].day!,
                month: _membersList[i].month!,
                year: _membersList[i].year!,
              ),
              dateTime: CalendarDateTime(
                year: _membersList[i].year!,
                color: Colors.black,
                month: _membersList[i].month!,
                day: _membersList[i].day!,
                calendarType: CalendarType.JALALI,
              ),
            ),
        ],
      ),
    );
  }
}
