import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:time_sort/api/sms.dart';
import 'package:time_sort/pages/home.dart';
import 'package:time_sort/pages/power.dart';

  ApiServiceSms apiService = ApiServiceSms();
final Telephony telephony = Telephony.instance;

backgroundMessageHandler(SmsMessage message) async {
      await apiService.fetchPosts();
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
    print("_______________");

    final permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    print(permissionsGranted);

  }
 @override
  void initState() {
    // TODO: implement initState
    Check();
      telephony.listenIncomingSms(
		onNewMessage: (SmsMessage message) {
       apiService.fetchPosts();
       print("444444");

			// Handle message
      print("____________");
      print("1");
		},
		onBackgroundMessage: backgroundMessageHandler
	);
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
        
colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark, 
      
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'سامانه ی میرآب',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedPageIndex = 0;
  List pages =[PowerPage(),HomePage(),];
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(widget.title,textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)],),
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
