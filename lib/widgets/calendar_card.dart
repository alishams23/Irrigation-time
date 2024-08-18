// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:time_sort/main.dart';

class CalendarCard extends StatelessWidget {
  final String fullName;
  final bool status;
  final bool isFirst;
  final int hour;
  final int minute;
  final int duration;
  final bool isOn;

  CalendarCard({
    required this.fullName,
    required this.status,
    required this.isFirst,
    required this.hour,
    required this.minute,
    required this.duration,
    required this.isOn,
  });

  DateTime calculateEndTime(int hour, int minute, int duration) {
    // Get the current date and replace the hour and minute
    DateTime startTime = DateTime.now();
    startTime = DateTime(startTime.year, startTime.month, startTime.day, hour, minute);

    // Add the duration to the start time
    final endTime = startTime.add(Duration(minutes: duration));

    return endTime;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure minute is always two digits
    String formattedMinute = minute.toString().padLeft(2, '0');
    String formattedHour = hour.toString().padLeft(2, '0');
    final myInheritedWidget = MyInheritedWidget.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: status
                  ? Color.fromARGB(255, 18, 93, 32)
                  : isFirst
                      ? Color.fromARGB(255, 57, 76, 1)
                      : Color.fromARGB(255, 43, 42, 42),
              elevation: 4.0,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      fullName,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    !isFirst ? SizedBox(width: 8.0) : Container(),
                    Row(
                      children: [
                        if (isOn == true)
                          Row(
                            children: <Widget>[
                              !isFirst
                                  ? Icon(
                                      Icons.access_time,
                                      size: 13,
                                    )
                                  : Container(),
                              !isFirst ? SizedBox(width: 8.0) : Container(),
                              Text(
                                !isFirst ? '$formattedHour:$formattedMinute:00' : '',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        !isFirst ? SizedBox(width: 15.0) : SizedBox(),
                        Row(
                          children: <Widget>[
                            Icon(Icons.timer, size: 13),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              !isFirst
                                  ? '$duration دقیقه'
                                  : '${calculateEndTime(hour, minute, duration).difference(DateTime.now()).inMinutes} دقیقه باقی مانده',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          status == false
              ? Container(
                  margin: EdgeInsets.only(right: 15, left: 5),
                  width: 3,
                  color: Color.fromARGB(255, 52, 52, 52),
                )
              : Container(
                  height: 18,
                  margin: EdgeInsets.only(right: 9, left: 0),
                  width: 18,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 3, 111, 73), width: 2),
                      borderRadius: BorderRadius.circular(40)),
                ),
        ],
      ),
    );
  }
}
