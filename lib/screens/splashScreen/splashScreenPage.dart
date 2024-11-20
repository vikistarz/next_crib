import 'dart:async';
import'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), (){
      Navigator.of(context).pushReplacementNamed('/slider');
    });
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


