import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/logIn/ui/customer/customerFragment.dart';
import 'package:next_crib/screens/logIn/ui/customer/customerResetPassword.dart';
import 'package:next_crib/screens/logIn/ui/logIn.dart';
import 'package:http/http.dart' as http;
import '../../../database/appPrefHelper.dart';
import '../../../database/saveValues.dart';
import '../../../dialogs/errorMessageDialog.dart';
import '../../../dialogs/successMessageDialog.dart';
import '../../../webService/apiConstant.dart';

class CustomerValidateOtpPage extends StatefulWidget {
  const CustomerValidateOtpPage({super.key});

  @override
  State<CustomerValidateOtpPage> createState() => _CustomerValidateOtpPageState();
}

class _CustomerValidateOtpPageState extends State<CustomerValidateOtpPage> {

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool isLoadingVisible = true;
  String errorMessage = "";
  String successMessage = "";
  String? userEmail;

  @override
  void initState() {
    super.initState();
    getSavedValue();
  }

  getSavedValue() async  {
    SaveValues mySaveValues = SaveValues();
    String? email = await mySaveValues.getString(AppPreferenceHelper.EMAIL_ADDRESS);
    setState(() {
      userEmail = email;
    });
  }


  // Function to validate the form and update button state
  void _validateFormField() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }


  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

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


  Future<void> makePostRequest() async {
    loading();
    const String apiUrl = ApiConstant.customerValidateOtp;
    print('post: $apiUrl');
    try {
      final response = await http.post(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json"
        },

        body: jsonEncode(<String, dynamic>{

               "email": userEmail,
               "otp": otpController.text

        }),
      );

      print("request: " + response.toString());
      print(response.statusCode);

      if (response.statusCode == 200) {
        isNotLoading();
        print('Response Body: ${response.body}');
        // successful post request, handle the response here
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          successMessage = responseData['message'];
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return SuccessMessageDialog(
                  content: successMessage,
                  onButtonPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return CustomerResetPasswordPage();
                    }));

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
                  isNotLoading();
                },
              );
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
                  isNotLoading();
                },
              );
            });
      });
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.0, left: 30.0),
              child: Text("Enter OTP",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20.0,),),
            ),

            Padding(
              padding: EdgeInsets.only(top: 0.0, left: 30.0),
              child: Text("Enter the OTP sent to your email",style: TextStyle(color: HexColor("#9CA3AF"), fontWeight: FontWeight.normal, fontSize:16.0,),),
            ),

            Form(
              key: _formKey,
              onChanged: _validateFormField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 30.0),
                    child: Text(
                      "OTP", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                      validator: (value) {
                        final regex = RegExp(r'^[+-]?\d+(\.\d+)?$');
                        if (value == null || value.isEmpty) {
                          return 'Enter OTP';
                        }
                        if (value.length < 4) {
                          return 'Enter a valid OTP';
                        }
                        if (!regex.hasMatch(value)) {
                          return 'Enter a valid OTP';
                        }
                        else{
                          return null; // Return null if the input is valid
                        }
                      },
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        // Set this to true to enable the background color
                        fillColor: Colors.white,
                        // Set the desired background color
                        // hintText: "Email Address or Phone Number",
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor("#212529"), width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: HexColor("#212529"), width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text("Didn't get email?",style: TextStyle(color: HexColor("#9CA3AF"), fontWeight: FontWeight.normal, fontSize:15.0,),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: GestureDetector(
                              onTap: (){

                              },
                              child: Text("Resubmit",style: TextStyle(color: HexColor("#00B578"), fontWeight: FontWeight.bold, fontSize:15.0,),)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 50.0,
                  ),

                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Center(
                          child: ElevatedButton(onPressed: _isButtonEnabled
                              ? () {
                            // Action to be taken on button press
                            // loading();
                             makePostRequest();
                          }
                              : null, // Disable button if form is invalid() {
                            child: Text("Continue", style: TextStyle(fontSize: 16.0),),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                              minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
                              // fixedSize: Size(300.0, 50.0),
                              textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
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
                          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
