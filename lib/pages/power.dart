// ignore_for_file: prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors_in_immutables, unnecessary_import, non_constant_identifier_names, avoid_print, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_sort/main.dart';
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

  @override
  Widget build(BuildContext context) {
    final myInheritedWidget = MyInheritedWidget.of(context);
    return Scaffold(
      body: Center(
        child: _isLoading == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300, // Adjust size if necessary
                    height: 300, // Adjust size if necessary
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _motorStatus.isOn
                            ? [
                                Color.fromARGB(1, 0, 0, 0),
                                Color.fromARGB(39, 2, 189, 71)
                              ]
                            : [
                                Color.fromARGB(1, 0, 0, 0),
                                Color.fromARGB(39, 189, 2, 2)
                              ],
                      ),
                      border: Border.all(
                        color: Color.fromARGB(44, 58, 30, 9),
                        width: 20,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (_isLoading == false && _motorStatus.isAdmin) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Simulate API call delay
                            // await Future.delayed(Duration(seconds: 2));
                            // setState(() {
                            //   _is_on = !_is_on;
                            //   _isLoading = false;
                            // });
                            await _getMotorStatus();

                            // print('API ${await apiService.turnOff()}');
                            try {
                              if (_motorStatus.isOn) {
                                // await apiService.turnOff();
                                await apiService.turnOff();
                              } else {
                                await apiService.turnOn();
                              }
                              setState(() {
                                _motorStatus.isOn = !_motorStatus.isOn;
                              });
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'مشکلی پیش آمده لطفا دوباره امتحان کنید',
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }

                            myInheritedWidget!.updateData(_motorStatus.isOn);
                          }
                        },
                        child: Container(
                          width: 200, // Adjust size if necessary
                          height: 200, // Adjust size if necessary
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: _motorStatus.isOn
                                  ? [
                                      Color.fromARGB(159, 5, 225, 60),
                                      Color.fromARGB(236, 1, 76, 21)
                                    ]
                                  : [
                                      Color.fromARGB(235, 199, 57, 0),
                                      Color.fromARGB(239, 111, 1, 1)
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoading
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ))
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(top: 15, bottom: 10),
                                      child: Icon(
                                        Icons.power_settings_new_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                              Text(
                                _motorStatus.isOn
                                    ? "چاه روشن است"
                                    : "چاه خاموش است",
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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(82, 38, 57, 57),
                        borderRadius: BorderRadius.circular(25),
                        border: Border(
                            top: BorderSide(
                                color: Color.fromARGB(255, 37, 48, 45),
                                width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _motorStatus.currentMember.member.fullName,
                          style: TextStyle(
                              // color: Color.fromARGB(255, 188, 251, 192),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          "نوبت آقای :  ",
                          style: TextStyle(
                            // color: Color.fromARGB(255, 166, 250, 170),
                            fontSize: 18,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
      ),
    );
  }
}
