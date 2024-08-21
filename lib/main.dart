// ignore_for_file: use_super_parameters, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, curly_braces_in_flow_control_structures, unused_element, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, non_constant_identifier_names, avoid_print, deprecated_member_use, unnecessary_null_comparison
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:time_sort/api/motor_power.dart';
import 'package:time_sort/pages/drag_group.dart';
import 'package:time_sort/pages/home.dart';
import 'package:time_sort/pages/video.dart';
import 'package:time_sort/pages/login.dart';
import 'package:time_sort/pages/power.dart';
import 'package:time_sort/models/water_well.dart';

ApiMotorPower apiService = ApiMotorPower();
final Telephony telephony = Telephony.instance;

backgroundMessageHandler(SmsMessage message) async {
  if (message.body != null && message.body!.contains("خاموش")) {
    String? id = RegExp(r'(?<=' + RegExp.escape("ورودی") + r'\s*)\d+').firstMatch(message.body!)!.group(0);
    apiService.turnOff(id);
  }

  if (message.body != null && message.body!.contains("روشن")) {
    String? id = RegExp(r'(?<=' + RegExp.escape("ورودی") + r'\s*)\d+').firstMatch(message.body!)!.group(0);

    apiService.turnOn(id);
  }
}

void main() {
  runApp(MainPage());
}

class MyInheritedWidget extends InheritedWidget {
  final bool status;
  final dynamic updateData;

  MyInheritedWidget({this.status = true, required this.updateData, required Widget child}) : super(child: child);

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return status != oldWidget.status;
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "Vazir",
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 7, 1, 55)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Vazir",
        colorSchemeSeed: Color.fromARGB(84, 41, 65, 11),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const MyHomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPageIndex = 0;
  List pages = [PowerPage(), HomePage(), VideosPage()];

  bool is_on = true;

  @override
  void initState() {
    super.initState();
    _checkToken();
    _setupTelephony();
    _getMotorStatus();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void _setupTelephony() {
    telephony.requestPhoneAndSmsPermissions.then((permissionsGranted) {
      if (permissionsGranted != null && permissionsGranted) {
        telephony.listenIncomingSms(
          onNewMessage: (SmsMessage message) {
            if (message.body != null && message.body!.contains("خاموش")) {
              String? id = RegExp(r'(?<=' + RegExp.escape("ورودی") + r'\s*)\d+').firstMatch(message.body!)!.group(0);
              apiService.turnOff(id);
              setState(() {
                is_on = false;
              });
            }

            if (message.body != null && message.body!.contains("روشن")) {
              String? id = RegExp(r'(?<=' + RegExp.escape("ورودی") + r'\s*)\d+').firstMatch(message.body!)!.group(0);

              apiService.turnOn(id);
              setState(() {
                is_on = true;
              });
            }
          },
          onBackgroundMessage: backgroundMessageHandler,
        );
      }
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('خروج از برنامه'),
            content: Text('آیا می‌خواهید از برنامه خارج شوید؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('خیر'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: Text('بله'),
              ),
            ],
          ),
        )) ??
        false;
  }

  ApiMotorPower apiService = ApiMotorPower();

  WaterWell? _motorStatus;
  Future<void> _getMotorStatus() async {
    try {
      _motorStatus = await apiService.getStatus();
      setState(() {
        _motorStatus = _motorStatus;
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
    // Example condition: Hide the FloatingActionButton on the second page
    bool showFab = _motorStatus != null && _motorStatus!.isAdmin && selectedPageIndex != 2;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: showFab
            ? FloatingActionButton(
                onPressed: () {
                  print(selectedPageIndex);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DragGroupPage(),
                    ),
                  );
                },
                child: Icon(Icons.edit),
              )
            : null, // Set to null when you want to hide the button
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.electric_meter),
              icon: Icon(Icons.electric_meter_outlined),
              label: 'وضعیت چاه',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.list_rounded),
              icon: Icon(Icons.list_outlined),
              label: 'لیست نوبت',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.video_library_rounded),
              icon: Icon(Icons.video_library_outlined),
              label: 'نمایشگاه',
            ),
          ],
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'آبیاری هوشمند',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 35, bottom: 35, left: 20, right: 20),
                child: Text(
                  'آبیاری هوشمند',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textDirection: TextDirection.rtl,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(170, 48, 111, 3),
                ),
              ),
              GestureDetector(
                onTap: _logout,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        size: 20,
                      ),
                      Text(
                        'خروج',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              selectedPageIndex = page;
            });
          },
          itemBuilder: (context, position) {
            return pages[selectedPageIndex];
          },
        ),
      ),
    );
  }
}
