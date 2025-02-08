import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:next_crib/screens/signUp/signUpAgent/dialogs/countryDialog.dart';
import '../../../dialogs/errorMessageDialog.dart';
import '../../../dialogs/successMessageDialog.dart';
import '../../signUpAgent/ui/agentEmailVerification.dart';
import '../../../logIn/ui/logIn.dart';
import '../../../webService/apiConstant.dart';
import '../../signUpAgent/dialogs/cityDialog.dart';
import 'package:http/http.dart' as http;
import '../../signUpAgent/dialogs/stateOfResidenceDialog.dart';
import '../../signUpAgent/models/userData.dart';
import 'customerEmailVerification.dart';


class SignUpCustomerPage extends StatefulWidget {
  const SignUpCustomerPage({super.key});

  @override
  State<SignUpCustomerPage> createState() => _SignUpCustomerPageState();
}

class _SignUpCustomerPageState extends State<SignUpCustomerPage> {

  final _formKey = GlobalKey<FormState>();
  bool passwordVisible =  false;
  bool confirmPasswordVisible =  false;
  bool _isButtonEnabled = false;
  bool isLoadingVisible = true;
  bool cityVisible = false;
  bool officeAddressVisible = false;
  bool subCategoryVisible = false;
  String token = "";
  String errorMessage = "";
  int customerWalletId = 0;

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


  TextEditingController statesController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();



  @override
  void dispose() {
    statesController.dispose();
    cityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    homeAddressController.dispose();

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

  void updateStateTextValue(){
    setState(() {
      statesController.text = states == null ? "" : "$states";
    });
  }

  void updateCityTextValue(){
    setState(() {
      cityController.text = city == null ? "" : "$city";
    });
  }

  Future<void> signUpCustomer() async {

    loading();

    final String apiUrl = ApiConstant.customerSignUpApi;

    try {
      final response = await http.post(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json"
        },
        body: jsonEncode(<String, dynamic>{
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailAddressController.text,
          "role": "customer",
          "state": statesController.text,
          "city": cityController.text,
          "address": homeAddressController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
        }),
      );

      print("request: " + response.toString());
      print(response.statusCode);

      if (response.statusCode == 201) {
        isNotLoading();
        print('Response Body: ${response.body}');
        // successful post request, handle the response here
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          // token = responseData['token'];
          // customerWalletId = responseData['wallet']['id'];
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return SuccessMessageDialog(
                  content: "Customer Sign up Successful",
                  onButtonPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return const CustomerEmailVerificationPage();
                    }));
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
        errorMessage = errorData['error'] ?? 'Unknown error occurred';
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
                    isNotLoading();
                  },
                );
              });
        });
      }
    }
    catch (e) {
      isNotLoading();
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
  //   await mySaveValues.saveInt(AppPreferenceHelper.CUSTOMER_WALLET_ID, customerWalletId!);
  //
  // }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Form(
            key: _formKey,
            onChanged: _validateFormField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [

                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, left: 30.0),
                              child: Text("First Name", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                final regex = RegExp(r'^[a-zA-Z]+$');
                                if (value == null || value.isEmpty) {
                                  return 'Enter First name';
                                }
                                if (value.length < 2) {
                                  return 'Enter a valid name with at least two alphabetic characters.';
                                }
                                if (!regex.hasMatch(value)) {
                                  return 'Enter only letters';
                                }
                                else{
                                  return null; // Return null if the input is valid
                                }
                              },
                              controller: firstNameController,
                              keyboardType:TextInputType.name,
                              decoration: InputDecoration(
                                // hintText: "First name",
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                counterText: '',
                              ),
                              style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                            ),
                          ),

                        ],
                      ),
                    ),


                    Expanded(
                      child: Column(
                        children: [

                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, left: 10.0),
                              child: Text("Last Name", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 30.0),
                            child: TextFormField(
                              validator: (value) {
                                final regex = RegExp(r'^[a-zA-Z]+$');
                                if (value == null || value.isEmpty) {
                                  return 'Enter Last name';
                                }
                                if (value.length < 2) {
                                  return 'Please enter a valid name with at least two alphabetic characters.';
                                }
                                if (!regex.hasMatch(value)) {
                                  return 'Enter only letters';
                                }
                                else{
                                  return null; // Return null if the input is valid
                                }
                              },
                              controller: lastNameController,
                              keyboardType:TextInputType.name,
                              decoration: InputDecoration(
                                // hintText: "First name",
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                counterText: '',
                              ),
                              style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                 Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                  child: Text("Phone Number", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),

                // Padding(
                //   padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                //   child: Stack(
                //     children: [
                //       TextFormField(
                //         validator: (value) {
                //           final regex = RegExp(r'^[+-]?\d+(\.\d+)?$');
                //           if (value == null || value.isEmpty) {
                //             return 'Enter phone Number';
                //           }
                //           if (value.length < 11) {
                //             return 'Enter Phone Number';
                //           }
                //           if (!regex.hasMatch(value)) {
                //             return 'Enter Phone Number';
                //           }
                //           else{
                //             return null; // Return null if the input is valid
                //           }
                //         },
                //         controller: phoneController,
                //         keyboardType:TextInputType.phone,
                //         maxLength: 11,
                //         decoration: InputDecoration(
                //           contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
                //           // hintText: "Mobile",
                //           hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5.0),
                //           ),
                //           enabledBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                //             borderRadius: BorderRadius.circular(5.0),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                //             borderRadius: BorderRadius.circular(5.0),
                //           ),
                //           counterText: '',
                //         ),
                //         style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                //       ),
                //
                //       Row(
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                //             // emailAddress == null ? "Email Address" : "$capitalisedEmail"
                //             child: GestureDetector(
                //                 onTap: (){
                //                   _openCountryDialog();
                //                 },
                //                 child: Text(flag  == null ? "🇳🇬 +234" : '$flag + $countryCode', style: TextStyle(color: HexColor("#00B578"), fontSize: 13.0, fontWeight: FontWeight.normal),)),
                //           ),
                //
                //           Container(
                //             margin: EdgeInsets.only(left: 2.0),
                //             height: 48.0,
                //             width: 1.0,
                //             color: HexColor("#A3A3A3"),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                  child: Stack(
                    children: [

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, left: 10.0),
                            child: Image(image: AssetImage("images/nigerian_flag.png"), width: 30.0, height: 30.0,),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, left: 1.0),
                            child: Text("+234", style: TextStyle(color: HexColor("#00B578"), fontSize: 13.0, fontWeight: FontWeight.normal),),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 2.0),
                            height: 48.0,
                            width: 1.0,
                            color: HexColor("#A3A3A3"),
                          ),
                        ],
                      ),
                      TextFormField(
                        validator: (value) {
                          final regex = RegExp(r'^[+-]?\d+(\.\d+)?$');
                          if (value == null || value.isEmpty) {
                            return 'Enter phone Number';
                          }
                          if (value.length < 11) {
                            return 'Enter a valid Phone Number';
                          }
                          if (!regex.hasMatch(value)) {
                            return 'Enter a valid Phone Number';
                          }
                          else{
                            return null; // Return null if the input is valid
                          }
                        },
                        controller: phoneController,
                        keyboardType:TextInputType.phone,
                        maxLength: 11,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
                          // hintText: "Mobile",
                          hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          counterText: '',
                        ),
                        style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                  child: Text("Email", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter an email';
                      }
                      if (value.length < 11) {
                        return 'Enter a valid email';
                      }
                      // if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      //     return 'Please enter a valid email';
                      //         }
                      else{
                        return null; // Return null if the input is valid
                      }
                    },
                    controller: emailAddressController,
                    keyboardType:TextInputType.text,
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
                        borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      counterText: '',
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                  child: Text("State", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),

                new GestureDetector(
                  onTap: (){
                    setState(() {

                      cityVisible = !cityVisible;
                      officeAddressVisible = !officeAddressVisible;

                    });

                    _openStateOfResidenceDialog();
                  },
                  child:  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select State of residence';
                        }
                        else{
                          return null; // Return null if the input is valid
                        }
                      },
                      controller: statesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),),
                        suffixIcon: Icon(Icons.keyboard_arrow_down, size: 25.0, color: HexColor("#C3BDBD")),
                        // hintText: "State of Residence",
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        hintStyle: TextStyle(color: HexColor("#969696"), fontSize: 14.0, fontWeight: FontWeight.normal),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      enabled: false,
                    ),
                  ),
                ),


                Visibility(
                  visible: cityVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                    child: Text("City", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                  ),
                ),

                Visibility(
                  visible: cityVisible,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {

                        officeAddressVisible = !officeAddressVisible;

                      });

                      _openCityDialog();
                    },
                    child:  Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select City';
                          }
                          else{
                            return null; // Return null if the input is valid
                          }
                        },
                        controller: cityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),),
                          suffixIcon: Icon(Icons.keyboard_arrow_down, size: 25.0, color: HexColor("#C3BDBD")),
                          // hintText: "State of Residence",
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                          hintStyle: TextStyle(color: HexColor("#969696"), fontSize: 14.0, fontWeight: FontWeight.normal),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                        enabled: false,
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: officeAddressVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                    child: Text(" Office Address", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                  ),
                ),

                Visibility(
                  visible: officeAddressVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Office Address';
                        }
                        else{
                          return null; // Return null if the input is valid
                        }
                      },
                      controller: homeAddressController,
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                        // hintText: "Office number and Street name",
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        counterText: '',
                      ),
                      style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                  child: Text("Password", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      if (value.length < 6) {
                        return 'must be at least 6 characters long';
                      }
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
                      // hintText: "New Password",
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                        borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      counterText: '',
                    ),
                    style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                  child: Text("Confirm Password", style: TextStyle(color: HexColor("#5B5B5B"), fontSize: 12.0, fontWeight: FontWeight.bold),),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      if (value.length < 6) {
                        return 'must be at least 6 characters long';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      else{
                        return null; // Return null if the input is valid
                      }
                    },
                    controller: confirmPasswordController,
                    obscureText: confirmPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      // labelText: "Last name",
                      // hintText: "Confirm Password",
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      suffixIcon: IconButton(icon: Icon(confirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
                        onPressed: (){
                          setState(() {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          },
                          );
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#969696"), width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("969696"), width: 1.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      counterText: '',
                    ),
                    style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
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
                            signUpCustomer();
                        }
                            : null, // Disable button if form is invalid() {
                          child: Text("Sign Up Customer", style: TextStyle(fontSize: 15.0),),
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

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 80.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text("already have an account?", style: TextStyle(color: HexColor("#212529"), fontSize: 15.0),),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return LogInPage();
                          }));
                        },
                        child: Text("Sign in", style: TextStyle(color: HexColor("#00B578"), fontSize: 15.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),




                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ]
    );
  }

  //         state of residence

  String? states;

  Future<void> _openStateOfResidenceDialog() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      builder: (BuildContext context) {
        return const StateOfResidenceDialog();
      },
    );

    // Handle the result from the bottom sheet
    if (result != null) {
      setState(() {
        states = result;
        updateStateTextValue();
        cityVisible = true;
        cityController.text = "";
      });
    }
    else {
      setState(() {
        cityVisible = false;
      });
    }
  }

  String? countryCode;
  String? flag;

  Future<void> _openCountryDialog() async {
    final result = await showModalBottomSheet<UserData>(
    // final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      builder: (BuildContext context) {
        return const CountryDialog();
      },
    );

    // Handle the result from the bottom sheet
    if (result != null) {
      setState(() {
        countryCode = result.phoneCode;
        flag = result.flag;
      });
    }
    else {
      setState(() {
        // cityVisible = false;
      });
    }
  }


  String? city;

  Future<void> _openCityDialog() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      builder: (BuildContext context) {
        return const CityDialog();
      },
    );

    // Handle the result from the bottom sheet
    if (result != null) {
      setState(() {
        city = result;
        updateCityTextValue();
        officeAddressVisible = true;
      });
    }
    else{
      setState(() {
        officeAddressVisible = false;
      });
    }
  }


}

