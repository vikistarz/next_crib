import 'dart:convert';

import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import '../fragments/CustomerAccountFragment.dart';
import '../fragments/customerHome/ui/CustomerHomeFragment.dart';
import '../fragments/CustomerMessageFragment.dart';
import '../fragments/CustomerWishlistFragment.dart';


class CustomerDashboardPage extends StatefulWidget {
  const CustomerDashboardPage({super.key});

  @override
  State<CustomerDashboardPage> createState() => _CustomerDashboardPageState();
}

class _CustomerDashboardPageState extends State<CustomerDashboardPage> {

  int pageIndex = 0;
  int? customerId ;
  String errorMessage = "";
  String firstName = "";
  String lastName = "";
  String emailAddress = "";


  @override
  void initState() {
    super.initState();
    // getSavedValue();
  }

  // getSavedValue() async  {
  //   SaveValues mySaveValues = SaveValues();
  //   customerId = await mySaveValues.getInt(AppPreferenceHelper.CUSTOMER_ID);
  //   setState(() {
  //     fetchUserData(customerId!);
  //   });
  // }

  // Future<void> fetchUserData(int id) async {
  //   final String apiUrl = ApiConstant.baseUri + 'customers/view/$id';
  //
  //   try {
  //     final response = await http.get(
  //         Uri.parse(apiUrl));
  //
  //     print("request: " + response.toString());
  //     print(response.statusCode);
  //
  //
  //     if (response.statusCode == 200) {
  //
  //       // Parse the JSON response
  //       final data = json.decode(response.body);
  //       print('Response Body: ${response.body}');
  //
  //       // Extract specific fields from the JSON
  //       String first_name = data['customer']["firstName"];
  //       String last_name = data['customer']['lastName'];
  //       String email_address = data['customer']['email'];
  //
  //
  //       // Update the state with the extracted data
  //       setState(() {
  //         firstName = first_name;
  //         lastName = last_name;
  //         emailAddress = email_address;
  //       });
  //
  //     } else {
  //
  //       print('Response Body: ${response.body}');
  //       // If the response code is not 200, show error
  //       final data = json.decode(response.body);
  //
  //       // Extract specific fields from the JSON
  //       errorMessage = data['error'];
  //     }
  //   } catch (error) {
  //     // Handle any exceptions during the HTTP request
  //   }
  // }


  final pages = [
    const CustomerHomeFragment(),
    const CustomerWishlistFragment(),
    const CustomerMessageFragment(),
    const CustomerAccountFragment(),
  ];

  // open log out dialog
  // void _openLogOutDialog(){
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context, builder: (ctx) => LogOutDialog());
  // }


  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    final capitalisedFirstName  = capitalize(firstName);
    final capitalisedLastName  = capitalize(lastName);
    final capitalisedEmail  = capitalize(emailAddress);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async{
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 0.0,
        ),
        body: pages[pageIndex],
        bottomNavigationBar: Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: HexColor("#C3BDBD"),
                  blurRadius: 0.5,
                  spreadRadius: 0.4,
                  offset: Offset(1,1),
                ),
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              InkWell(
                onTap: (){
                  setState(() {
                    pageIndex = 0;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 0 ? Icon(Icons.home, size: 25.0, color: HexColor("#00B578"),) :
                            Icon(Icons.home_outlined, size: 25.0, color: HexColor("#838383"),), enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 10.5),
                          child: new Text("Home", style: pageIndex == 0 ? TextStyle(color: HexColor("#00B578"), fontSize: 12.0) : TextStyle(color: HexColor("#838383"), fontSize: 12.0,),),
                        )
                      ],
                    ),

                  ],
                ),
              ),

              InkWell(
                onTap: (){
                  setState(() {
                    pageIndex = 1;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, top: 2.0 ),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 1 ? Icon(Icons.favorite, size: 25.0, color: HexColor("#00B578"),) :
                            Icon(Icons.favorite_outline_rounded, size: 25.0, color: HexColor("#838383"),), enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 5.0),
                          child: new Text("Wishlist", style: pageIndex == 1 ? TextStyle(color: HexColor("#00B578"), fontSize: 12.0) : TextStyle(color: HexColor("#838383"), fontSize: 12.0),),
                        )
                      ],
                    )
                  ],
                ),
              ),

              InkWell(
                onTap: (){
                  setState(() {
                    pageIndex = 2;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 2.0 ),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 2 ? Icon(Icons.message_sharp, size: 25.0, color: HexColor("#00B578"),) :
                            Icon(Icons.message_sharp, size: 25.0, color: HexColor("#838383"),), enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, ),
                          child: new Text("Message", style: pageIndex == 2 ? TextStyle(color: HexColor("#00B578"), fontSize: 12.0) : TextStyle(color: HexColor("#838383"), fontSize: 12.0),),
                        )
                      ],
                    )
                  ],
                ),
              ),

              InkWell(
                onTap: (){
                  setState(() {
                    pageIndex = 3;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 2.0 ),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 3 ? Icon(Icons.person, size: 25.0, color: HexColor("#00B578"),) :
                            Icon(Icons.person_outline, size: 25.0, color: HexColor("#838383"),), enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 5.0),
                          child: new Text("Account", style: pageIndex == 3 ? TextStyle(color: HexColor("#00B578"), fontSize: 12.0) : TextStyle(color: HexColor("#838383"), fontSize: 12.0),),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
