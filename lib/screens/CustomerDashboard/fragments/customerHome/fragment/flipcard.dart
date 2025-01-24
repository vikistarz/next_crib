import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/logIn/ui/logIn.dart';
class FlipCardPage extends StatefulWidget {
  const FlipCardPage({super.key});

  @override
  State<FlipCardPage> createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {

  ScrollController controller = ScrollController();
  double topContainer = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {

      double value = controller.offset/150;
      setState(() {
        topContainer = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
           Container(
              height: 500.0,
              margin: EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.vertical,
                itemCount: 20,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  double scale = 1.0;

                  if(topContainer > 0.5){
                    scale = index + 0.5 - topContainer;
                    if(scale < 0){
                      scale = 0;
                    }
                    else if(scale > 1){
                      scale = 1;
                    }
                  }
                  return GestureDetector(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                      //   return LogInPage();
                      // }));
                    },
                    child: Opacity(
                      opacity: scale,
                      child: Transform(
                        transform: Matrix4.identity()..scale(scale, scale),
                        alignment: Alignment.topCenter,
                        child: Align(
                          heightFactor: 0.7,
                          alignment: Alignment.topCenter,
                          child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.0,
                                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                                      ]
                                  ),
                                    child: Container(
                                      margin: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(18.0),
                                          image: DecorationImage(image: AssetImage("images/house_image.png"),fit: BoxFit.fill)
                                      ),
                                    ),
                                  ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 80.0, left: 30.0),
                                      child: Text("₦850,000,00", style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                                      child: Text("3 BHK Apartment", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                                          child: Text("Lagos Nigeria", style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                                          ),
                                        ),

                                        Expanded(
                                            child: SizedBox(),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Icon(Icons.star, color: HexColor("#FFB400"), size: 16.0 ,),
                                        ),

                                       Padding(
                                         padding: const EdgeInsets.only(right:30.0),
                                         child: Text("4.5", style: TextStyle(color: Colors.white, fontSize: 14.0),),
                                         ),
                                      ],
                                    )
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
