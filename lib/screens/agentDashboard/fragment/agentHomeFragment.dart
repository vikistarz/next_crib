import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../database/appPrefHelper.dart';
import '../../database/saveValues.dart';
import '../../dialogs/errorMessageDialog.dart';
import '../../webService/apiConstant.dart';
import '../ui/editAgentprofile.dart';
class AgentHomeFragment extends StatefulWidget {
  const AgentHomeFragment({super.key});

  @override
  State<AgentHomeFragment> createState() => _AgentHomeFragmentState();
}

class _AgentHomeFragmentState extends State<AgentHomeFragment> {

  String firstName = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {

    SaveValues mySaveValues = SaveValues();
    String? token = await mySaveValues.getString(AppPreferenceHelper.AUTH_TOKEN);
    String? agentId = await mySaveValues.getString(AppPreferenceHelper.AGENT_ID);
    final String apiUrl = ApiConstant.baseUri + 'agents/$agentId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),

        headers:<String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },);

      print("request: " + response.toString());
      print(response.statusCode);


      if (response.statusCode == 200) {
        // isNotLoading();
        // Parse the JSON response
        final data = json.decode(response.body);
        print('Response Body: ${response.body}');

        // Extract specific fields from the JSON
        String first_name = data['data']["data"]['firstName'];
        // String last_name = data['data']["data"]['lastName'];
        // String email_address = data['data']["data"]['email'];
        // String phone_number = data['data']["data"]['phone'];
        // String citi = data['data']["data"]['city'];
        // String states = data['data']["data"]['state'];
        // String photo = data['data']['data']['displayPhoto'];

        // Update the state with the extracted data
        setState(() {

          firstName = first_name;
          // saveProfile();
        });

      } else {
        // isNotLoading();
        print('Response Body: ${response.body}');
        // If the response code is not 200, show error
        final data = json.decode(response.body);

        // Extract specific fields from the JSON
        errorMessage = data['message'];
        setState(() {
          setState(() {
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (BuildContext context) {
                  return ErrorMessageDialog(
                    content: errorMessage,
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                      // Add any additional action here
                      // isNotLoading();
                    },
                  );
                });
          });
        });
      }
    } catch (error) {
      // Handle any exceptions during the HTTP request
      // isNotLoading();
      setState(() {
        showModalBottomSheet(
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (BuildContext context) {
              return ErrorMessageDialog(
                content: "Sorry no internet Connection",
                onButtonPressed: () {
                  Navigator.of(context).pop();
                  // Add any additional action here
                  // isNotLoading();
                },
              );
            });
      });
    }
  }


  Future<void> _refresh() async {
    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    // Add a new item to the list after refreshing
    setState(() {
      fetchUserData();
      // fetchAllProperties();
      // fetchNearByProperties(latitude!, longitude!);
      // items.add("Item ${items.length + 1}");
    });
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }



  @override
  Widget build(BuildContext context) {
    final capitalisedFirstName  = capitalize(firstName);
    String firstNameFirstLetter = capitalisedFirstName.isNotEmpty ? capitalisedFirstName[0].toUpperCase() : '';
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
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 16.0),
                          child: Text("Hi,", style: TextStyle(color: HexColor("#838383"), fontWeight: FontWeight.normal, fontSize: 14.0,),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                            //   child: Image(image: AssetImage("images/location_icon.png"), width: 15.0, height: 15.0),
                            // ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 15.0),
                              child: Text(capitalisedFirstName,
                                style: TextStyle(color: HexColor("#1D1D1D"),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,),),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Expanded(
                      child: SizedBox(),
                    ),

                    GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return AgentNotificationPage();
                        //
                        // }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, right: 10.0),
                        child: Stack(
                          children: [
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

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return EditAgentProfilePage();

                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0, right: 16.0),
                        child: CircleAvatar(
                          backgroundColor: HexColor("#E3E3E3"),
                          child: Text(firstNameFirstLetter, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16.0,),),
                        ),
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
