
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';


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
                         // Expanded(
                         //   child: CarouselSlider(items: [
                         //     Container(
                         //           decoration:  BoxDecoration(
                         //             image: DecorationImage(image: AssetImage("images/slider_hammer.jpg"),),
                         //           ),
                         //          // child: Align(
                         //          //   alignment: Alignment.bottomLeft,
                         //          //   child: Padding(
                         //          //     padding: const EdgeInsets.only(left: 20.0, top: 570),
                         //          //  child: Column(
                         //          //      children: [
                         //          //        Text("Connect With", style: TextStyle(color: Colors.white, fontSize: 28.0),),
                         //          //        Text("Service Providers", style: TextStyle(color: Colors.white, fontSize: 28.0),),
                         //          //        Text("Find, Hire and Connect with Service Providers near you....", style: TextStyle(color: Colors.white, fontSize: 10.0),),
                         //          //      ],
                         //          //      ),
                         //          //   ),
                         //          // ),
                         //           ),
                         //
                         //
                         //      Container(
                         //         decoration:  BoxDecoration(
                         //           image: DecorationImage(image: AssetImage("images/slider_house.jpg"),),
                         //         ),
                         //        // child: Align(
                         //        //   alignment: Alignment.bottomLeft,
                         //        //   child: Padding(
                         //        //     padding: const EdgeInsets.only(left: 20.0, top: 570),
                         //        //     child: Column(
                         //        //    children: [
                         //        //    Text("Let Your Voice", style: TextStyle(color: Colors.white, fontSize: 28.0),),
                         //        //    Text("Here even a Mason has a voice. Scale up and", style: TextStyle(color: Colors.white, fontSize: 10.0),),
                         //        //    Text("become that next big thing to happen", style: TextStyle(color: Colors.white, fontSize: 10.0),)
                         //        //    ],
                         //        //   ),
                         //        //    ),
                         //        // ),
                         //       ),
                         //
                         //
                         //      Container(
                         //         decoration:  BoxDecoration(
                         //           image: DecorationImage(image: AssetImage("images/slider_people.jpg"),),
                         //         ),
                         //        // child: Align(
                         //        //   alignment: Alignment.bottomLeft,
                         //        //   child:  Padding(
                         //        //     padding: const EdgeInsets.only(left: 20.0, top: 570),
                         //        //      child: Column(
                         //        //   children: [
                         //        //   Text("Increase Your", style: TextStyle(color: Colors.white, fontSize: 28.0),),
                         //        //   Text("Revenue", style: TextStyle(color: Colors.white, fontSize: 28.0),),
                         //        //   Text("We empower the well-trained Artisan and handymen by providing ", style: TextStyle(color: Colors.white, fontSize: 10.0),),
                         //        //   Text("them with an increased revenue and a larger pool of clients", style: TextStyle(color: Colors.white, fontSize: 10.0),)
                         //        //    ],
                         //        //    ),
                         //        //     ),
                         //        // ),
                         //       ),
                         //   ],
                         //       // slider container properties
                         //       options: CarouselOptions(
                         //         height: MediaQuery.sizeOf(context).height,
                         //
                         //         autoPlay: true,
                         //         aspectRatio: 16/9,
                         //         autoPlayCurve: Curves.fastOutSlowIn,
                         //         enableInfiniteScroll: true,
                         //         viewportFraction: 1,
                         //           autoPlayAnimationDuration: Duration(milliseconds: 800),
                         //       ),
                         //   ),
                         // ),

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

