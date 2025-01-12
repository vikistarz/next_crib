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
        backgroundColor: Colors.grey,
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
            height: 275.0,
              margin: EdgeInsets.only(top: 50.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10.0, bottom:20.0 ),
                    width: 260.0,
                    height: 275.0,
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
                             child: Image(image: AssetImage("images/wishlist.png"), width: MediaQuery.of(context).size.width,
                           ),
                           ),
                         ],
                      ),
                    ),
                  );
                },
              ),
          ),


          Container(
            height: 500.0,
            margin: EdgeInsets.only(top: 50.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 10.0, bottom:20.0 ),

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
                          child: Image(image: AssetImage("images/wishlist.png"), width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]
    ),
         ),
        ),
    );
  }
}
