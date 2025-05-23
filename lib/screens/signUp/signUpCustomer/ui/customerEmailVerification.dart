import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:next_crib/screens/logIn/ui/logIn.dart';
import 'package:next_crib/screens/webService/apiConstant.dart';
import '../../../dialogs/errorMessageDialog.dart';
import '../../../dialogs/successMessageDialog.dart';

class CustomerEmailVerificationPage extends StatefulWidget {
  const CustomerEmailVerificationPage({super.key});

  @override
  State<CustomerEmailVerificationPage> createState() => _CustomerEmailVerificationPageState();
}

class _CustomerEmailVerificationPageState extends State<CustomerEmailVerificationPage> {

  int? otpCode;
  String otpString = "";
  bool isLoadingVisible = true;
  String token = "";
  String errorMessage = "";

  final TextEditingController controller = TextEditingController();

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
    const String apiUrl = ApiConstant.customerEmailVerification;
    try {
      final response = await http.post(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "emailVerificationCode": otpString.toString(),
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
          // token = responseData['token'];
          // customerId = responseData['customer']['id'];
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return SuccessMessageDialog(
                  content: "Registration Successful",
                  onButtonPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return LogInPage();
                    }));
                    // Add any additional action here
                    // saveUserDetails();
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

  // void saveUserDetails() async {
  //
  //   SaveValues mySaveValues = SaveValues();
  //
  //   await mySaveValues.saveInt(AppPreferenceHelper.CUSTOMER_ID, customerId);
  //
  // }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async{
      SystemNavigator.pop();
    },
    child:
     Scaffold(
        backgroundColor: HexColor("#EEEEEE"),
         appBar: AppBar(
         toolbarHeight: 0.0,
          backgroundColor: HexColor("#EEEEEE"),
        leading:  GestureDetector(
        onTap: (){
      Navigator.pop(context);
    },
        child: Container(
        margin: EdgeInsets.only(left: 20.0),
        width: 16.0,
          height: 18.0,
         child: Icon(Icons.arrow_back_ios,color: Colors.black),
       ),
     ),
        ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image(image: AssetImage("images/lock_image.png"),height: 200.0, width: 210.0,),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text("Enter OTP",style: TextStyle(color:HexColor("#181818"), fontWeight: FontWeight.bold, fontSize:22.0,),),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text("Enter the One Time Password sent to your email.",style: TextStyle(color:HexColor("#7E7E7E"), fontWeight: FontWeight.normal, fontSize:12.0,),),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OtpTextField(
                  numberOfFields: 4,
                  // Set the number of OTP fields you want
                  fillColor: HexColor("#D9D9D9"),
                  filled: true,
                  // borderColor: HexColor("#D9D9D9"),
                  focusedBorderColor: HexColor("#D9D9D9"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  fieldHeight: 55.0,// Set the border color for the OTP field
                  fieldWidth: 55.0,
                  // obscureText: true,
                  showFieldAsBox: true, // If true, show the fields with a box
                  // onCodeChanged: (code) {
                  //   setState(() {
                  //     // otpString = code;
                  //   });
                  //   // print("OTP Submitted: $code");
                  // },
                  onSubmit: (code) {
                    setState(() {
                      otpString = code;
                    });
                    print("OTP Submitted: $code");
                  },
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
                        child: ElevatedButton(onPressed:() {
                          // Action to be taken on button press
                          // loading();
                          makePostRequest();

                        },// Disable button if form is invalid() {
                          child: Text("Confirm", style: TextStyle(fontSize: 16.0),),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                            minimumSize: Size(MediaQuery.of(context).size.width, 45.0),
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
      ),
     ),
    );
  }
}
