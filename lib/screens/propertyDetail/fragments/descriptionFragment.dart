import'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../CustomerDashboard/fragments/customerHome/model/AllPropertiesResponseModel.dart';
class DescriptionFragment extends StatefulWidget {
     DescriptionFragment({super.key,required this.description, required this.createdAt,
       required this.totalPackage, required this.dimension, required this.bedroom,
       required this.agent, required this. toilets});

     String description;
     String createdAt;
     int totalPackage;
     int dimension;
     Agent agent;
     int bedroom;
     int toilets;


  @override
  State<DescriptionFragment> createState() => _DescriptionFragmentState();
}

class _DescriptionFragmentState extends State<DescriptionFragment> {

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final capitalisedFirstName  = capitalize(widget.agent.firstName);
    final capitalisedLastName  = capitalize(widget.agent.lastName);

    String formattedTotalPackage = NumberFormat("#,##0").format(widget.totalPackage);
    // Parse the ISO 8601 date string into a DateTime object
    DateTime parsedDate = DateTime.parse(widget.createdAt);

    // Format the DateTime object to a readable format
    String formattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);
    print(formattedDate); // Outputs: October 30, 2024
    return Container(
      color: HexColor("#F9F9F9"),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: HexColor("#838383"), width: 0.30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 16.0),
                      child: Text("About this home", style: TextStyle(color: HexColor("#00B578"),fontSize: 10.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0, bottom: 15.0),
                      child: Text(widget.description, style: TextStyle(color: HexColor("#707070"),fontSize: 11.0, fontWeight: FontWeight.normal),),
                    ),
                  ),
                ]
              )
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text("House Total Package", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ),

                Expanded(child: SizedBox()),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                  child: Text("₦"+formattedTotalPackage.toString(), style: TextStyle(color: HexColor("#00B578"), fontSize: 18.0, fontWeight: FontWeight.normal),
                  ),
                ),

              ],
            ),


            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                child: Text("Listed by" +" " + capitalisedFirstName + " " + capitalisedLastName, style: TextStyle(color: HexColor("#838383"), fontSize: 15.0, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 0.0),
                        child: Image(image: AssetImage("images/time_lapse.png"), width: 11.0, height: 11.0,),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 8.0),
                        child: Text("Posted, $formattedDate", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0, fontWeight: FontWeight.normal),
                        ),
                      ),

                    ],
                  ),
                ),

                Expanded(child: SizedBox()),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10.0,),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 0.0),
                        child: Image(image: AssetImage("images/dimension.png"), width: 11.0, height: 11.0,),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 8.0),
                        child: Text(widget.dimension.toString() +" " + "per sqft", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 0.0),
                        child: Image(image: AssetImage("images/time_lapse.png"), width: 11.0, height: 11.0,),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 8.0),
                        child: Text("Posted, $formattedDate", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(child: SizedBox()),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10.0,),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0, top: 0.0),
                        child: Image(image: AssetImage("images/dimension.png"), width: 11.0, height: 11.0,),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 8.0),
                        child: Text(widget.dimension.toString() +" " + "per sqft", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
