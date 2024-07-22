import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:time_sort/api/sms.dart';
import 'package:time_sort/pages/home.dart';
import 'package:time_sort/pages/login.dart';
import 'package:time_sort/pages/power.dart';

  // ApiServiceSms apiService = ApiServiceSms();
// final Telephony telephony = Telephony.instance;

backgroundMessageHandler(SmsMessage message) async {
      // await apiService.fetchPosts();
}



void main() {
  runApp( MainPage());
}

class MainPage extends StatefulWidget {


  MainPage({Key? key, })
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

 void Check() async{
    // print("_______________");

    // final permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    // print(permissionsGranted);

  }
 @override
  void initState() {
    // TODO: implement initState
    Check();
  //     telephony.listenIncomingSms(
	// 	onNewMessage: (SmsMessage message) {
  //      apiService.fetchPosts();
  //      print("444444");

	// 		// Handle message
  //     print("____________");
  //     print("1");
	// 	},
	// 	onBackgroundMessage: backgroundMessageHandler
	// );
    super.initState();

 

  }

  // This widget is the root of your application.
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
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark, 
      
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedPageIndex = 0;
  List pages =[PowerPage(),HomePage(),];



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
      bottomNavigationBar:NavigationBar(
        selectedIndex: selectedPageIndex,
  
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
               NavigationDestination(
              selectedIcon: Icon(Icons.electric_meter,),
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
          children: [Text('سامانه ی میرآب',textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)],),
      ),
      body:PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            selectedPageIndex = page;
          
          });
        },
        // controller: controller,
        itemBuilder: (context, position) {
          return  pages[selectedPageIndex];

        }
        ),
    );
  }
}
