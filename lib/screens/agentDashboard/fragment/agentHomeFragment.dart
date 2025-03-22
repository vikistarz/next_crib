import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class AgentHomeFragment extends StatefulWidget {
  const AgentHomeFragment({super.key});

  @override
  State<AgentHomeFragment> createState() => _AgentHomeFragmentState();
}

class _AgentHomeFragmentState extends State<AgentHomeFragment> {

  Future<void> _refresh() async {
    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    // Add a new item to the list after refreshing
    setState(() {
      // fetchAllProperties();
      // fetchNearByProperties(latitude!, longitude!);
      // items.add("Item ${items.length + 1}");
    });
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

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 16.0),
                  child: Stack(children: [

                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Icon(Icons.notifications_none_rounded, size: 30.0, color: Colors.black,),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        height: 13.0,
                        width: 14.0,
                        decoration: BoxDecoration(
                          color: HexColor("#E30909"),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(child: Text("0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 7.0,),)),
                      )
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: 40.0,
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 16.0, right: 20.0),
                      child: TextFormField(
                        // controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: HexColor("#F5F5F5"),
                          prefixIcon: Icon(
                            Icons.search, color: HexColor("#C3BDBD"),
                            size: 22.0,),
                          hintText: "Search here",
                          hintStyle: TextStyle(fontSize: 13.0, color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          // Customize label color
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#F5F5F5"), width: 0.0),
                            borderRadius: BorderRadius.circular(
                                10.0), // Border color when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#F5F5F5"), width: 0.0),
                            borderRadius: BorderRadius.circular(
                                10.0), // Same border color when focused
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HexColor("#F5F5F5"), width: 0.0),
                            borderRadius: BorderRadius.circular(
                                10.0), // General border color
                          ),
                        ),
                        // onChanged: (query) => _filterItems(query),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (
                      //     context) {
                      //   return SearchPage();
                      // }));
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      margin: const EdgeInsets.only(top: 20.0, right: 16.0),
                      decoration: BoxDecoration(
                        color: HexColor("#F5F5F5"),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Image(
                              image: AssetImage("images/filter.png"),
                              width: 24.0,
                              height: 24.0,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: Text("Listings", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Expanded(child: Container(
                        height: 100.0,
                        margin: EdgeInsets.only(left: 16.0),
                       decoration: BoxDecoration(
                         color: HexColor("#3FC76D"),
                         borderRadius: BorderRadius.all(
                           Radius.circular(15.0),),
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                         Padding(
                           padding: const EdgeInsets.only(top:20.0),
                           child: Text("0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32.0,),),
                         ),

                           Padding(
                             padding: const EdgeInsets.only(top:0.0),
                             child: Text("New Listing", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0,),),
                           ),
                         ],
                       ),
                      ),
                      ),


                    SizedBox(
                      width: 16.0,
                    ),

                      Expanded(child: Container(
                        height: 100.0,
                        margin: EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          color: HexColor("#4661F1"),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:20.0),
                              child: Text("0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32.0,),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: Text("Rented Apartment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0,),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9.0),),
                  border: Border.all(color: HexColor("#EFEFEF"), width: 1.0),
                ),
                child:   Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:150.0, bottom: 150.0),
                    child: Text("No Activity Recorded", style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17.0,),),
                  ),
                ),
              )
            ],
          ),
        )
        ),
    );
  }
}
