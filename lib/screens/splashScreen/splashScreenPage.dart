import 'dart:async';
import'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/slider/slider.dart';

import '../CustomerDashboard/ui/CustomerDashboard.dart';
import '../agentDashboard/ui/agentDashboard.dart';
import '../database/appPrefHelper.dart';
import '../database/saveValues.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    getSavedValue();

  }

  Future<void> getSavedValue() async {
    SaveValues mySaveValues = SaveValues();
    String? token = await mySaveValues.getString(AppPreferenceHelper.AUTH_TOKEN);
    String? customerId = await mySaveValues.getString(AppPreferenceHelper.CUSTOMER_ID);
    String? agentId = await mySaveValues.getString(AppPreferenceHelper.AGENT_ID);

    await Future.delayed(Duration(seconds: 5));


    if(token != null && token != "" && customerId != null && customerId != ""){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomerDashboardPage()),
      );
    }

    else if(token != null && token != "" && agentId != null && agentId != ""){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AgentDashboardPage()),
      );
    }

    else{
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SliderPage()),
            );
    }
  }


    @override
    Widget build(BuildContext context) {
    // Timer(Duration(seconds: 5), (){
    //   Navigator.of(context).pushReplacementNamed('/slider');
    // });
    return Scaffold(
      backgroundColor: HexColor("#212529"),
      appBar: AppBar(
        backgroundColor: HexColor("#212529"),
      ) ,
      body: Center(
          child: Image(image: AssetImage("images/next_crib_logo.png")),
      ),
    );
  }
}


