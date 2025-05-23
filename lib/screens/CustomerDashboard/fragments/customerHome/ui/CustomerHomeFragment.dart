import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/CustomerDashboard/fragments/customerHome/fragment/allProperties.dart';
import 'package:next_crib/screens/CustomerDashboard/fragments/customerHome/fragment/recentProperties.dart';
import '../../../../database/appPrefHelper.dart';
import '../../../../database/saveValues.dart';
import '../../../../dialogs/errorMessageDialog.dart';
import '../../../ui/editCustomerprofile.dart';
import '../fragment/nearByProperties.dart';
import 'package:next_crib/screens/CustomerDashboard/fragments/customerHome/model/AllPropertiesResponseModel.dart';
import 'package:http/http.dart' as http;
import '../../../../search/searchPage.dart';
import '../../../../utilities/locationService.dart';
import '../../../../webService/apiConstant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class CustomerHomeFragment extends StatefulWidget {
  const CustomerHomeFragment({super.key});

  @override
  State<CustomerHomeFragment> createState() => _CustomerHomeFragmentState();
}

class _CustomerHomeFragmentState extends State<CustomerHomeFragment> {

  bool isAllVisible = true;
  bool isViewAllVisible = true;

  bool isNearVisible = true;
  bool isNearYouVisible = true;

  bool isMostVisible = true;
  bool isMostRecentVisible = true;

  bool isLoadingVisible = true;
  String locationMessage = "";
  String firstName = "";
  String errorMessage = "";
  double? longitude;
  double? latitude;


  @override
  void initState() {
    super.initState();
    fetchUserData();
    showLocation();
  }



  Future<void> showLocation() async {
    bool hasPermission = await LocationService
        .checkAndRequestLocationPermission(context);
    if (hasPermission) {
      // Fetch location or proceed with your logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location enabled and permission granted!')),

      );
      getLogLat();
      fetchNearByProperties(latitude!, longitude!);
    }
  }

  Future<void> getLogLat() async {
    PermissionStatus status = await Permission.location.request();

    if(status.isGranted) {
      //get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        latitude = position.latitude;
        longitude = position.longitude;

      });
    }
    else{
      setState(() {
        locationMessage = "Location permission is required.";
      });
    }
  }

  Future<void> fetchUserData() async {
    // loading();

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
        // isNotLoading();
        // Parse the JSON response
        final data = json.decode(response.body);
        print('Response Body: ${response.body}');

        // Extract specific fields from the JSON
        String first_name = data['data']["data"]['firstName'];

        // Update the state with the extracted data
        setState(() {

          firstName = first_name;

        });

      } else {

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
                      // isNotLoading();
                    },
                  );
                });
          });
        });
      }
    } catch (error) {
      // Handle any exceptions during the HTTP request
      // isNotLoading();
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
                  // isNotLoading();
                },
              );
            });
      });
    }
  }


  Future<List<AllPropertiesResponseModel>> fetchAllProperties() async {
    const String apiUrl = ApiConstant.getAllProperties;
    final response = await http.get(
        Uri.parse(apiUrl));

    print("request: " + response.toString());
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');

      final List<dynamic> data = json.decode(response.body)['data']['data'];
      return data.map((json) => AllPropertiesResponseModel.fromJson(json))
          .toList();

      // final data = json.decode(response.body);
      // final List propertiesJson = data['data']['data'];
      // return propertiesJson.map((json) => AllPropertiesResponseModel.fromJson(json)).toList();
    }
    else {
      print('Response Body: ${response.body}');
      throw Exception('Failed to load properties');
    }
  }

  Future<List<AllPropertiesResponseModel>> fetchNearByProperties(double lat, double long) async {
    final String apiUrl = ApiConstant.baseUri + 'properties/properties-within/1000/center/$lat,$long/unit/km';
    print(apiUrl);
    final response = await http.get(
        Uri.parse(apiUrl));

    print("request: " + response.toString());
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');

      final List<dynamic> data = json.decode(response.body)['data']['data'];
      return data.map((json) => AllPropertiesResponseModel.fromJson(json))
          .toList();

      // final data = json.decode(response.body);
      // final List propertiesJson = data['data']['data'];
      // return propertiesJson.map((json) => AllPropertiesResponseModel.fromJson(json)).toList();
    }
    else {
      print('Response Body: ${response.body}');
      throw Exception('Failed to load properties');
    }
  }



  Future<void> _refresh() async {
    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    // Add a new item to the list after refreshing
    setState(() {
      fetchUserData();
      fetchAllProperties();
      fetchNearByProperties(latitude!, longitude!);
      // items.add("Item ${items.length + 1}");
    });
  }

  void near() {
    isAllVisible = true;
    isNearVisible = true;
    isMostVisible = true;
  }

  void all() {
    isNearVisible = false;
    isAllVisible = false;
    isMostVisible = true;
  }

  void most() {
    isMostVisible = false;
    isAllVisible = true;
    isNearVisible = false;
  }

  void nearYou(){
    isViewAllVisible = true;
    isNearYouVisible = true;
    isMostRecentVisible = true;
  }

  void viewAll(){
    isNearYouVisible = false;
    isViewAllVisible = true;
    isMostRecentVisible = true;
  }

  void mostRecent(){
    isMostRecentVisible = false;
    isViewAllVisible = true;
    isNearYouVisible = false;
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // ScrollController controller = ScrollController();
  // double topContainer = 0;


  @override
  Widget build(BuildContext context) {
    final capitalisedFirstName  = capitalize(firstName);
    String firstNameFirstLetter = capitalisedFirstName.isNotEmpty ? capitalisedFirstName[0].toUpperCase() : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        backgroundColor: Colors.grey,
        displacement: 40.0,
        strokeWidth: 3.0,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 16.0),
                          child: Text("Hi,", style: TextStyle(color: HexColor("#838383"), fontWeight: FontWeight.normal, fontSize: 14.0,),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                            //   child: Image(image: AssetImage("images/location_icon.png"), width: 15.0, height: 15.0),
                            // ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 15.0),
                              child: Text(capitalisedFirstName,
                                style: TextStyle(color: HexColor("#1D1D1D"),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,),),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Expanded(
                      child: SizedBox(),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, right: 10.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Icon(Icons.notifications_none_rounded, size: 30.0, color: Colors.black,),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 15.0),
                            height: 13.0,
                            width: 14.0,
                            decoration: BoxDecoration(
                              color: HexColor("#E30909"),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(child: Text("0", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 7.0,),)),
                          )
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return EditCustomerProfilePage();

                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0, right: 16.0),
                        child: CircleAvatar(
                          backgroundColor: HexColor("#E3E3E3"),
                          child: Text(firstNameFirstLetter, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16.0,),),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.0,
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          // controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("#F5F5F5"),
                            prefixIcon: Icon(
                              Icons.search, color: HexColor("#C3BDBD"),
                              size: 22.0,),
                            hintText: "Search here",
                            hintStyle: TextStyle(fontSize: 13.0, color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            // Customize label color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: HexColor("#F5F5F5"), width: 0.0),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Border color when not focused
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: HexColor("#F5F5F5"), width: 0.0),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Same border color when focused
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: HexColor("#F5F5F5"), width: 0.0),
                              borderRadius: BorderRadius.circular(
                                  10.0), // General border color
                            ),
                          ),
                          // onChanged: (query) => _filterItems(query),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) {
                          return SearchPage();
                        }));
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        margin: const EdgeInsets.only(top: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                          color: HexColor("#F5F5F5"),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Image(
                                image: AssetImage("images/filter.png"),
                                width: 24.0,
                                height: 24.0,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Stack(
                          children: [

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  near();
                                  nearYou();
                                  showLocation();
                                });
                              },
                              child: Container(
                                height: 32.0,
                                width: 100.0,
                                margin: EdgeInsets.only(left: 20.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(
                                    "images/disabled_layout.png",),
                                      fit: BoxFit.fitHeight),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text("Near You", style: TextStyle(
                                        color: HexColor("#00B578"),
                                        fontSize: 13.0),),

                                  ),
                                ),
                              ),
                            ),
                            //
                            Visibility(
                              visible: isNearVisible,
                              child: Container(
                                height: 32.0,
                                width: 100.0,
                                margin: EdgeInsets.only(left: 20.0),
                                decoration: BoxDecoration(
                                  color: HexColor("#00B578"),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(child: Text("Near You",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),)),
                              ),
                            ),

                          ],
                        ),

                        Stack(
                          children: [

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  most();
                                  mostRecent();
                                });
                              },
                              child: Container(
                                height: 32.0,
                                width: 112.0,
                                margin: EdgeInsets.only(
                                    left: 16.0, right: 20.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(
                                    "images/disabled_layout.png",),
                                      fit: BoxFit.fitHeight),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),),
                                ),
                                child: Center(
                                  child: Text("Most Recent", style: TextStyle(
                                      color: HexColor("#00B578"),
                                      fontSize: 14.0),),
                                ),
                              ),
                            ),
                            //

                            Visibility(
                              visible: !isMostVisible,
                              child: Container(
                                height: 32.0,
                                width: 112.0,
                                margin: EdgeInsets.only(
                                    left: 16.0, right: 20.0),
                                decoration: BoxDecoration(
                                  color: HexColor("#00B578"),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),),
                                ),
                                child: Center(child: Text("Most Recent",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),)),
                              ),
                            ),
                          ],
                        ),

                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  all();
                                  viewAll();
                                });
                              },
                              child: Container(
                                height: 32.0,
                                width: 45.0,
                                margin: EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(
                                    "images/disabled_layout.png",),
                                      fit: BoxFit.fitHeight),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),),
                                ),
                                child: Center(
                                  child: Text("All", style: TextStyle(
                                      color: HexColor("#00B578"),
                                      fontSize: 14.0),),
                                ),
                              ),
                            ),
                            //
                            Visibility(
                              visible: !isAllVisible,
                              child: Container(
                                height: 32.0,
                                width: 45.0,
                                margin: EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                  color: HexColor("#00B578"),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(child: Text("All",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),)),
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),

                Visibility(
                  visible: isNearYouVisible,
                  child: NearByPropertiesPage(),
                ),

                Visibility(
                  visible: !isAllVisible,
                  child: ViewAllPropertiesPage(),
                ),

                Visibility(
                  visible: !isMostVisible,
                  child: RecentPropertiesPage(),
                ),

              ]
          ),
        ),
      ),
    );
  }
}

