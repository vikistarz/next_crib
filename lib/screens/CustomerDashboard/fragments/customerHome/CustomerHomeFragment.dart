import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/CustomerDashboard/fragments/customerHome/model/AllPropertiesResponseModel.dart';
import 'package:http/http.dart' as http;
import 'package:next_crib/screens/propertyDetail/ui/propertydetail.dart';
import '../../../search/searchPage.dart';
import '../../../utilities/locationService.dart';
import '../../../webService/apiConstant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';



class CustomerHomeFragment extends StatefulWidget {
  const CustomerHomeFragment({super.key});

  @override
  State<CustomerHomeFragment> createState() => _CustomerHomeFragmentState();
}

class _CustomerHomeFragmentState extends State<CustomerHomeFragment> {

  bool isAllVisible = true;
  bool isTopVisible = true;
  bool isNearVisible = true;
  bool isMostVisible = true;
  bool isFlipCardVisible = true;
  bool isNearYouVisible = true;
  bool isMostRecentVisible = true;
  bool isViewAllVisible = true;
  bool isLoadingVisible = true;
  String locationMessage = "";
  double? longitude;
  double? latitude;


  @override
  void initState() {
    super.initState();
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
    final String apiUrl = ApiConstant.baseUri + 'properties/properties-within/10/center/$lat,$long/unit/km';
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
     fetchAllProperties();
     fetchNearByProperties(latitude!, longitude!);
      // items.add("Item ${items.length + 1}");
    });
  }


  void top() {
    isTopVisible = false;
    isAllVisible = false;
    isNearVisible = true;
    isMostVisible = true;
  }

  void near() {
    isNearVisible = false;
    isTopVisible = true;
    isAllVisible = false;
    isMostVisible = true;
  }

  void all() {
    isTopVisible = true;
    isAllVisible = true;
    isNearVisible = true;
    isMostVisible = true;
  }

  void most() {
    isMostVisible = false;
    isTopVisible = true;
    isAllVisible = false;
    isNearVisible = true;
  }



  void viewAll(){
    isViewAllVisible = true;
    isNearYouVisible = true;
    isMostRecentVisible = true;
    isFlipCardVisible = true;
  }

  void flipCard() {
    isFlipCardVisible = false;
    isNearYouVisible = true;
    isMostRecentVisible = true;
    isViewAllVisible = true;
  }

  void nearYou(){
    isNearYouVisible = false;
    isViewAllVisible = true;
    isMostRecentVisible = true;
    isFlipCardVisible = true;
  }

  void mostRecent(){
    isMostRecentVisible = false;
    isViewAllVisible = true;
    isFlipCardVisible = true;
    isNearYouVisible = true;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.white,
        backgroundColor: Colors.grey,
        displacement: 40.0,
        strokeWidth: 3.0,
        child: Scrollbar(
          // thumbVisibility: true,
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
                            child: Text("Location", style: TextStyle(
                              color: HexColor("#838383"),
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 5.0),
                                child: Image(image: AssetImage(
                                    "images/location_icon.png"),
                                    width: 15.0,
                                    height: 15.0),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, left: 5.0),
                                child: Text("Abule-Egba, Lagos",
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
                        padding: const EdgeInsets.only(top: 13.0, right: 10.0),
                        child: Icon(
                          Icons.notifications_none_rounded, size: 30.0,
                          color: Colors.black,),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 13.0, right: 16.0),
                        child: CircleAvatar(
                          backgroundColor: HexColor("#E3E3E3"),
                          child: Text("F", style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,),),
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
                              hintStyle: TextStyle(fontSize: 13.0,
                                  color: Colors.grey,
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
                                    all();
                                  });
                                },
                                child: Container(
                                  height: 32.0,
                                  width: 45.0,
                                  margin: EdgeInsets.only(left: 20.0),
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
                                visible: isAllVisible,
                                child: Container(
                                  height: 32.0,
                                  width: 45.0,
                                  margin: EdgeInsets.only(left: 20.0),
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

                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    top();
                                    flipCard();
                                  });
                                },
                                child: Container(
                                  height: 32.0,
                                  width: 95.0,
                                  margin: EdgeInsets.only(left: 20.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(
                                      "images/disabled_layout.png",),
                                        fit: BoxFit.fitHeight),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),),
                                  ),
                                  child: Center(
                                    child: Text("Top Rates", style: TextStyle(
                                        color: HexColor("#00B578"),
                                        fontSize: 14.0),),
                                  ),
                                ),
                              ),
                              //
                              Visibility(
                                visible: !isTopVisible,
                                child: Container(
                                  height: 32.0,
                                  width: 95.0,
                                  margin: EdgeInsets.only(left: 20.0),
                                  decoration: BoxDecoration(
                                    color: HexColor("#00B578"),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Center(child: Text("Top Rates",
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
                                visible: !isNearVisible,
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
                        ],
                      ),
                    ),
                  ),

                  Visibility(
                    visible: isAllVisible,
                    child: Container(
                      height: 550.0,
                      margin: EdgeInsets.only(
                          top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: FutureBuilder<List<AllPropertiesResponseModel>>(
                        future: fetchAllProperties(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:  SpinKitFadingCircle(
                                  color: HexColor("#212529"),
                                  size: 40.0,),);
                          } else if (snapshot.hasError) {
                            return Center(child: Text(
                                'Error: ${snapshot.error}'));
                          } else
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No properties found'));
                          } else {

                            final properties = snapshot.data!;

                            return GridView.builder(
                              padding: EdgeInsets.all(8.0),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of columns
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 3 / 4, // Width-to-height ratio
                              ),
                              itemCount: properties.length,
                              itemBuilder: (context, index) {
                                final property = properties[index];

                                String formattedAnnualCost = NumberFormat("#,##0").format(property.annualCost);

                                return GestureDetector(
                                  onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                               return PropertyDetailPage(ratingsAverage: property.ratingsAverage, ratingsQuantity: property.ratingsQuantity, propertyImages: property.propertyImages,
                                   coordinates: property.coordinates, createdAt: property.createdAt, ids: property.ids, title: property.title, stock: property.stock, dimension: property.dimension,
                                   annualCost: property.annualCost, totalPackage: property.totalPackage, description: property.description, category: property.category, state: property.state,
                                   city: property.city, location: property.location, sku: property.sku, id: property.id);
                             }));
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 7.5, right: 7.5, top: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: property.propertyImages
                                              .isNotEmpty
                                              ? Image.network(
                                            property.propertyImages.first,
                                            width: double.infinity,
                                            height: 120.0,
                                            fit: BoxFit.cover,
                                          ) : Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 40.0,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                          child: Text(property.title,style: TextStyle(color:HexColor("#181818"), fontWeight: FontWeight.bold, fontSize:12.20,),),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                                          child: Text("\₦${formattedAnnualCost}",style: TextStyle(color:HexColor("#00B578"), fontWeight: FontWeight.normal, fontSize:11,),),
                                        ),

                                        Padding(
                                            padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image(image: AssetImage("images/location_grey.png"),height: 12.2, width: 12.2,),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: Text(property.location,style: TextStyle(color:HexColor("#7F7F7F"), fontWeight: FontWeight.normal, fontSize:9.15,),),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),


                  Visibility(
                    visible: !isFlipCardVisible,
                    child: Container(
                      height: 500,
                      margin: EdgeInsets.only(top: 20.0),
                      color: Colors.black,
                    ),
                  ),


                  Visibility(
                    visible: !isNearYouVisible,
                    child: Container(
                     height: 550.0,
                      margin: EdgeInsets.only(
                          top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: FutureBuilder<List<AllPropertiesResponseModel>>(
                        future: fetchNearByProperties(latitude ?? 0, longitude ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:  SpinKitFadingCircle(
                                  color: HexColor("#212529"),
                                  size: 40.0,));
                          } else if (snapshot.hasError) {
                            return Center(child: Text(
                                'Error: ${snapshot.error}'));
                          } else
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No properties found'));
                          } else {
                            final properties = snapshot.data!;


                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: properties.length,
                              itemBuilder: (context, index){

                                final property = properties[index];
                                String formattedAnnualCost = NumberFormat("#,##0").format(property.annualCost);
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return PropertyDetailPage(ratingsAverage: property.ratingsAverage, ratingsQuantity: property.ratingsQuantity, propertyImages: property.propertyImages,
                                          coordinates: property.coordinates, createdAt: property.createdAt, ids: property.ids, title: property.title, stock: property.stock, dimension: property.dimension,
                                          annualCost: property.annualCost, totalPackage: property.totalPackage, description: property.description, category: property.category, state: property.state,
                                          city: property.city, location: property.location, sku: property.sku, id: property.id);
                                    }));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(top: 7.0, right: 15.0, left: 15.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          color: HexColor("#F5F5F5"), width: 1.5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 13.0, bottom: 13.0, left: 13.0),
                                            child: Container(
                                              child: property.propertyImages
                                                .isNotEmpty
                                                  ? Image.network(
                                              property.propertyImages.first,
                                              width: double.infinity,
                                              height: 120.0,
                                              fit: BoxFit.cover,
                                              ) : Container(
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 40.0,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                  ),
                                          ),

                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                                                    child: Icon(Icons.star, size: 17, color: HexColor("#FCD400"),),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                                                    child: Text(property.ratingsAverage.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13.0,),),
                                                  ),

                                                  Expanded(child: SizedBox()),

                                                  Container(
                                                    height: 20.0,
                                                    width: 67.0,
                                                    margin: EdgeInsets.only(top: 10.0, right: 10.0),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/disabled_layout.png",),fit: BoxFit.fitWidth),
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(12.0),),
                                                    ),
                                                    child: Center(
                                                      child: Text("Apartment", style: TextStyle(color: HexColor("#00B578"), fontSize: 10.0),),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, left: 10.0),
                                                child: Text(property.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0,),),
                                              ),

                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 7.0, left: 5.0),
                                                    child: Image(image: AssetImage("images/location_grey.png"), height: 12.2, width: 12.2,),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 7.0, left: 5.0),
                                                    child: Text(property.location + "," + " " + property.city + "," + " " + property.state, style: TextStyle(color: HexColor("838383"), fontWeight: FontWeight.normal, fontSize: 10.0,),),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [

                                                  Expanded(child: SizedBox()),

                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
                                                    child: Text("₦"+ formattedAnnualCost.toString() +"/Yearly",
                                                      style: TextStyle(color: HexColor("#00B578"), fontWeight: FontWeight.normal, fontSize: 12.0,),),
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
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: !isMostRecentVisible,
                    child: Container(
                      height: 500.0,
                      margin: EdgeInsets.only(top: 20.0),
                      color: Colors.amberAccent,
                    ),
                  )

                ]
            ),
          ),
        ),
      ),
    );
  }
}

