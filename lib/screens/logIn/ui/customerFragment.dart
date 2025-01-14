
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../CustomerDashboard/CustomerDashboard.dart';
import '../../signUp/signUp.dart';
import '../../dialogs/errorMessageDialog.dart';
import '../../dialogs/successMessageDialog.dart';
import 'package:http/http.dart' as http;

import '../../webService/apiConstant.dart';

class CustomerFragment extends StatefulWidget {
  const CustomerFragment({super.key});

  @override
  State<CustomerFragment> createState() => _CustomerFragmentState();
}

class _CustomerFragmentState extends State<CustomerFragment> {

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool isLoadingVisible = true;
  bool passwordVisible =  false;
  String token = "";
  String role = "";
  String errorMessage = "";
  int customerId = 0;



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


  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    emailAddressController.dispose();
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
    const String apiUrl = ApiConstant.logInApi;
    print(apiUrl);
    try {
      final response = await http.post(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "email": emailAddressController.text,
          "password": passwordController.text
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
          role = responseData['data']['user']['role'];
          token = responseData['token'];

          if(role == 'customer'){
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return SuccessMessageDialog(
                    content: "Login Successful",
                    onButtonPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const CustomerDashboardPage();
                        }));
                      // saveUserDetails();
                    },
                  );
                });
          }

          else{
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (BuildContext context) {
                  return ErrorMessageDialog(
                    content: "User is not a Customer",
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                      // Add any additional action here
                      isNotLoading();
                    },
                  );
                });
            }

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

  //
  // void saveUserDetails() async {
  //
  //   SaveValues mySaveValues = SaveValues();
  //
  //   await mySaveValues.saveInt(AppPreferenceHelper.CUSTOMER_ID, customerId);
  //
  // }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
           children: [
             Container(
               margin: EdgeInsets.all(0.0),
               height: 250.0,
               decoration: BoxDecoration(
                 image: DecorationImage(image: AssetImage("images/customer_design.png",), fit: BoxFit.cover),
               ),
             ),
             Column(
               children: [
                 Form(
              key: _formKey,
              onChanged: _validateFormField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                  child: Text("Email", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),

                Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                   validator: (value) {
                     final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                     if (value == null || value.isEmpty) {
                       return 'Please enter email address';
                     }
                     if (value.length < 11) {
                       return 'Please enter a valid email address.';
                     }
                     if (!regex.hasMatch(value)) {
                       return 'Please enter a valid email address.';
                     }
                     else{
                       return null; // Return null if the input is valid
                     }
                          },
                      controller: emailAddressController,
                      keyboardType:TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true, // Set this to true to enable the background color
                        fillColor: Colors.white, // Set the desired background color
                          // hintText: "Email Address or Phone Number",
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                          hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
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
                  padding: const EdgeInsets.only(top: 20.0, left: 30.0),
                  child: Text("Password", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),

              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'must be at least 6 characters long';
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

                   ],
                  ),
                 ),

               InkWell(
                 onTap: () {

                 },
                 child: Align(
                         alignment: Alignment.topRight,
                           child: Container(
                             margin: EdgeInsets.only(top: 10.0, right: 30.0),
                             child: Text("Forgot Password?",style: TextStyle(color: HexColor("#00B578"), fontWeight: FontWeight.bold, fontSize:14.0,),),
                           ),
                       ),
               ),

                 Stack(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 10.0),
                       child: Center(
                         child: ElevatedButton(onPressed: _isButtonEnabled
                                ? () {
                           // Action to be taken on button press
                            makePostRequest();
                          }
                       : null, // Disable button if form is invalid() {
                           child: Text("Sign in", style: TextStyle(fontSize: 18.0),),
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
                         margin: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 10.0),
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

                 Container(
                   margin: EdgeInsets.only(top: 10.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                            Text("Don't have an account?",style: TextStyle(color: HexColor("#212529"), fontWeight: FontWeight.normal, fontSize:15.0,),),
                           Padding(
                             padding: const EdgeInsets.only(left: 15.0),
                             child: InkWell(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return SignUpPage();
                                 }));
                               },
                                 child: Text("Sign Up",style: TextStyle(color: HexColor("#00B578"), fontWeight: FontWeight.bold, fontSize:15.0,),)),
                           ),
                         ],
                       ),
                 ),

                 SizedBox(
                   height: 80.0,
                 )
               ],
             )
           ]
      ),
    );
  }

}

