
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'agentFragment.dart';
import 'customerFragment.dart';
class LogInPage extends StatefulWidget {
  LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  bool isAgentVisible =  true;
  bool isCustomerVisible = true;

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

                 Container(
                    margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 0.0),
                    height: 250.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("images/login_logo.png",), fit: BoxFit.fitWidth),
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0),),
                  ),
                  ),

              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text("Welcome Back", style: TextStyle(color: HexColor("#00B578"), fontSize: 30.0, fontWeight: FontWeight.bold),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text("Sign In to your account", style: TextStyle(color: HexColor("#212529"), fontSize: 12.0, fontWeight: FontWeight.normal),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox()),

                        Stack(
                          children: [
                            Visibility(
                              visible: !isCustomerVisible,
                              child: new GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isAgentVisible = !isAgentVisible;
                                    isCustomerVisible = !isCustomerVisible;

                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text("Customer", style: TextStyle(color: HexColor("#D2D2D2"), fontSize: 15.0, fontWeight: FontWeight.normal),),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: isCustomerVisible,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Text("Customer", style: TextStyle(color: HexColor("#00B578"), fontSize: 15.0, fontWeight: FontWeight.bold),),
                                  ),

                                  Container(
                                    height: 2.0,
                                    width: 70.0,
                                    color: HexColor("#718355"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        Container(
                          margin: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 2.0 ),
                          height: 18.0,
                          width: 2.0,
                          color: HexColor("#718355"),
                        ),

                        Stack(
                          children: [

                            Visibility(
                              visible: isAgentVisible,
                              child: GestureDetector(
                                onTap:() {
                                  setState(() {
                                     isAgentVisible = !isAgentVisible;
                                     isCustomerVisible = !isCustomerVisible;

                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text("Agent", style: TextStyle(color: HexColor("#D2D2D2"), fontSize: 15.0, fontWeight: FontWeight.normal),),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: !isAgentVisible,
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Text("Agent", style: TextStyle(color: HexColor("#00B578"), fontSize: 15.0, fontWeight: FontWeight.bold),),
                                  ),

                                  Container(
                                    height: 2.0,
                                    width: 45.0,
                                    color: HexColor("#718355"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),


                        Expanded(
                            flex: 1,
                            child: SizedBox()),
                      ],
                    ),
                ),




              SizedBox(
                height: 10.0,
              ),

              Stack(
                children: [
                  Visibility(
                    visible:  isCustomerVisible,
                    child: CustomerFragment(),
                  ),

                  Visibility(
                    visible:  !isAgentVisible,
                    child: AgentFragment(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
