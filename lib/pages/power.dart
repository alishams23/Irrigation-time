// ignore_for_file: prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors_in_immutables, unnecessary_import, non_constant_identifier_names, avoid_print, use_build_context_synchronously, prefer_const_literals_to_create_immutables
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:time_sort/main.dart';
import 'package:time_sort/api/motor_power.dart';
import 'package:time_sort/models/water_well.dart';

class PowerPage extends StatefulWidget {
  PowerPage({
    Key? key,
  }) : super(key: key);

  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  ApiMotorPower apiService = ApiMotorPower();

  bool _isLoading = true; // Loading state

  late WaterWell _motorStatus;

  @override
  void initState() {
    super.initState();
    _getMotorStatus();
  }

  Future<void> _getMotorStatus() async {
    try {
      _motorStatus = await apiService.getStatus();
      setState(() {
        _motorStatus = _motorStatus;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
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

  double _calculateProgress() {
    final DateTime now;
    if (_motorStatus.isOn) {
      now = DateTime.now();
    } else {
      now = DateTime.parse(_motorStatus.offTime).toLocal();
    }
    DateTime startTime = DateTime.parse(_motorStatus.startMember).toLocal();
    final duration = Duration(minutes: _motorStatus.currentMember.time);
    final endTime = startTime.add(duration);

    if (now.isBefore(startTime)) {
      // Not started yet
      return 0.0;
    } else if (now.isAfter(endTime)) {
      // Already finished
      return 1.0;
    } else {
      // Currently in progress
      final elapsed = now.difference(startTime);
      return elapsed.inSeconds / duration.inSeconds;
    }
  }

  DateTime _endTime() {
    DateTime startTime = DateTime.parse(_motorStatus.startMember).toLocal();
    final duration = Duration(minutes: _motorStatus.currentMember.time);
    final endTime = startTime.add(duration);

    return endTime;
  }

  int _remindedTime() {
    final DateTime now;

    if (_motorStatus.isOn) {
      now = DateTime.now();
    } else {
      now = DateTime.parse(_motorStatus.offTime).toLocal();
    }

    DateTime startTime = DateTime.parse(_motorStatus.startMember).toLocal();

    // Set seconds and microseconds to zero for 'startTime'
    startTime = DateTime(startTime.year, startTime.month, startTime.day, startTime.hour, startTime.minute, 0, 0);

    final duration = Duration(minutes: _motorStatus.currentMember.time);

    // Add duration to startTime and ensure endTime also has seconds and microseconds set to zero
    DateTime endTime = startTime.add(duration);
    endTime = DateTime(endTime.year, endTime.month, endTime.day, endTime.hour, endTime.minute, 0, 0);

    int remindedTime = endTime.difference(now).inMinutes;

    if (kDebugMode) {
      print('Start Time: $startTime');
      print('Current Time (Adjusted): $now');
      print('End Time: $endTime');
      print('Reminded Time: $remindedTime minutes');
    }

    return remindedTime;
  }

  int _offTime() {
    final now = DateTime.now();
    DateTime startTime = DateTime.parse(_motorStatus.offTime).toLocal();
    int duration = now.difference(startTime).inMinutes;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    // final myInheritedWidget = MyInheritedWidget.of(context);
    return Scaffold(
      body: Center(
        child: _isLoading == false
            ? ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Container(
                      width: 330, // Adjust size if necessary
                      height: 330, // Adjust size if necessary
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(300),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _motorStatus.isOn
                              ? [Color.fromARGB(39, 79, 95, 1), Color.fromARGB(39, 79, 95, 1)]
                              : [Color.fromARGB(39, 189, 2, 2), Color.fromARGB(39, 189, 2, 2)],
                        ),
                        border: Border.all(
                          color: Color.fromARGB(44, 0, 0, 0),
                          width: 35,
                        ),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            // if (_isLoading == false && _motorStatus.isAdmin) {
                            //   setState(() {
                            //     _isLoading = true;
                            //   });

                            //   try {
                            //     if (_motorStatus.isOn) {
                            //       await apiService.turnOff(null);
                            //     } else {
                            //       await apiService.turnOn(null);
                            //     }
                            //     await _getMotorStatus();
                            //   } catch (e) {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         content: Text(
                            //           'مشکلی پیش آمده لطفا دوباره امتحان کنید',
                            //           textDirection: TextDirection.rtl,
                            //         ),
                            //       ),
                            //     );
                            //   } finally {
                            //     setState(() {
                            //       _isLoading = false;
                            //     });
                            //   }

                            //   myInheritedWidget!.updateData(_motorStatus.isOn);
                            // }
                          },
                          child: Container(
                            width: 200, // Adjust size if necessary
                            height: 200, // Adjust size if necessary
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: _motorStatus.isOn
                                          ? Color.fromARGB(255, 127, 154, 16)
                                          : const Color.fromARGB(255, 144, 35, 27),
                                      width: 1)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: _motorStatus.isOn
                                    ? [Color.fromARGB(235, 57, 76, 1), Color.fromARGB(235, 57, 76, 1)]
                                    : [Color.fromARGB(239, 111, 1, 1), Color.fromARGB(239, 111, 1, 1)],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isLoading
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 20, bottom: 20),
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                        ))
                                    : Padding(
                                        padding: EdgeInsets.only(top: 15, bottom: 10),
                                        child: Icon(
                                          Icons.power_settings_new_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                Text(
                                  _motorStatus.isOn
                                      ? "چاه روشن است"
                                      : "چاه از ${_offTime()} دقیقه پیش  \n خاموش شده است",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(82, 33, 39, 26),
                        borderRadius: BorderRadius.circular(30),
                        border: Border(top: BorderSide(color: Color.fromARGB(255, 39, 44, 38), width: 1))),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _motorStatus.previousMember != null
                                    ? _motorStatus.previousMember!.member.fullName
                                    : 'نامشخص',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "نفر قبل  :  ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  fontSize: 17,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(82, 56, 86, 17),
                              borderRadius: BorderRadius.circular(20),
                              border: Border(top: BorderSide(color: Color.fromARGB(255, 55, 73, 37), width: 1))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _motorStatus.currentMember.member.fullName,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    "نوبت آقای :  ",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 4, top: 13),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    value: _calculateProgress(),
                                    backgroundColor: const Color.fromARGB(255, 9, 32, 11),
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_remindedTime()} دقیقه باقی مانده ',
                                      textDirection: TextDirection.rtl,
                                    ),
                                    _motorStatus.isOn
                                        ? Text(
                                            "${_endTime().hour.toString().padLeft(2, '0')}:${_endTime().minute.toString().padLeft(2, '0')}:00 تا")
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _motorStatus.nextMember.member.fullName,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "نفر بعد  :  ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 194, 194, 194),
                                  fontSize: 17,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(bottom: 56.0))
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
      ),
    );
  }
}
