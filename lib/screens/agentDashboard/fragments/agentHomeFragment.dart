import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../search/searchPage.dart';
class AgentHomeFragment extends StatefulWidget {
  const AgentHomeFragment({super.key});

  @override
  State<AgentHomeFragment> createState() => _AgentHomeFragmentState();
}

class _AgentHomeFragmentState extends State<AgentHomeFragment> {

  bool isAllVisible =  true;
  bool isTopVisible = true;
  bool isBestVisible = true;
  bool isMostVisible = true;
  bool isFlipCardVisible = true;
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

  void flipCard(){
    isFlipCardVisible = false;
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

  final List<String> images = [
    'images/next_crib_logo.png',
    'images/disabled_layout.png',
    'images/next_crib_logo.png',
    'images/disabled_layout.png',
    'images/next_crib_logo.png',
    'images/next_crib_logo.png',
  ];


  int topCardIndex = 0;

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

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                    child: Text("Location",style: TextStyle(color: HexColor("#838383"), fontWeight: FontWeight.normal, fontSize:14.0,),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                        child: Image(image: AssetImage("images/location_icon.png"), width: 15.0, height: 15.0),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                        child: Text("Abule-Egba, Lagos",style: TextStyle(color: HexColor("#1D1D1D"), fontWeight: FontWeight.normal, fontSize:16.0,),),
                      ),
                    ],
                  ),
                ],
              ),

              Expanded(
                child: SizedBox(),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 13.0, right: 10.0),
                child: Icon(Icons.notifications_none_rounded, size: 30.0, color: Colors.black,),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 13.0, right: 16.0),
               child: CircleAvatar(
                 backgroundColor: HexColor("#E3E3E3"),
                 child: Text("F",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize:16.0,),),
               ),
              ),
            ],
           ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 40.0,
                  margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: TextFormField(
                    // controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor("#F5F5F5"),
                      prefixIcon: Icon(Icons.search, color: HexColor("#C3BDBD"), size: 22.0,),
                      hintText: "Search here",
                      hintStyle: TextStyle(fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.normal),
                      // Customize label color
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#F5F5F5"), width: 0.0),
                        borderRadius: BorderRadius.circular(10.0),// Border color when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#F5F5F5"), width: 0.0),
                        borderRadius: BorderRadius.circular(10.0),// Same border color when focused
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#F5F5F5"), width: 0.0),
                        borderRadius: BorderRadius.circular(10.0),// General border color
                      ),
                    ),
                    // onChanged: (query) => _filterItems(query),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return SearchPage();
                  }));
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  margin: const EdgeInsets.only(top: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    color: HexColor("#F5F5F5"),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: Image(image: AssetImage("images/filter.png"), width: 24.0, height: 24.0,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Stack(
                    children: [
              GestureDetector(
                onTap:(){
                  setState(() {
                    all();
                    isFlipCardVisible = !isFlipCardVisible;
                  });
                },
                child: Container(
                  height: 32.0,
                  width: 45.0,
                  margin: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                    borderRadius: BorderRadius.all(Radius.circular(12.0),),
                  ),
                  child: Center(
                    child: Text("All", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0),),
                  ),
                     ),
              ),
                      //
                      Visibility(
                        visible: isAllVisible,
                        child: Container(
                          height: 32.0,
                          width: 45.0,
                          margin: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            color: HexColor("#00B578"),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(child: Text("All", style: TextStyle(color: Colors.white, fontSize: 14.0),)),
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
                           flipCard();
                          });
                        },
                        child: Container(
                          height: 32.0,
                          width: 95.0,
                          margin: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                            borderRadius: BorderRadius.all(Radius.circular(12.0),),
                          ),
                          child: Center(
                            child: Text("Top Rates", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0),),
                          ),
                        ),
                      ),
                      //
                      Visibility(
                        visible: !isTopVisible,
                        child: Container(
                          height: 32.0,
                          width: 95.0,
                          margin: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            color: HexColor("#00B578"),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(child: Text("Top Rates", style: TextStyle(color: Colors.white, fontSize: 14.0),)),
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
                            flipCard();
                          });
                        },
                        child: Container(
                          height: 32.0,
                          width: 100.0,
                          margin: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                            borderRadius: BorderRadius.all(Radius.circular(12.0),),
                          ),
                          child: Center(
                            child: Text("Best Offers", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0),),
                          ),
                        ),
                      ),
                      //
                      Visibility(
                        visible: !isBestVisible,
                        child: Container(
                        height: 32.0,
                        width: 100.0,
                        margin: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: HexColor("#00B578"),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(child: Text("Best Offers", style: TextStyle(color: Colors.white, fontSize: 14.0),)),
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
                          flipCard();
                        });
                        },
                        child: Container(
                          height: 32.0,
                          width: 112.0,
                          margin: EdgeInsets.only(left: 16.0, right: 20.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                            borderRadius: BorderRadius.all(Radius.circular(12.0),),
                          ),
                          child: Center(
                            child: Text("Most rated", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0),),
                          ),
                        ),
                      ),
                      //

                      Visibility(
                        visible: !isMostVisible,
                        child: Container(
                          height: 32.0,
                          width: 112.0,
                          margin: EdgeInsets.only(left: 16.0, right: 20.0),
                          decoration: BoxDecoration(
                            color: HexColor("#00B578"),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(child: Text("Most Rated", style: TextStyle(color: Colors.white, fontSize: 14.0),)),
                        ),
                      ),
                    ],
                  ),
                   ],
                ),
            ),
          ),

          Visibility(
            visible: isFlipCardVisible,
            child: Center(
              child: Container(
                height: 400,
                width: 300,
                margin: EdgeInsets.only(top: 50.0),
                child: Stack(
                  children: images.asMap().entries.map((entry) {
                    int index = entry.key;
                    String image = entry.value;

                    bool isTopCard = index == topCardIndex;

                    return AnimatedPositioned(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      top: isTopCard ? 0 : 20.0 * (index - topCardIndex),
                      left: isTopCard ? 0 : 10.0 * (index - topCardIndex),
                      child: GestureDetector(
                        onTap: () => _bringCardToFront(index),
                        child: AnimatedScale(
                          duration: Duration(milliseconds: 400),
                          scale: isTopCard ? 0.9 : 1.0,
                          child: _buildImageCard(image, index),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Row(
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Near You",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize:16.0,),),
                ),

                Expanded(child: SizedBox()),

                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text("See all",style: TextStyle(color: HexColor("#838383"), fontWeight: FontWeight.normal, fontSize:12.0,),),
                ),
              ],
            ),
          ),

          Container(
            height: 500.0,
            margin: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index){
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 7.0, right: 15.0, left: 15.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: HexColor("#F5F5F5"), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(
                      flex:1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0, bottom: 13.0, left: 13.0),
                        child: Image(image: AssetImage("images/house_image.png"), height: 100.0, width: 110.0, fit: BoxFit.fitHeight,),
                      ),
                    ),

                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                              child: Icon(Icons.star, size: 17, color: HexColor("#FCD400"),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                              child: Text("4.7",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize:13.0,),),
                            ),

                            Expanded(child: SizedBox()),

                            Container(
                              height: 20.0,
                              width: 67.0,
                              margin: EdgeInsets.only(top: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("images/disabled_layout.png",), fit: BoxFit.fitHeight),
                                borderRadius: BorderRadius.all(Radius.circular(12.0),),
                              ),
                              child: Center(
                                child: Text("Apartment", style: TextStyle(color: HexColor("#00B578"), fontSize: 10.0),),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                          child: Text("Ocean Park Apartment 3",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize:14.0,),),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                              child: Image(image: AssetImage("images/location_grey.png"),height: 12.2, width: 12.2,),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                              child: Text("1012 Agbe Road, Fagba, Lagos",style: TextStyle(color: HexColor("838383"), fontWeight: FontWeight.normal, fontSize:10.0,),),
                            ),
                          ],
                        ),

                        Row(
                          children: [

                            Expanded(child: SizedBox()),

                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
                              child: Text("₦340/month",style: TextStyle(color: HexColor("#00B578"), fontWeight: FontWeight.normal, fontSize:12.0,),),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  ],
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

  Widget _buildImageCard(String imagePath, int index) {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 200,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Card $index",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.black45,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _bringCardToFront(int index) {
    setState(() {
      topCardIndex = index;
    });
  }
}
