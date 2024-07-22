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
                border: Border.all(
                  color: Color.fromARGB(255, 58, 43, 9),
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Container(
                  width: 200, // Adjust size if necessary
                  height: 200, // Adjust size if necessary
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 128, 46, 46),
                      borderRadius: BorderRadius.circular(100)),
                  child:const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 15,bottom: 10),
                       child: Icon(
                                       Icons.power_settings_new_rounded,
                                       size: 50,
                                       color: Colors.white,
                                     ),
                     ),
                    Text("چاه خاموش است",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            
                  ],)
                ),
              ),
            ),
          
          Container(
              padding:EdgeInsets.symmetric(vertical: 20,horizontal: 60),
              margin:EdgeInsets.symmetric(vertical: 20,horizontal: 20),

            decoration: BoxDecoration(
              color:Color.fromARGB(255, 62, 48, 8),
               borderRadius: BorderRadius.circular(10)
               
              
            ),
            child:const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("محمدیان",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),Text("نوبت آقای :  ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),],
            ),
          ),
           Container(
              padding:EdgeInsets.symmetric(vertical: 10,horizontal: 60),
              margin:EdgeInsets.symmetric(vertical: 0,horizontal: 30),

            decoration: BoxDecoration(
              color:const Color.fromARGB(255, 41, 31, 1),
               borderRadius: BorderRadius.circular(10)
               
              
            ),
            child:const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("محمدیان",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),Text("نفر بعد  :  ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),],
            ),
          )
          ],
        ),
      ),
    );
  }
}
