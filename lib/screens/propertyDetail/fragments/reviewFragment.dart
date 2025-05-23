import 'dart:convert';
import'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:next_crib/screens/CustomerDashboard/fragments/customerHome/model/agentModel.dart';

import '../../database/appPrefHelper.dart';
import '../../database/saveValues.dart';
import '../../dialogs/errorMessageDialog.dart';
import '../../dialogs/successMessageDialog.dart';
import '../../webService/apiConstant.dart';
import '../ui/getRatingsReview.dart';
import '../ui/propertydetail.dart';



class ReviewFragment extends StatefulWidget {
   ReviewFragment({super.key, required this.agent});

  Agent agent;

  @override
  State<ReviewFragment> createState() => _ReviewFragmentState();
}

class _ReviewFragmentState extends State<ReviewFragment> {

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  String errorMessage = "";
  String successMessage = "";
  int? ratingValue;
  double? ratings;
  bool isLoadingVisible = true;



  void _resetRating() {
    setState(() {
      ratings = 0.0;
    });
  }

  void _validateFormField() {
    if (_formKey.currentState!.validate() && ratings! > 0 ) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  final commentController = TextEditingController();

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


  Future<void> postComment() async {
    loading();
    SaveValues mySaveValues = SaveValues();
    String? customerId = await mySaveValues.getString(AppPreferenceHelper.CUSTOMER_ID);
    String? token = await mySaveValues.getString(AppPreferenceHelper.AUTH_TOKEN);

    final String apiUrl = ApiConstant.baseUri+"agents/"+widget.agent.id+"/reviews";
    print("Making POST request to: $apiUrl");
    try {
      final response = await http.post(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
        "review": commentController.text,
        "rating": ratingValue,
        "customer": customerId

        }),
      );

      print("request: " + response.toString());
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200){
        isNotLoading();
        print('Response Body: ${response.body}');
        // successful post request, handle the response here
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          // successMessage = responseData['message'];
          commentController.text = "";
          _resetRating();

          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return SuccessMessageDialog(
                  content: "Rating and Review Submitted",
                  onButtonPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.push(context, MaterialPageRoute(builder: (context){
                    //   return Cust;
                    // }));
                    // Add any additional action here
                  },
                );
              });
        });
      }

      else{
        isNotLoading();
        print('Response Body: ${response.body}');
        // if the server return an error response
        final Map<String, dynamic> errorData = json.decode(response.body);
        errorMessage = errorData['message'] ?? 'Unknown error occurred';
        setState(() {
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return ErrorMessageDialog(
                  content: errorMessage,
                  onButtonPressed: () {
                    Navigator.of(context).pop();
                    // Add any additional action here
                  },
                );
              });
        });
      }
    }
    catch (e) {
      isNotLoading();
      print('Response Body: $e');
      setState(() {
        showModalBottomSheet(
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (BuildContext context) {
              return ErrorMessageDialog(
                content: "Sorry no internet Connection",
                onButtonPressed: () {
                  Navigator.of(context).pop();
                  // Add any additional action here
                },
              );
            });
      });
    }
  }








  // Future<List<GetReviewResponseModel>> fetchReviews(int serviceProviderId) async {
  //   final String apiUrl = ApiConstant.baseUri + 'skill-provider-reviews/details/$serviceProviderId';
  //
  //   loading();
  //
  //   final response = await http.get(
  //       Uri.parse(apiUrl));
  //
  //   print("request: " + response.toString());
  //   print(response.statusCode);
  //
  //   if (response.statusCode == 200) {
  //     print('Response Body: ${response.body}');
  //     final jsonResponse = json.decode(response.body);
  //     // Access the skill_provider object
  //     Map<String, dynamic> skillProviderDetailsAndReviews = jsonResponse['skillProviderDetailsAndReviews'];
  //
  //     // Access the reviews array inside skill_provider
  //     List<dynamic> reviewArray = skillProviderDetailsAndReviews['reviews'];
  //     return reviewArray.map((json) => GetReviewResponseModel.fromJson(json)).toList();
  //
  //
  //   }
  //
  //   else {
  //     isNotLoading();
  //
  //     setState(() {
  //       showModalBottomSheet(
  //           isScrollControlled: true,
  //           context: context,
  //           builder: (BuildContext context) {
  //             return ErrorMessageDialog(
  //               content: "An error occurred",
  //               onButtonPressed: () {
  //                 Navigator.of(context).pop();
  //                 // Add any additional action here
  //                 // isNotLoading();
  //               },
  //             );
  //           });
  //     });
  //     throw Exception('Failed to load items');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
    color: HexColor("#F9F9F9"),
    ),
    child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                  child: Text("Ratings & Reviews(${widget.agent.ratingsQuantity.toString()})", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 20.0),),
                 ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 30.0),
              child: Center(
                child: Text("Summary", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 13.0),),
              ),
            ),

            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text("5", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 13.0),),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Text("4", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 13.0),),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Text("3", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 13.0),),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Text("2", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 13.0),),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Center(
                        child: Text("1", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 13.0),),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left:5.0, top: 10.0, bottom: 2.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 10.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#C6C6C6"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),

                          Container(
                            height: 10.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#FFB400"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(left:5.0, top: 12.0, bottom: 2.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 10.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#C6C6C6"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),

                          Container(
                            height: 10.0,
                            width: 180.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#FFB400"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:5.0, top: 12.0, bottom: 2.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 10.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#C6C6C6"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),

                          Container(
                            height: 10.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#FFB400"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:5.0, top: 12.0, bottom: 2.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 10.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#C6C6C6"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),

                          Container(
                            height: 10.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#FFB400"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:5.0, top: 12.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 10.0,
                            width: 220.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#C6C6C6"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),

                          Container(
                            height: 10.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                              color:  HexColor("#FFB400"),
                              borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:0.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:20.0),
                            child: Text(widget.agent.ratingsAverage.toString(), style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 20.0),),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:5.0),
                            child: Icon(Icons.star, color: HexColor("#FFB400"), size: 18.0 ,),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Text("${widget.agent.ratingsQuantity.toString()}" + " " +"Reviews", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0),),
                    ),
                  ],
                ),

              ],
            ),

      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return GetRatingsReviewPage(agent: widget.agent);
          }));
        },
        child: Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            border: Border.all(color: HexColor("#838383"), width: 1.0),
          ),
          child:  Center(
            child: Text("View all Reviews", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 16.0),),
          ),
        ),
      ),

            Padding(
              padding: const EdgeInsets.only(top:5.0),
              child: Text("Product reviews are managed by a third party to verify and compliance with our Ratings & Reviews Guidelines.", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0),),
            ),

            Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top:0.0),
                //   child: Text("and compliance with our", style: TextStyle(color: HexColor("#838383"), fontSize: 11.0),),
                // ),

                Padding(
                  padding: const EdgeInsets.only(left:0.0),
                  child: Text("View Ratings & Reviews Guidelines", style: TextStyle(color: HexColor("#42A5F5"), fontSize: 11.0),),
                ),
              ],
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                  child: Text("Rate and Review", style: TextStyle(color: Colors.black, fontSize: 22.0),),
                ),

                Expanded(
                    child: SizedBox()
                ),

                // Padding(
                //   padding: const EdgeInsets.only(top: 3.0),
                //   child: Text("Rate:", style: TextStyle(color: HexColor("#212529"), fontSize: 12.0),),
                // ),

                Padding(
                  padding: const EdgeInsets.only(right: 5.0, top: 10.0),
                  child: RatingBar.builder(
                    initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context,_) => Icon(Icons.star, color: HexColor("#FFC107"),),
                      onRatingUpdate: (rating){

                        setState(() {
                         ratings = rating; // Get the selected rating value
                        });
                      },
                    itemSize: 18.0,
                    unratedColor: Colors.grey[300],
                  ),
                ),
              ],
            ),

            Form(
              key: _formKey,
              onChanged: _validateFormField,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Review';
                    }
                    else{
                      return null; // Return null if the input is valid
                    }
                  },
                  controller: commentController,
                  keyboardType:TextInputType.text,
                  decoration: InputDecoration(

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#B5B3B3"), width: 0.5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#B5B3B3"), width: 0.5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
                    counterText: '',
                  ),

                  maxLines: 2,
                  maxLength: 100,
                  style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: ElevatedButton(onPressed: _isButtonEnabled
                        ? () {
                      // Action to be taken on button press
                      ratingValue = ratings?.toInt();
                      postComment();
                    }
                        : null, // Disable button if form is invalid() {
                      child: Text("Review", style: TextStyle(fontSize: 15.0),),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                        minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
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

                Visibility(
                  visible: !isLoadingVisible,
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SpinKitFadingCircle(
                          color: HexColor("#F5F6F6"),
                          size: 20.0,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("Loading",style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize:12.0,),),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),


            // Padding(
            //   padding: const EdgeInsets.only(top: 20.0),
            //   child: Center(
            //     child: ElevatedButton(onPressed: _isButtonEnabled
            //         ? () {
            //       // Action to be taken on button press
            //       ratingValue = ratings?.toInt();
            //       postComment();
            //     }
            //         : null,
            //       child: Text("Review", style: TextStyle(fontSize: 15.0),),
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"),
            //         minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
            //         // fixedSize: Size(300.0, 50.0),
            //         textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
            //         elevation: 2,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),
            //               topRight: Radius.circular(15.0),
            //               bottomRight: Radius.circular(15.0),
            //               bottomLeft: Radius.circular(15.0)),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
