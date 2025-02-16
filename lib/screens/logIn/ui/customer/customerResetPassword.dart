import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:next_crib/screens/dialogs/successPasswordRecovery.dart';
import 'package:next_crib/screens/logIn/ui/logIn.dart';
import '../../../database/appPrefHelper.dart';
import '../../../database/saveValues.dart';
import '../../../dialogs/errorMessageDialog.dart';
import '../../../dialogs/successMessageDialog.dart';
import '../../../webService/apiConstant.dart';
class CustomerResetPasswordPage extends StatefulWidget {
  const CustomerResetPasswordPage({super.key});

  @override
  State<CustomerResetPasswordPage> createState() => _CustomerResetPasswordPageState();
}

class _CustomerResetPasswordPageState extends State<CustomerResetPasswordPage> {

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool isLoadingVisible = true;
  String errorMessage = "";
  bool passwordVisible =  false;
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


  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
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
    const String apiUrl = ApiConstant.customerResetPassword;
    print('PATCH: $apiUrl');
    try {
      final response = await http.patch(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{

            "email": userEmail,
            "password": passwordController.text
        }),
      );
      // print(" Sending POST Request with Body: ${jsonEncode(response)}");
      print('Request Body: $response');
      // print("request: " + response.toString());
      print(response.statusCode);

      if (response.statusCode == 200) {
        isNotLoading();
        print('Response Body: ${response.body}');
        // successful post request, handle the response here
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _openSuccessPasswordRecovery();
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


  // open log out dialog
  void _openSuccessPasswordRecovery(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder: (ctx) => SuccessPasswordRecovery());
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
                child: Text("Change New Password",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20.0,),),
              ),

              Padding(
                padding: EdgeInsets.only(top: 0.0, left: 30.0),
                child: Text("Enter a different password from the previous",style: TextStyle(color: HexColor("#9CA3AF"), fontWeight: FontWeight.normal, fontSize:16.0,),),
              ),

              Form(
                key: _formKey,
                onChanged: _validateFormField,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 30.0),
                      child: Text("New Password", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 8) {
                            return 'must be at least 8 characters long';
                          }
                          // if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          //     return 'Please enter a valid email';
                          //         }
                          else{
                            return null; // Return null if the input is valid
                          }
                        },
                        controller: passwordController,
                        obscureText: passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          // labelText: "Last name",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                          filled: true, // Set this to true to enable the background color
                          fillColor: Colors.white, // Set the desired background color
                          // hintText: "Password",
                          hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                          suffixIcon: IconButton(icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
                            onPressed: (){
                              setState(() {
                                passwordVisible = !passwordVisible;
                              },
                              );
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#212529"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#212529"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          counterText: '',
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                      child: Image(image: AssetImage("images/password_reset.png"),
                          width: MediaQuery.of(context).size.width,  height: 170.0),
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
                              child: Text("Reset Password", style: TextStyle(fontSize: 16.0),),
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
