
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/logIn/ui/logIn.dart';


class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#212529"),
      appBar: AppBar(
        toolbarHeight: 10.0,
        backgroundColor: HexColor("#212529"),
      ),
       body: Column(
         children:[

           Align(
               alignment: Alignment.bottomCenter ,
             child: Container(
               height: 80.0,
               decoration: BoxDecoration(
                 color: HexColor("#212529")
               ),
               child: Align(
                   alignment: Alignment.bottomRight,
                       child: InkWell(
                         onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context){
                         return LogInPage();
                       }));
                         },
                         child: Container(
                           height: 50.0,
                           width: 115.0,
                           margin: EdgeInsets.only(top: 10.0, right: 25.0, bottom: 20.0),
                           decoration: BoxDecoration(
                             color: HexColor("#5E60CE"),
                             borderRadius: BorderRadius.all(Radius.circular(5.0)),
                             ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                         Text("Get Started", style: TextStyle(color: Colors.white, fontSize: 11.0),),
                         Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 20.0,)
                         ]
                           ),
                         ),
                       ),
                       ),
               ),
             ),
           ],
         ),
    );
  }
}

