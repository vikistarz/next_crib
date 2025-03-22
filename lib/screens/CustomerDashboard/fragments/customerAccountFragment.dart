import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../database/appPrefHelper.dart';
import '../../database/saveValues.dart';
import '../../dialogs/errorMessageDialog.dart';
import '../../dialogs/logOutDialog.dart';
import '../../webService/apiConstant.dart';
import '../ui/editCustomerprofile.dart';
class CustomerAccountFragment extends StatefulWidget {
  const CustomerAccountFragment({super.key});

  @override
  State<CustomerAccountFragment> createState() => _CustomerAccountFragmentState();
}

class _CustomerAccountFragmentState extends State<CustomerAccountFragment> {

  String errorMessage = "";
  String firstName = "";
  String lastName = "";
  String emailAddress = "";
  String phoneNumber = "";
  String city = "";
  String state = "";
  String displayPhoto = "";
  bool isLoadingVisible = true;
  bool isProfileVisible = true;



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

        // Update the state with the extracted data
        setState(() {
           isProfileVisible = !isProfileVisible;


           firstName = first_name;
           lastName = last_name;
           emailAddress = email_address;
           phoneNumber = phone_number;
           city = citi;
           state = states;
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

  // void saveProfile() async {
  //   SaveValues mySaveValues = SaveValues();
  //   await mySaveValues.saveString(AppPreferenceHelper.FIRST_NAME, firstName);
  //   await mySaveValues.saveString(AppPreferenceHelper.LAST_NAME, lastName);
  //   await mySaveValues.saveString(AppPreferenceHelper.EMAIL_ADDRESS, emailAddress);
  //   await mySaveValues.saveString(AppPreferenceHelper.PHONE_NUMBER, phoneNumber);
  //   await mySaveValues.saveString(AppPreferenceHelper.HOME_ADDRESS, homeAddress);
  // }


  void _openLogOutDialog(){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder: (ctx) => LogOutDialog());
  }




  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }



  @override
  Widget build(BuildContext context) {
    final capitalisedFirstName  = capitalize(firstName);
    final capitalisedLastName  = capitalize(lastName);
    final capitalisedEmail  = capitalize(emailAddress);
    final capitalisedPhone  = capitalize(phoneNumber);
    final capitalisedState  = capitalize(state);
    final capitalisedCity  = capitalize(city);

    String firstNameFirstLetter = capitalisedFirstName.isNotEmpty ? capitalisedFirstName[0].toUpperCase() : '';
    String lastNameFirstLetter = capitalisedLastName.isNotEmpty ? capitalisedLastName[0].toUpperCase() : '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        backgroundColor: Colors.grey,
        displacement: 40.0,
        strokeWidth: 3.0,
        child: Stack(
          children: [

            Visibility(
              visible: !isProfileVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 0.0),
                      child: Text("Account", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.0,
                        margin: const EdgeInsets.only(top: 35.0, left: 20.0),
                        child: Text(capitalisedFirstName + " " + capitalisedLastName, style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),),
                      ),


                      Expanded(child: SizedBox()),

                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, top: 25.0),
                        child:  CircleAvatar(
                          backgroundColor: HexColor("#403C3E"),
                          radius: 40.0,
                           child: Text(firstNameFirstLetter + lastNameFirstLetter, style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.email, size: 25.0, color: HexColor("#838383"),),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(capitalisedEmail, style: TextStyle(color: HexColor("#838383"), fontSize: 15.0, fontWeight: FontWeight.normal),),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.phone, size: 25.0, color: HexColor("#838383"),),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(capitalisedPhone, style: TextStyle(color: HexColor("#838383"), fontSize: 15.0, fontWeight: FontWeight.normal),),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on, size: 25.0, color: HexColor("#838383"),),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(capitalisedCity + "," + " " +capitalisedState, style: TextStyle(color: HexColor("#838383"), fontSize: 15.0, fontWeight: FontWeight.normal),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Expanded(child: SizedBox()),

                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return EditCustomerProfilePage();

                              }));
                            },
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.arrow_forward_ios, size: 18.0, color: HexColor("#403C3E"),),
                            ),
                          ),
                        ]
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      _openLogOutDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 10.0),
                      child: Text("Log out", style: TextStyle(color: HexColor("#838383"), fontSize: 15.0, fontWeight: FontWeight.normal),),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Visibility(
                visible: !isLoadingVisible,
                child: SpinKitFadingCircle(
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
