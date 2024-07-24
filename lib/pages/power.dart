// ignore_for_file: prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors_in_immutables, unnecessary_import, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_sort/main.dart';
import 'package:time_sort/api/sms.dart';

class PowerPage extends StatefulWidget {
  PowerPage({
    Key? key,
  }) : super(key: key);

  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  ApiMotor apiService = ApiMotor();

  bool _is_on = true;
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    final myInheritedWidget = MyInheritedWidget.of(context);
    return Scaffold(
      body: Center(
        child: Column(
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
                  colors: _is_on
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
                    if (_isLoading == false) {
                      setState(() {
                        _isLoading = true;
                      });

                      // Simulate API call delay
                      await Future.delayed(Duration(seconds: 2));
                      setState(() {
                        _is_on = !_is_on;
                        _isLoading = false;
                      });
                      // try {
                      //   if (_is_on) {
                      //     await apiService.turnOff();
                      //   } else {
                      //     await apiService.turnOn();
                      //   }
                      //   setState(() {
                      //     _is_on = !_is_on;
                      //   });
                      // } catch (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //         'مشکلی پیش آمده لطفا دوباره امتحان کنید',
                      //         textDirection: TextDirection.rtl,
                      //       ),
                      //     ),
                      //   );
                      // } finally {
                      //   setState(() {
                      //     _isLoading = false;
                      //   });
                      // }

                      myInheritedWidget!.updateData(_is_on);
                    }
                  },
                  child: Container(
                    width: 200, // Adjust size if necessary
                    height: 200, // Adjust size if necessary
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _is_on
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
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
                          _is_on ? "چاه روشن است" : "چاه خاموش است",
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
                  color: Color.fromARGB(15, 76, 200, 19),
                  borderRadius: BorderRadius.circular(50)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "محمدیان",
                    style: TextStyle(
                        color: Color.fromARGB(255, 166, 250, 170),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    "نوبت آقای :  ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 166, 250, 170),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "محمدیان",
                    style: TextStyle(
                        color: Color.fromARGB(255, 194, 194, 194),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    "نفر بعد  :  ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 194, 194, 194),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
