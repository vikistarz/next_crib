import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../../propertyDetail/ui/propertydetail.dart';
import '../../../../webService/apiConstant.dart';
import '../model/AllPropertiesResponseModel.dart';
import '../model/recentPropertiesResponseModel.dart';
class RecentPropertiesPage extends StatefulWidget {
  const RecentPropertiesPage({super.key});

  @override
  State<RecentPropertiesPage> createState() => _RecentPropertiesPageState();
}

class _RecentPropertiesPageState extends State<RecentPropertiesPage> {

  Future<RecentPropertiesResponseModel> fetchRecentProperties() async {
    final String apiUrl = ApiConstant.getRecentProperties;
    final response = await http.get(
        Uri.parse(apiUrl));

    print("request: " + response.toString());
    print(response.statusCode);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return RecentPropertiesResponseModel.fromJson(jsonResponse);
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
          top: 20.0, left: 10.0, right: 10.0),
      child: FutureBuilder<RecentPropertiesResponseModel>(
        future: fetchRecentProperties(),
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
          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text('No properties found'));
          } else {
            final properties = snapshot.data!;


            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: properties.items.length,
              shrinkWrap: true, // Important!
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){

                final property = properties.items[index];
                String formattedAnnualCost = NumberFormat("#,##0").format(property.annualCost);
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return PropertyDetailPage(propertyImages: property.propertyImages,
                        coordinates: property.coordinates, createdAt: property.createdAt, ids: property.ids, title: property.title, stock: property.stock, dimension: property.dimension,
                        annualCost: property.annualCost, totalPackage: property.totalPackage, description: property.description, category: property.category, state: property.state,
                        city: property.city, location: property.location, sku: property.sku, id: property.id, toilets: property.toilets, agent: property.agent, bedroom: property.bedroom,
                        water: property.water, fence: property.fence, parkingSpace: property.parkingSpace);
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
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
                                    child: Text(property.agent.ratingsAverage.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13.0,),),
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
    );
  }
}
