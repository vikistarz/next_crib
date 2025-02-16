import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../propertyDetail/ui/propertydetail.dart';
import '../../../../webService/apiConstant.dart';
import '../model/AllPropertiesResponseModel.dart';
class NearByPropertiesPage extends StatefulWidget {
  const NearByPropertiesPage({super.key});

  @override
  State<NearByPropertiesPage> createState() => _NearByPropertiesPageState();
}

class _NearByPropertiesPageState extends State<NearByPropertiesPage> {

  bool allSwiped = false;
  String locationMessage = "";
  double? longitude;
  double? latitude;



  Future<AllPropertiesResponseModel> fetchNearByProperties(double lat, double long) async {
    final String apiUrl = ApiConstant.baseUri + 'properties/properties-within/1000/center/$lat,$long/unit/km';
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
        child: allSwiped
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 180.0),
              Text("No more available properties near by!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    allSwiped = false;
                  });
                },
                child: Text("Reload Properties"),
              )
            ],
          ),
        )
            : Center(
          child: SizedBox(
            height: 600,
            child: FutureBuilder(
                future: fetchNearByProperties(latitude ?? 0, longitude ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: SpinKitFadingCircle(
                          color: HexColor("#212529"),
                          size: 40.0,));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(
                        'Error: ${snapshot.error}'));
                  } else
                  if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                    return Center(child: Text('No properties found'));
                  } else {

                    final properties = snapshot.data!;

                    return CardSwiper(
                      cardsCount: properties.items.length,
                      numberOfCardsDisplayed: 3, // Show 3 cards instead of 2
                      // scale: 0.98, // Adjusts the size of the stacked cards
                      // backCardOffset: Offset(0, 25), // Moves the cards slightly apart
                      onSwipe: (previousIndex, targetIndex, direction) {
                        if (targetIndex == properties.items.length - properties.items.length) {
                          setState(() {
                            allSwiped = true;
                          });
                        }
                        return true;
                      },
                      cardBuilder: (context, index, percentThresholdX,
                          percentThresholdY) {
                      final property = properties.items[index];
                      String formattedAnnualCost = NumberFormat("#,##0").format(property.annualCost);

                        return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return PropertyDetailPage(propertyImages: property.propertyImages,
                                        coordinates: property.coordinates, createdAt: property.createdAt, ids: property.ids, title: property.title, stock: property.stock, dimension: property.dimension,
                                        annualCost: property.annualCost, totalPackage: property.totalPackage, description: property.description, category: property.category, state: property.state,
                                        city: property.city, location: property.location, sku: property.sku, id: property.id, toilets: property.toilets, agent: property.agent, bedroom: property.bedroom);
                                  }));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400.0,
                                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 3.0, right: 3.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withAlpha(100),
                                            blurRadius: 10.0),
                                      ]
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(1.0),
                                    // decoration: BoxDecoration(
                                    //   // color: Colors.white,
                                    //     borderRadius: BorderRadius.circular(
                                    //         15.0),
                                    //     image: DecorationImage(
                                    //         image: AssetImage(
                                    //             "images/new_house.png"),
                                    //         fit: BoxFit.fill)
                                    // ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: property.propertyImages
                                          .isNotEmpty
                                          ? Image.network(
                                        property.propertyImages.first,
                                        // width: double.infinity,
                                        // height: 120.0,
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
                                ),
                              ),



                              Container(
                                height: 400.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 80.0, left: 30.0),
                                      child: Text("₦"+ formattedAnnualCost.toString() , style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.0, left: 30.0),
                                      child: Text(property.title, style: TextStyle(color: Colors.white, fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.0, left: 30.0),
                                          child: Text(property.location + "," + " " + property.city + "," + " " + property.state,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),

                                        Expanded(
                                          child: SizedBox(),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Icon(Icons.star,
                                            color: HexColor("#FFB400"),
                                            size: 16.0,),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30.0),
                                          child: Text(property.agent.ratingsAverage.toString(), style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ]
                        );
                      },
                    );
                  }
                }
          ),
        ),
        ),
    );
  }
}
