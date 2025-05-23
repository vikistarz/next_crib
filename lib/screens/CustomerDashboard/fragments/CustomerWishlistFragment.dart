import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class CustomerWishlistFragment extends StatefulWidget {
  const CustomerWishlistFragment({super.key});

  @override
  State<CustomerWishlistFragment> createState() => _CustomerWishlistFragmentState();
}

class _CustomerWishlistFragmentState extends State<CustomerWishlistFragment> {

  bool isAllVisible =  true;
  bool isTopVisible = true;
  bool isBestVisible = true;
  bool isMostVisible = true;
  // most

  Future<void> _refresh() async {
    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    // Add a new item to the list after refreshing
    setState(() {
      // fetchUserData(customerId!);
      // items.add("Item ${items.length + 1}");
    });
  }

  void top(){
    isTopVisible = false;
    isAllVisible =  false;
    isBestVisible =  true;
    isMostVisible = true;
  }

  void best(){
    isBestVisible =  false;
    isTopVisible = true;
    isAllVisible =  false;
    isMostVisible = true;
  }

  void all(){
    isTopVisible = true;
    isAllVisible =  true;
    isBestVisible =  true;
    isMostVisible = true;
  }

  void most(){
    isMostVisible = false;
    isTopVisible = true;
    isAllVisible =  false;
    isBestVisible =  true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        backgroundColor: HexColor("#F9F9F9"),
        displacement: 40.0,
        strokeWidth: 3.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
          
                    Stack(
                      children: [
                        GestureDetector(
                          onTap:(){
                            setState(() {
                              all();
                            });
                          },
                          child: Container(
                            height: 30.0,
                            width: 40.0,
                            margin: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                              borderRadius: BorderRadius.all(Radius.circular(12.0),),
                            ),
                            child: Center(
                              child: Text("All", style: TextStyle(color: HexColor("#00B578"), fontSize: 13.0),),
                            ),
                          ),
                        ),
                        //
                        Visibility(
                          visible: isAllVisible,
                          child: Container(
                            height: 30.0,
                            width: 40.0,
                            margin: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                              color: HexColor("#00B578"),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(child: Text("All", style: TextStyle(color: Colors.white, fontSize: 13.0),)),
                          ),
                        ),
          
                      ],
                    ),
          
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: (){
          
                            setState(() {
                              top();
                            });
                          },
                          child: Container(
                            height: 30.0,
                            width: 65.0,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                              borderRadius: BorderRadius.all(Radius.circular(12.0),),
                            ),
                            child: Center(
                              child: Text("House", style: TextStyle(color: HexColor("#00B578"), fontSize: 13.0),),
                            ),
                          ),
                        ),
                        //
                        Visibility(
                          visible: !isTopVisible,
                          child: Container(
                            height: 30.0,
                            width: 65.0,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              color: HexColor("#00B578"),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(child: Text("House", style: TextStyle(color: Colors.white, fontSize: 13.0),)),
                          ),
                        ),
          
                      ],
                    ),
          
                    Stack(
                      children: [
          
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              best();
                            });
                          },
                          child: Container(
                            height: 30.0,
                            width: 50.0,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                              borderRadius: BorderRadius.all(Radius.circular(12.0),),
                            ),
                            child: Center(
                              child: Text("Villa", style: TextStyle(color: HexColor("#00B578"), fontSize: 13.0),),
                            ),
                          ),
                        ),
                        //
                        Visibility(
                          visible: !isBestVisible,
                          child: Container(
                            height: 30.0,
                            width: 50.0,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              color: HexColor("#00B578"),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(child: Text("Villa", style: TextStyle(color: Colors.white, fontSize: 13.0),)),
                          ),
                        ),
          
                      ],
                    ),
          
                    Stack(
                      children: [
          
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              most();
                            });
                          },
                          child: Container(
                            height: 30.0,
                            width: 95.0,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                              borderRadius: BorderRadius.all(Radius.circular(12.0),),
                            ),
                            child: Center(
                              child: Text("Apartment", style: TextStyle(color: HexColor("#00B578"), fontSize: 13.0),),
                            ),
                          ),
                        ),
                        //
          
                        Visibility(
                          visible: !isMostVisible,
                          child: Container(
                            height: 30.0,
                            width: 95.0,
                            margin: EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              color: HexColor("#00B578"),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(child: Text("Apartment", style: TextStyle(color: Colors.white, fontSize: 13.0),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
            Container(
              height: 280.0,
                margin: EdgeInsets.only(top: 50.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10.0, bottom:20.0),
                      width: 260.0,
                      height: 280.0,
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                               child: ClipRRect(
                               borderRadius: BorderRadius.circular(10.0),
                               child: Stack(
                                 children: [
                                       Container(
                                           height:150.0,
                                           width: MediaQuery.of(context).size.width,
                                           child: Image(image: AssetImage("images/new_house.png"), fit: BoxFit.fill)),
          
                                   Row(
                                     children: [
                                       Expanded(child: SizedBox()),
          
                                       Container(
                                         margin: const EdgeInsets.only(top: 15.0, right: 15.0),
                                         width: 60.0,
                                         height: 25.0,
                                         decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(5.0),
                                         ),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           children: [
          
                                             Expanded(child: SizedBox()),
          
                                             Padding(
                                               padding: const EdgeInsets.only(),
                                               child: Icon(Icons.star, color: HexColor("#FFB400"), size: 16.0 ,),
                                             ),
          
                                             Padding(
                                               padding: const EdgeInsets.only(),
                                               child: Text("4.5", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                                             ),
          
                                             Expanded(child: SizedBox()),
          
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                 ],
                                    ),
                               ),
                                ),
          
                             Padding(
                               padding: const EdgeInsets.only(top: 10.0, left: 13.0),
                               child: Text("Venus Hotel & Apartment", style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                               ),
                             ),
          
                             Padding(
                                 padding: const EdgeInsets.only(top: 0.0, left: 10.0,),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Image(image: AssetImage("images/location_grey.png"),height: 16.0, width: 16.0,),
          
                                     Padding(
                                       padding: const EdgeInsets.only(left: 5.0),
                                       child: Text("Ogba, Lagos",style: TextStyle(color:HexColor("#7F7F7F"), fontWeight: FontWeight.normal, fontSize:14.0,),),
                                     ),
                                   ],
                                 )
                             ),
          
                             Padding(
                               padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
                               child: Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(top: 0.0, left: 16.0),
                                     child: Text("₦550,000", style: TextStyle(color: HexColor("#00B578"), fontSize: 20.0, fontWeight: FontWeight.normal),
                                     ),
                                   ),
          
                                   Padding(
                                     padding: const EdgeInsets.only(top: 0.0),
                                     child: Text("/Yearly", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),
                                     ),
                                   ),
          
                                   Expanded(child: SizedBox()),
          
                                   Padding(
                                     padding: const EdgeInsets.only(top: 0.0, right: 12.0),
                                     child: Image(image: AssetImage("images/Love.png"),width: 30.0, height: 30.0,),
                                   ),
                                 ],
                               ),
                             )
                           ],
                        ),
                      ),
                    );
                  },
                ),
            ),
          

            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 20.0),
              child: Text("Others", style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                shrinkWrap: true, // Important!
                physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 7.0, right: 15.0, left: 15.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                            color: HexColor("#F5F5F5"), width: 1.5),
                      ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [

                             Container(
                               margin: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 20.0),
                               height: 105.0,
                               width: 120.0,
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(10.0),
                                 child: Image(image: AssetImage("images/new_house.png"), fit: BoxFit.fill,)
                                 ),
                             ),

                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [

                                  Padding(
                                   padding: const EdgeInsets.only(top: 15.0, left: 16.0),
                                   child: Text("Apartment", style: TextStyle(color: HexColor("#00B578"), fontSize: 12.0, fontWeight: FontWeight.normal),
                                   ),
                                 ),

                               Padding(
                                 padding: const EdgeInsets.only(top: 5.0, left: 13.0),
                                 child: Text("Ocean Park Apartment 3", style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                                 ),
                               ),

                               Padding(
                                   padding: const EdgeInsets.only(top: 5.0, left: 10.0,),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Image(image: AssetImage("images/location_grey.png"),height: 16.0, width: 16.0,),

                                       Padding(
                                         padding: const EdgeInsets.only(left: 5.0),
                                         child: Text("Lekki Phase 2, Lagos",style: TextStyle(color:HexColor("#7F7F7F"), fontWeight: FontWeight.normal, fontSize:14.0,),),
                                       ),
                                     ],
                                   )
                               ),

                               Padding(
                                 padding: const EdgeInsets.only(top: 2.0, bottom: 25.0),
                                 child: Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(top: 0.0, left: 16.0),
                                       child: Text("₦550,000", style: TextStyle(color: HexColor("#00B578"), fontSize: 16.0, fontWeight: FontWeight.normal),
                                       ),
                                     ),

                                     Padding(
                                       padding: const EdgeInsets.only(top: 0.0),
                                       child: Text("/Yearly", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),
                                       ),
                                     ),
                                     
                                        //  Padding(
                                        //   padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                                        //   child: Image(image: AssetImage("images/Love.png"),width: 25.0, height: 25.0,),
                                        // ),
                                     
                                   ],
                                 ),
                               )

                             ],
                           ),
                         ],
                       ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 20.0,
            ),
          ],

              ),
           ),
        ),
     );
  }
}
