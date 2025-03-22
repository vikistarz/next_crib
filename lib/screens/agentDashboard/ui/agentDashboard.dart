import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/createProperty/createProperty.dart';

import '../fragment/agentAccountFragment.dart';
import '../fragment/agentHomeFragment.dart';
import '../fragment/agentMoreFragment.dart';
import '../fragment/agentWalletFragment.dart';
class AgentDashboardPage extends StatefulWidget {
  const AgentDashboardPage({super.key});

  @override
  State<AgentDashboardPage> createState() => _AgentDashboardPageState();
}

class _AgentDashboardPageState extends State<AgentDashboardPage> {

  int pageIndex = 0;
  final pages = [
    const AgentHomeFragment(),
    const AgentWalletFragment(),
    const AgentMoreFragment(),
    const AgentAccountFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        // _showExitDialog(context);
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
                              Icons.wallet, size: 25.0,
                              color: HexColor("#00B578"),) :
                            Icon(Icons.wallet_outlined, size: 25.0,
                              color: HexColor("#838383"),),
                            enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, left: 8.0),
                          child: new Text("Wallet", style: pageIndex == 1
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

                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    // return LogInPage();
                    return const CreatePropertyPage();
                  }));
                },
                child:
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0, top: 0.0),
                          child: IconButton(onPressed: null,
                            icon:Icon(Icons.add_circle, size: 45.0,
                              color: HexColor("#838383"),)
                          ),
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
                          padding: const EdgeInsets.only(right: 2.0, top: 2.0),
                          child: IconButton(onPressed: null,
                            icon: pageIndex == 2 ? Icon(
                              Icons.settings, size: 25.0,
                              color: HexColor("#00B578"),) :
                            Icon(Icons.settings, size: 25.0,
                              color: HexColor("#838383"),),
                            enableFeedback: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0, top: 38.0,),
                          child: new Text("Settings", style: pageIndex == 2
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
}

