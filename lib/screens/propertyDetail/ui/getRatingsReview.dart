import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:next_crib/screens/CustomerDashboard/fragments/customerHome/model/agentModel.dart';
import 'package:next_crib/screens/propertyDetail/model/GetReviewsResponseModel.dart';

import '../../database/appPrefHelper.dart';
import '../../database/saveValues.dart';
import '../../webService/apiConstant.dart';

class GetRatingsReviewPage extends StatefulWidget {
  GetRatingsReviewPage({super.key, required this.agent});

  Agent agent;

  @override
  State<GetRatingsReviewPage> createState() => _GetRatingsReviewPageState();
}

class _GetRatingsReviewPageState extends State<GetRatingsReviewPage> {

  bool isLoadingVisible = true;

  void loading(){
    setState(() {
      isLoadingVisible = false;
    });
  }

  void isNotLoading(){
    setState(() {
      isLoadingVisible = true;
    });
  }

  Future<GetReviewsResponseModel> fetchRatingAndReview() async {
    SaveValues mySaveValues = SaveValues();
    String? token = await mySaveValues.getString(AppPreferenceHelper.AUTH_TOKEN);

    final String apiUrl = ApiConstant.baseUri+"agents/"+widget.agent.id+"/reviews";
    print("Making GET request to: $apiUrl");
    final response = await http.get(
        Uri.parse(apiUrl),

      headers:<String, String>{
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },);


    print("request: " + response.toString());
    print(response.statusCode);


    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return GetReviewsResponseModel.fromJson(jsonResponse);
    }
    else {
      print('Response Body: ${response.body}');
      throw Exception('Failed to load properties');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor:Colors.white,
        leading:  GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.0),
            width: 16.0,
            height: 18.0,
            child: Icon(Icons.arrow_back,color: Colors.black),
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchRatingAndReview(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:  SpinKitFadingCircle(
                  color: HexColor("#212529"),
                  size: 40.0,));
          }
          else if (snapshot.hasError) {
            // print('Error: $error');
            return Dialog(
              backgroundColor: Colors.white,
              child: Container(
                height: 170.0,
                child: Column(
                  children: [
                    Row(
                      children: [

                      Expanded(child: SizedBox(),),

                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 20.0),
                          child: Text('Sorry an error occurred', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal,),),
                        ),

                        Expanded(child: SizedBox(),),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                      child: Center(
                        child: ElevatedButton(onPressed: () {

                          fetchRatingAndReview();
                        },
                          child: Text("Try Again", style: TextStyle(fontSize: 14.0),),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: HexColor("#FF2121"), padding: EdgeInsets.all(10.0),
                            minimumSize: Size(200.0, 30.0),
                            // fixedSize: Size(300.0, 50.0),
                            textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
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
                // child: Center(child: Text('Error: ${snapshot.error}')),
              ),
            );
          }
          else if(!snapshot.hasData || snapshot.data!.items.isEmpty || snapshot.data == null){
            // return Dialog(
            //   backgroundColor: Colors.white,
            //   child: Container(
            //     height: 170.0,
            //     child: Column(
            //       children: [
            //         Row(
            //           children: [
            //             // Padding(
            //             //   padding: const EdgeInsets.only(top: 40.0, left: 25.0),
            //             //   child: Image(image: AssetImage("images/error_icon.png"), width: 40.0, height: 40.0,),
            //             // ),
            //
            //             Padding(
            //               padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 20.0),
            //               child: Text('No Item Found', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal,),),
            //             )
            //           ],
            //         ),
            //
            //         Padding(
            //           padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
            //           child: Center(
            //             child: ElevatedButton(onPressed: () {
            //
            //               Navigator.pop(context);
            //             },
            //               child: Text("Try Again", style: TextStyle(fontSize: 14.0),),
            //               style: ElevatedButton.styleFrom(
            //                 foregroundColor: Colors.white, backgroundColor: HexColor("#FF2121"), padding: EdgeInsets.all(10.0),
            //                 minimumSize: Size(200.0, 30.0),
            //                 // fixedSize: Size(300.0, 50.0),
            //                 textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
            //                 elevation: 5,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),
            //                       topRight: Radius.circular(15.0),
            //                       bottomRight: Radius.circular(15.0),
            //                       bottomLeft: Radius.circular(15.0)),
            //                 ),
            //                 // side: BorderSide(color: Colors.black, width: 2),
            //                 // alignment: Alignment.topCenter
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     // child: Center(child: Text('Error: ${snapshot.error}')),
            //   ),
            // );


            return Center(
              child: Text("No Results Found",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );

          }
          else {

            final reviews = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 10.0 ),
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: reviews.items.length,
                itemBuilder: (context, index) {

                  final review = reviews.items[index];


                  // Parse the ISO 8601 date string into a DateTime object
                  DateTime parsedDate = DateTime.parse(review.createdAt);

                  // Format the DateTime object to a readable format
                  String formattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);

                  print(formattedDate); // Outputs: October 30, 2024

                  return Container(
                    // height: 250.0,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 15.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                                child: RatingBar.builder(
                                  initialRating: review.rating.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                  itemBuilder: (context,_) => Icon(Icons.star, color: HexColor("#FFC107"),),
                                  onRatingUpdate: (rating){

                                    setState(() {

                                      // Get the selected rating value
                                    });
                                  },
                                  itemSize: 16.0,
                                  unratedColor: Colors.grey[300],
                                ),
                              ),

                              Expanded(child: SizedBox()),

                              Padding(
                                padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                                child: Text(formattedDate, style: TextStyle(fontSize: 9.0, color: HexColor("#858585")),),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                            child: Text(review.review, style: TextStyle(fontSize: 11.0, color: HexColor("#858585")),),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 5.0),
                            child: Text(review.customer.firstName + " " + review.customer.lastName + "-", style: TextStyle(fontSize: 11.0, color: HexColor("#212529")),),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
