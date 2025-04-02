import 'dart:convert';

import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import '../fragments/customerAccountFragment.dart';
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


  final pages = [
    const CustomerHomeFragment(),
    const CustomerWishlistFragment(),
    const CustomerMessageFragment(),
    const CustomerAccountFragment(),
  ];


  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
       _showExitDialog(context);
        // return exitApp; // Return true to exit, false to stay
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 0.0,
        ),
        body: pages[pageIndex],
        bottomNavigationBar: Container(
          height: 60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: HexColor("#C3BDBD"),
                  blurRadius: 0.5,
                  spreadRadius: 0.4,
                  offset: Offset(1, 1),
                ),
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              InkWell(
                onTap: () {
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
                            icon: pageIndex == 0 ? Icon(Icons.home, size: 25.0,
                              color: HexColor("#00B578"),) :
                            Icon(Icons.home_outlined, size: 25.0,
                              color: HexColor("#838383"),),
                            enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 10.5),
                          child: new Text("Home", style: pageIndex == 0
                              ? TextStyle(
                              color: HexColor("#00B578"), fontSize: 12.0)
                              : TextStyle(
                            color: HexColor("#838383"), fontSize: 12.0,),),
                        )
                      ],
                    ),

                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0, top: 2.0),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 1 ? Icon(
                              Icons.favorite, size: 25.0,
                              color: HexColor("#00B578"),) :
                            Icon(Icons.favorite_outline_rounded, size: 25.0,
                              color: HexColor("#838383"),),
                            enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 5.0),
                          child: new Text("Wishlist", style: pageIndex == 1
                              ? TextStyle(
                              color: HexColor("#00B578"), fontSize: 12.0)
                              : TextStyle(
                              color: HexColor("#838383"), fontSize: 12.0),),
                        )
                      ],
                    )
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 2.0),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 2 ? Icon(
                              Icons.message_sharp, size: 25.0,
                              color: HexColor("#00B578"),) :
                            Icon(Icons.message_sharp, size: 25.0,
                              color: HexColor("#838383"),),
                            enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0,),
                          child: new Text("Message", style: pageIndex == 2
                              ? TextStyle(
                              color: HexColor("#00B578"), fontSize: 12.0)
                              : TextStyle(
                              color: HexColor("#838383"), fontSize: 12.0),),
                        )
                      ],
                    )
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    pageIndex = 3;
                  });
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 2.0),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 3 ? Icon(
                              Icons.person, size: 25.0,
                              color: HexColor("#00B578"),) :
                            Icon(Icons.person_outline, size: 25.0,
                              color: HexColor("#838383"),),
                            enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 5.0),
                          child: new Text("Account", style: pageIndex == 3
                              ? TextStyle(
                              color: HexColor("#00B578"), fontSize: 12.0)
                              : TextStyle(
                              color: HexColor("#838383"), fontSize: 12.0),),
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

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: Text("Exit App"),
        content: Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in app
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: Text("Exit"),
          ),
        ],
      ),
    ) ??
        false; // Return false if dialog is dismissed
  }

}
