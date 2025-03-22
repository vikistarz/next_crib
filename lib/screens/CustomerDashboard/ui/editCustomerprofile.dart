import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../../database/appPrefHelper.dart';
import '../../database/saveValues.dart';
import '../../dialogs/errorMessageDialog.dart';
import '../../dialogs/successMessageDialog.dart';
import '../../signUp/signUpAgent/dialogs/cityDialog.dart';
import '../../signUp/signUpAgent/dialogs/stateOfResidenceDialog.dart';
import '../../webService/apiConstant.dart';
class EditCustomerProfilePage extends StatefulWidget {
  const EditCustomerProfilePage({super.key});

  @override
  State<EditCustomerProfilePage> createState() => _EditCustomerProfilePageState();
}

class _EditCustomerProfilePageState extends State<EditCustomerProfilePage> {

  final _formKey = GlobalKey<FormState>();
  bool isLoadingVisible = true;
  bool isSaveLoadingVisible = true;
  String token = "";
  String errorMessage = "";
  String State = "";
  String City = "";
  bool _isButtonEnabled = false;
  bool cityVisible = false;
  bool officeAddressVisible = false;

  // File? _image;
  String firstName = "";
  String lastName = "";
  String emailAddress = "";
  String phoneNumber = "";
  String displayPhoto = "";
  bool isProfileVisible = true;


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

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();



  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
    phoneController.dispose();
    officeAddressController.dispose();

    super.dispose();
  }

  void loading(){
    setState(() {
      isLoadingVisible = false;
      isSaveLoadingVisible = false;
    });
  }

  void isNotLoading(){
    setState(() {
      isLoadingVisible = true;
      isSaveLoadingVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }



  Future<void> _refresh() async {
    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    // Add a new item to the list after refreshing
    setState(() {
      fetchUserData();
      // items.add("Item ${items.length + 1}");
    });
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }


  Future<void> fetchUserData() async {
    loading();

    SaveValues mySaveValues = SaveValues();
    String? token = await mySaveValues.getString(AppPreferenceHelper.AUTH_TOKEN);
    String? customerId = await mySaveValues.getString(AppPreferenceHelper.CUSTOMER_ID);
    final String apiUrl = ApiConstant.baseUri + 'customers/$customerId';

    try {
      final response = await http.get(
          Uri.parse(apiUrl),

        headers:<String, String>{
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },);

      print("request: " + response.toString());
      print(response.statusCode);


      if (response.statusCode == 200) {
        isNotLoading();
        // Parse the JSON response
        final data = json.decode(response.body);
        print('Response Body: ${response.body}');

        // Extract specific fields from the JSON
        String first_name = data['data']["data"]['firstName'];
        String last_name = data['data']["data"]['lastName'];
        String email_address = data['data']["data"]['email'];
        String phone_number = data['data']["data"]['phone'];
        String citi = data['data']["data"]['city'];
        String states = data['data']["data"]['state'];
        String address = data['data']["data"]['address'];


        // Update the state with the extracted data
        setState(() {
          isProfileVisible = !isProfileVisible;

          final capitalisedFirstName  = capitalize(first_name);
          final capitalisedLastName  = capitalize(last_name);
          final capitalisedEmail  = capitalize(email_address);
          final capitalisedPhone  = capitalize(phone_number);
          final capitalisedState  = capitalize(states);
          final capitalisedCity  = capitalize(citi);
          final capitalizeAddress = capitalize(address);

          firstNameController.text = capitalisedFirstName;
          lastNameController.text = capitalisedLastName;
          emailAddressController.text = capitalisedEmail;
          phoneController.text = capitalisedPhone;
          City = capitalisedCity;
          State = capitalisedState;
          officeAddressController.text = capitalizeAddress;

          // saveProfile();
        });

      } else {
        isNotLoading();
        print('Response Body: ${response.body}');
        // If the response code is not 200, show error
        final data = json.decode(response.body);

        // Extract specific fields from the JSON
        errorMessage = data['message'];
        setState(() {
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
        });
      }
    } catch (error) {
      // Handle any exceptions during the HTTP request
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



  void updateStateTextValue(){
    setState(() {
      State = states == null ? "" : "$states";
    });
  }

  void updateCityTextValue(){
    setState(() {
      City = city == null ? "" : "$city";
    });
  }

  Future<void> editCustomerProfile() async {
    loading();
    SaveValues mySaveValues = SaveValues();
    String? token = await mySaveValues.getString(AppPreferenceHelper.AUTH_TOKEN);
    const String apiUrl = ApiConstant.editCustomerProfile;

    try {
      final response = await http.patch(Uri.parse(apiUrl),
        headers:<String, String>{
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
          "email": emailAddressController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "state": State,
          "city": City,
          "address": officeAddressController.text,
          "phone": phoneController.text,
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
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return SuccessMessageDialog(
                  content: 'Profile Updated Successfully',
                  onButtonPressed: () {
                    Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context){
                    //   return const AgentEmailVerificationPage();
                    // }));
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: Colors.white,
        leading:  new GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 16.0, right: 20.0),
            width: 16.0,
            height: 18.0,
            child: Image(image: AssetImage("images/arrow_back.png"),),
          ),
        ),
      ),
      body: RefreshIndicator(
      onRefresh: _refresh,
      color: Colors.white,
      backgroundColor: Colors.grey,
      displacement: 40.0,
      strokeWidth: 3.0,
      child:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Visibility(
                visible: !isLoadingVisible,
                child: SpinKitFadingCircle(
                  color: HexColor("#212529"),
                  size: 40.0,
                ),
              ),
            ),


            Visibility(
              visible: !isProfileVisible,
              child: Form(
                        key: _formKey,
                        onChanged: _validateFormField,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                      child: Text("Contact information", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                    ),


                   Row(
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                         child: Text("First name", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                       ),

                       Padding(
                         padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                         child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                       ),
                     ],
                   ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
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

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("Last name", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                          child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
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


                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("Phone Number", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                          child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                      child: TextFormField(
                        validator: (value) {
                          final regex = RegExp(r'^[+-]?\d+(\.\d+)?$');
                if (value == null || value.isEmpty) {
                  return 'Enter phone Number';
                }
                if (value.length < 11) {
                  return 'Enter Phone Number';
                }
                if (!regex.hasMatch(value)) {
                  return 'Enter Phone Number';
                }
                else{
                  return null; // Return null if the input is valid
                          }
                        },
                        controller: phoneController,
                        keyboardType:TextInputType.phone,
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

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("Email Address", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                          child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
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

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("State of residence", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                          child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                          child: Text(State, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: HexColor("#212529"),),),
                        ),

                        Expanded(child: SizedBox()),

                        GestureDetector(
                          onTap: (){
                            setState(() {

                              cityVisible = !cityVisible;
                              officeAddressVisible = !officeAddressVisible;

                            });

                            _openStateOfResidenceDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, right: 20.0),
                            child: Text("Change", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("City", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                          child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                          child: Text(City, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: HexColor("#212529"),),),
                        ),

                        Expanded(child: SizedBox()),

                        GestureDetector(
                          onTap: (){
                            setState(() {

                              officeAddressVisible = !officeAddressVisible;

                            });

                            _openCityDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, right: 20.0),
                            child: Text("Change", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("Street Address", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                          child: Text("*", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#E30909"),),),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Office Address';
                          }
                          else{
                            return null; // Return null if the input is valid
                          }
                        },
                        controller: officeAddressController,
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

                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 70.0),
                          child: Center(
                            child: ElevatedButton(onPressed: (){
                              editCustomerProfile();

                            }, // Disable button if form is invalid() {
                              child: Text("Save", style: TextStyle(fontSize: 15.0),),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                                minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
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

                        Visibility(
                          visible: !isSaveLoadingVisible,
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 70.0),
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

                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
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
            )
          ],
        ),
      ),
      ),
    );
  }

  String? states;

  Future<void> _openStateOfResidenceDialog() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      builder: (BuildContext context) {
        return StateOfResidenceDialog();
      },
    );

    // Handle the result from the bottom sheet
    if (result != null) {
      setState(() {
        states = result;
        updateStateTextValue();
        cityVisible = true;
        // cityController.text = "";
      });
    }
    else {
      setState(() {
        cityVisible = false;
      });
    }
  }

  String? city;

  Future<void> _openCityDialog() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      builder: (BuildContext context) {
        return CityDialog();
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
