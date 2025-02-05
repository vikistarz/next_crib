import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/propertyDetail/ui/propertydetail.dart';
import 'package:next_crib/screens/slider/slider.dart';
class FlipsCardPage extends StatefulWidget {
  const FlipsCardPage({super.key});

  @override
  State<FlipsCardPage> createState() => _FlipsCardPageState();
}

class _FlipsCardPageState extends State<FlipsCardPage> {

  bool allSwiped = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: allSwiped
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 180.0),
              Text("No more properties available!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    allSwiped = false;
                  });
                },
                child: Text("Reload Properties"),
              )
            ],
          ),
        )
            : Center(
          child: SizedBox(
            height: 600,
            child: CardSwiper(
              cardsCount: 20,
              numberOfCardsDisplayed: 3, // Show 3 cards instead of 2
              // scale: 0.98, // Adjusts the size of the stacked cards
              // backCardOffset: Offset(0, 25), // Moves the cards slightly apart
              onSwipe: (previousIndex, targetIndex, direction) {
                if (targetIndex == 20 - 1) {
                  setState(() {
                    allSwiped = true;
                  });
                }
                return true;
              },
              cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                return  Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context){
                          //   return SliderPage();
                          // }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 400.0,
                          margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 3.0, right: 3.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withAlpha(100), blurRadius: 10.0),
                              ]
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(image: AssetImage("images/new_house.png"),fit: BoxFit.fill)
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: 400.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                              child: SizedBox(),
                            ),
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
                      ),
                    ]
                );
              },
            ),
          ),
        ),
    );
  }
}
