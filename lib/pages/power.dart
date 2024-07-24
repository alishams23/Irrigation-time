// ignore_for_file: prefer_const_constructors, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors_in_immutables, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PowerPage extends StatefulWidget {
  PowerPage({
    Key? key,
  }) : super(key: key);

  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  @override
  Widget build(BuildContext context) {
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
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(1, 0, 0, 0),
                      Color.fromARGB(39, 189, 2, 2)
                    ]),
                border: Border.all(
                  color: Color.fromARGB(44, 58, 30, 9),
                  width: 20,
                ),
              ),
              child: Center(
                child: Container(
                    width: 200, // Adjust size if necessary
                    height: 200, // Adjust size if necessary
                    decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 205, 56, 7),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(235, 199, 57, 0),
                              Color.fromARGB(239, 111, 1, 1)
                            ]),
                        borderRadius: BorderRadius.circular(100)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: Icon(
                            Icons.power_settings_new_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "چاه خاموش است",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
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
