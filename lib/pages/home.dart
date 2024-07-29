// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_super_parameters, avoid_unnecessary_containers, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
// import 'package:flutter_event_calendar/flutter_event_calendar.dart';




// import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
// import 'package:time_sort/widgets/event_calendar.dart';


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

  late List _membersList;

  @override
  void initState() {
    super.initState();
    _getMembers();
  }

  Future<void> _getMembers() async {
    try {
      _membersList = await apiService.getFarmers();
      setState(() {
        _membersList = _membersList;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
          for (SortedMember item in _membersList)
            Event(
              child: CalendarCard(
                fullName: item.member.fullName,
                hour: item.hour!,
                minute: item.minute!,
                duration: item.time,
              ),
              dateTime: CalendarDateTime(
                year: item.year!,
                color: Colors.black,
                month: item.month!,
                day: item.day!,
                calendarType: CalendarType.JALALI,
              ),
            ),
        ],
      ),
    );
  }
}
