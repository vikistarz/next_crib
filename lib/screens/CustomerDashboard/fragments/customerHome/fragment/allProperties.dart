import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../propertyDetail/ui/propertydetail.dart';
import '../../../../utilities/locationService.dart';
import '../../../../webService/apiConstant.dart';
import '../model/AllPropertiesResponseModel.dart';
class ViewAllPropertiesPage extends StatefulWidget {
  const ViewAllPropertiesPage({super.key});

  @override
  State<ViewAllPropertiesPage> createState() => _ViewAllPropertiesPageState();
}

class _ViewAllPropertiesPageState extends State<ViewAllPropertiesPage> {

  String locationMessage = "";
  double? longitude;
  double? latitude;

  // @override
  // void initState() {
  //   super.initState();
  //   showLocation();
  // }
  //
  // Future<void> showLocation() async {
  //   bool hasPermission = await LocationService
  //       .checkAndRequestLocationPermission(context);
  //   if (hasPermission) {
  //     // Fetch location or proceed with your logic
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Location enabled and permission granted!')),
  //     );
  //   }
  // }
  //
  // Future<void> getLogLat() async {
  //   PermissionStatus status = await Permission.location.request();
  //
  //   if(status.isGranted) {
  //     //get current location
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //
  //     setState(() {
  //       locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
  //       latitude = position.latitude;
  //       longitude = position.longitude;
  //     });
  //   }
  //   else{
  //     setState(() {
  //       locationMessage = "Location permission is required.";
  //     });
  //   }
  // }

  Future<AllPropertiesResponseModel> fetchAllProperties() async {
    const String apiUrl = ApiConstant.getAllProperties;
      final response = await http.get(
          Uri.parse(apiUrl));

      print("request: " + response.toString());
      print(response.statusCode);


    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return AllPropertiesResponseModel.fromJson(jsonResponse);
    }
    else {
      print('Response Body: ${response.body}');
      throw Exception('Failed to load properties');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.0,
      margin: EdgeInsets.only(
          top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
      child: FutureBuilder<AllPropertiesResponseModel>(
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
          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text('No properties found'));
          } else {

          }

             final properties = snapshot.data!;

            return GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 4, // Width-to-height ratio
              ),
              itemCount: properties.items.length,
              itemBuilder: (context, index) {
                final property = properties.items[index];

                String formattedAnnualCost = NumberFormat("#,##0").format(property.annualCost);

                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return PropertyDetailPage(propertyImages: property.propertyImages,
                          coordinates: property.coordinates, createdAt: property.createdAt, ids: property.ids, title: property.title, stock: property.stock, dimension: property.dimension,
                          annualCost: property.annualCost, totalPackage: property.totalPackage, description: property.description, category: property.category,
                          bedroom: property.bedroom, toilets: property.toilets, agent: property.agent, state: property.state,
                          city: property.city, location: property.location, sku: property.sku, id: property.id );
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: property.propertyImages
                                .isNotEmpty
                                ? Image.network(
                              property.propertyImages.first,
                              width: double.infinity,
                              height: 120.0,
                              fit: BoxFit.fill,
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
      ),
    );
  }
}
