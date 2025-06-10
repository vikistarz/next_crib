
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../CustomerDashboard/ui/CustomerDashboard.dart';
import '../createProperty/createProperty.dart';
import '../agentDashboard/ui/agentDashboard.dart';
import '../database/appPrefHelper.dart';
import '../database/saveValues.dart';
import '../logIn/ui/logIn.dart';



class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {


  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      'text1': 'Find your Dream Home',
      'text2': '',
      'text3': 'Schedule Inspection of property in just few clicks',
    },
    {

      'text1': 'Your dream home is',
      'text2': 'just a key away!',
      'text3': 'Let’s find it together',
    },
    {
      'text1': 'Find the space that',
      'text2': 'fits your life.',
      'text3': 'Your new beginnings start here',
    },
  ];

  void _nextPage() {
    if (_currentPage < slides.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: HexColor("#212529"),
      ),
       body: Stack(
         children:[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/slider_background.png",), fit: BoxFit.fitWidth),
            ),
          ),

           Align(
             alignment: Alignment.bottomCenter,
             child: Container(
               height: 220.0,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),
                     topRight: Radius.circular(5.0)),
               ),
               child: Column(
                 children: [
                   Container(
                     height: 5.0,
                     width: 75.0,
                     margin: EdgeInsets.only(top: 15.0),
                     decoration: BoxDecoration(
                       color: HexColor("#D9D9D9"),
                       borderRadius: BorderRadius.all(Radius.circular(1.5)),
                     ),
                   ),


                       Expanded(
                        child: PageView.builder(
                         controller: _pageController,
                         itemCount: slides.length,
                          itemBuilder: (context, index) {
                            final slide = slides[index];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slide['text1']!,
                                  style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold, color: HexColor("00B578")),
                                ),

                                Text(
                                  slide['text2']!,
                                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: HexColor("00B578")),
                                ),

                                Text(
                                  slide['text3']!,
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.normal, color: HexColor("2D2C2C")),
                                ),
                              ],
                            );
                           },
                          ),
                       ),

                   SmoothPageIndicator(
                     controller: _pageController,
                     count: slides.length,
                     effect: WormEffect(
                       dotColor: HexColor("D9D9D9"),
                       activeDotColor: HexColor("00B578"),
                       dotHeight: 7.5,
                       dotWidth: 7.5,
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 20.0),
                     child: Center(
                       child: ElevatedButton(onPressed: () {
                         _nextPage();
                       },
                         child: Text(_currentPage == slides.length - 1 ? "Get Started" : "Next", style: TextStyle(fontSize: 17.0)),
                         style: ElevatedButton.styleFrom(
                           foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                           minimumSize: Size(MediaQuery.of(context).size.width, 45.0),
                           // fixedSize: Size(300.0, 50.0),
                           textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                           elevation: 2,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),
                                 topRight: Radius.circular(15.0),
                                 bottomRight: Radius.circular(15.0),
                                 bottomLeft: Radius.circular(15.0)),
                           ),
                           // side: BorderSide(color: Colors.black, width: 2),
                           // alignment: Alignment.topCenter
                         ),
                       ),
                     ),
                   ),

                 ],
               ),
             ),
           )

           ],
         ),
    );
  }
}

