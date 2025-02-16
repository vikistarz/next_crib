import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../logIn/ui/logIn.dart';
class SuccessPasswordRecovery extends StatelessWidget {
  const SuccessPasswordRecovery({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 30.0, right: 30.0),
            child: Image(
                image: AssetImage("images/success_recovery.png"),
                width: MediaQuery.of(context).size.width,
                height: 220.0),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text("Success",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:24.0,),),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 0.0, left: 30.0),
            child: Text("Password Reset Successful",style: TextStyle(color: HexColor("#9CA3AF"), fontWeight: FontWeight.normal, fontSize:16.0,),),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 20.0),
            child: Center(
              child: ElevatedButton(onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LogInPage();

                }));
              },
                child: Text("Back To Login", style: TextStyle(fontSize: 15.0),),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                  minimumSize: Size(MediaQuery.of(context).size.width, 45.0),
                  // fixedSize: Size(300.0, 50.0),
                  textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0)),
                  ),
                  // side: BorderSide(color: Colors.black, width: 2),
                  // alignment: Alignment.topCenter
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

