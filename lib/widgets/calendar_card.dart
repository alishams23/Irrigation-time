// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final String fullName;
  final bool status;
  final bool isFirst;
  final int hour;
  final int minute;
  final int duration;

  CalendarCard({
    required this.fullName,
    required this.status,
    required this.isFirst,
    required this.hour,
    required this.minute,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure minute is always two digits
    String formattedMinute = minute.toString().padLeft(2, '0');
    String formattedHour = hour.toString().padLeft(2, '0');

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: status
                  ? Color.fromARGB(255, 3, 111, 73)
                  : isFirst
                      ? Color.fromARGB(170, 3, 111, 107)
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
                        fontSize: 20.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 13,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '$formattedHour:$formattedMinute:00',
                              style: TextStyle(
                                fontSize: 17.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15.0),
                        Row(
                          children: <Widget>[
                            Icon(Icons.timer, size: 13),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              '$duration',
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
                  margin: EdgeInsets.only(right: 5, left: 10),
                  width: 4,
                  color: Color.fromARGB(255, 52, 52, 52),
                )
              : Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 3, 111, 73), width: 2),
                      borderRadius: BorderRadius.circular(40)),
                ),
        ],
      ),
    );
  }
}
