import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/logIn/ui/logIn.dart';
import 'package:next_crib/screens/signUp/signUp.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class AgentSliderPage extends StatefulWidget {
  const AgentSliderPage({super.key});

  @override
  State<AgentSliderPage> createState() => _AgentSliderPageState();
}

class _AgentSliderPageState extends State<AgentSliderPage> {

  final PageController _pageController = PageController();
  final List<Map<String, String>> slides = [
    {
      'img': 'images/slider_image_one.png',
      'textBold1': 'Sell Faster, Close ',
      'textBold2': 'Smarter!',
      'text1': 'Take your real estate business to the next',
      'text2': 'level with Next Crib! List properties, connect',
      'text3': 'with buyers and renters, and close deals faster.',
    },
    {
      'img': 'images/slider_image_two.png',
      'textBold1': 'More Leads, Less ',
      'textBold2': 'Hassle!',
      'text1': 'Your real estate success starts here! Next',
      'text2': 'Crib is built for agents who want to work',
      'text3': 'smarter, not harder.',
    },
    {
      'img': 'images/slider_image_three.png',
      'textBold1': 'Track, Manage,',
      'textBold2': 'Succeed!',
      'text1': 'Say goodbye to outdated methods! With ',
      'text2': 'Next Crib, you have all the tools you need to',
      'text3': 'list, manage, and sell properties on the go.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
            onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context){
                      return LogInPage();
                  }));
                 },
                 child: Text("Skip",style: TextStyle(color: HexColor("#778087"), fontWeight: FontWeight.bold, fontSize:17.0,),)
              ),
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: slides.length,
              effect: WormEffect(
                dotColor: HexColor("D9D9D9"),
                activeDotColor: HexColor("00B578"),
                dotHeight: 7.5,
                dotWidth: 7.5,
              ),
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                final slide = slides[index];

                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Image(image: AssetImage(slide['img']!),
                        height: 250.0, width: MediaQuery.of(context).size.width,),

                      Text(slide['textBold1']!,
                        style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.normal, color: HexColor("#171F24")),
                      ),

                      Text(
                        slide['textBold2']!,
                        style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.normal, color: HexColor("171F24")),
                      ),

                      Text(slide['text1']!,
                        style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.normal, color: HexColor("#778087")),
                      ),

                      Text(
                        slide['text2']!,
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: HexColor("#778087")),
                      ),

                      Text(
                        slide['text3']!,
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: HexColor("#778087")),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0, bottom: 20.0),
            child: Center(
              child: ElevatedButton(onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SignUpPage();
                  // return const CustomerDashboardPage();
                }));
              },
                child: Text("Get Started", style: TextStyle(fontSize: 17.0),),
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
    );
  }
}
