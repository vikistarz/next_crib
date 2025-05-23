import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ErrorMessageDialog extends StatelessWidget {

   String? content;
   VoidCallback onButtonPressed;

  ErrorMessageDialog({
    required this.content,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image(image: AssetImage("images/error_tick.png"),width: 42.0, height: 42.0,),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: Text("Error", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#FF2121")),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0,),
              child: Text(content!, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
              ),
            ),

            SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 50.0),
              child: Center(
                child: ElevatedButton(onPressed: onButtonPressed ,
                  child: Text("Try Again", style: TextStyle(fontSize: 15.0),),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: HexColor("#B50000"), padding: EdgeInsets.all(10.0),
                    minimumSize: Size(MediaQuery.of(context).size.width, 45.0),
                    // fixedSize: Size(300.0, 50.0),
                    textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0)),
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