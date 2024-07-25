// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use, unused_import, use_super_parameters, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:time_sort/api/motor_power.dart';
import 'package:time_sort/pages/home.dart';
import 'package:time_sort/pages/login.dart';
import 'package:time_sort/pages/power.dart';

ApiMotorPower apiService = ApiMotorPower();
final Telephony telephony = Telephony.instance;

backgroundMessageHandler(SmsMessage message) async {
  if (message.body != null && message.body!.contains("خاموش"))
    await apiService.turnOff();
}

void main() {
  runApp(MainPage());
}

class MyInheritedWidget extends InheritedWidget {
  final bool status;
  final dynamic updateData;

  MyInheritedWidget(
      {required this.status, required this.updateData, required Widget child})
      : super(child: child);

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return status != oldWidget.status;
  }
}

class MainPage extends StatefulWidget {
  MainPage({
    Key? key,
  }) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool is_on = true;
  void Check() async {
    final permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    print(permissionsGranted);
  }

  void _updateData(bool newData) {
    setState(() {
      is_on = newData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Check();
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          if (message.body != null && message.body!.contains("خاموش")) {
            apiService.turnOff();

            setState(() {
              is_on = false;
            });
          }

          if (message.body != null && message.body!.contains("روشن")) {
            apiService.turnOff();

            setState(() {
              is_on = true;
            });
          }
        },
        onBackgroundMessage: backgroundMessageHandler);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      status: is_on,
      updateData: _updateData,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: "Vazir",
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 7, 1, 55)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: "Vazir",
          colorSchemeSeed: Color.fromARGB(84, 41, 65, 11),
          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark,

        /* ThemeMode.system to follow system theme, 
           ThemeMode.light for light theme, 
           ThemeMode.dark for dark theme
        */
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      ),
    );
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
  List pages = [
    PowerPage(),
    HomePage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkToken();
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.electric_meter,
            ),
            icon: Icon(Icons.electric_meter_outlined),
            label: 'وضعیت چاه',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.task_rounded),
            icon: Icon(Icons.task_outlined),
            label: 'لیست نوبت',
          ),
        ],
      ),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.

        // backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'سامانه ی میرآب',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )
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
          // controller: controller,
          itemBuilder: (context, position) {
            return pages[selectedPageIndex];
          }),
    );
  }
}
