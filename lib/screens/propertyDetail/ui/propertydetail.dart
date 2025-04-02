import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:next_crib/screens/propertyDetail/fragments/galleryFragment.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CustomerDashboard/fragments/customerHome/model/AllPropertiesResponseModel.dart';
import '../../CustomerDashboard/fragments/customerHome/model/agentModel.dart';
import '../fragments/descriptionFragment.dart';
import '../fragments/reviewFragment.dart';
class PropertyDetailPage extends StatefulWidget {
   PropertyDetailPage({super.key, required this.propertyImages, required this.coordinates, required this.createdAt, required this.ids,
     required this.title, required this.stock, required this.dimension, required this.annualCost,
     required this.totalPackage, required this.description, required this.category,  required this.toilets,
     required this.agent, required this.bedroom, required this.state, required this.city,required this.location,
     required this.sku, required this.id, required this.fence, required this.water, required this.parkingSpace});

   // double ratingsAverage;
   // int ratingsQuantity;
   List<String> propertyImages;
   List<double> coordinates;
   String createdAt;
   String ids;
   String title;
   int stock;
   int dimension;
   int annualCost;
   int totalPackage;
   String description;
   String category;
   int bedroom;
   int toilets;
   Agent agent;
   String state;
   String city;
   String location;
   String sku;
   String id;
   String water;
   String fence;
   String parkingSpace;


  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {

  bool isDescriptionVisible =  true;
  bool isGalleryVisible = true;
  bool isReviewVisible = true;
  bool isVerifiedVisible = true;
  bool isNotVerifiedVisible = true;
  String phoneNumber = "08029425815";

  @override
  void initState() {
    super.initState();
    setState(() {
      showVerified();
    });
  }

  void showVerified(){
    if(widget.agent.isVerified == true){
      isVerifiedVisible = false;
    }
    else{
      isNotVerifiedVisible = false;
    }
  }


  void description(){
    isDescriptionVisible = true;
    isGalleryVisible =  true;
    isReviewVisible =  true;
  }

  void gallery(){
    isDescriptionVisible = false;
    isGalleryVisible =  false;
    isReviewVisible =  true;
  }

  void review(){
    isDescriptionVisible = false;
    isGalleryVisible =  true;
    isReviewVisible =  false;
  }


  void makePhoneCall() async {
    var callUri = Uri.parse("tel:$phoneNumber");
    try{
      launchUrl(callUri);
    }
    catch(e){
      debugPrint.toString();
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    String formattedAnnualCost = NumberFormat("#,##0").format(widget.annualCost);
    final capitalisedFirstName  = capitalize(widget.agent.firstName);
    final capitalisedLastName  = capitalize(widget.agent.lastName);
    final capitalisedTitle  = capitalize(widget.title);
    final capitalisedState  = capitalize(widget.state);
    final capitalisedCity  = capitalize(widget.city);
    final capitalisedLocation  = capitalize(widget.location);
    final capitalisedDescription  = capitalize(widget.description);

    return Scaffold(
      backgroundColor: HexColor("#F9F9F9"),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 270.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(widget.propertyImages.first), fit: BoxFit.fitWidth),
                  ),
                ),

                Container(
                  height: 270.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              margin: EdgeInsets.only(left: 16.0, top: 20.0),
                              decoration: BoxDecoration(
                                color: HexColor("#F5F5F5"),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Icon(Icons.arrow_back_ios, size: 20.0, color: Colors.black,),
                              ),
                            ),
                          ),

                          Expanded(child: SizedBox()),

                          Container(
                            height: 40.0,
                            width: 40.0,
                            margin: EdgeInsets.only(right: 16.0, top: 20.0),
                            decoration: BoxDecoration(
                              color: HexColor("#F5F5F5"),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Icon(Icons.favorite_outline_rounded, size: 20.0, color: Colors.black,),
                            ),
                          ),
                        ],
                      ),

                      Expanded(child: SizedBox()),

                        Row(
                          children: [
                            Expanded(child: SizedBox()),

                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                height: 45.0,
                                margin: EdgeInsets.only(right: 20.0, top: 20.0, bottom: 30.0),
                                decoration: BoxDecoration(
                                  color: HexColor("#F5F5F5"),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 7.0),
                                      child:  Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(15.0),
                                          image: DecorationImage(image: AssetImage("images/slider_image_three.png"),),
                                        ),
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Visibility(
                                              visible: !isVerifiedVisible,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 9.0, left: 5.0),
                                                child: Text("Verified",style: TextStyle(color:HexColor("#00B578"), fontWeight: FontWeight.normal, fontSize:9.0,),),
                                              ),
                                            ),

                                            Visibility(
                                              visible: !isNotVerifiedVisible,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 9.0, left: 5.0),
                                                child: Text("Not Verified",style: TextStyle(color:HexColor("#B50000"), fontWeight: FontWeight.normal, fontSize:9.0,),),
                                              ),
                                            ),

                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 0.0, left: 5.0, right: 10.0),
                                          child: Text(capitalisedFirstName + " " + capitalisedLastName,style: TextStyle(color:Colors.black, fontWeight: FontWeight.normal, fontSize:11.0,),),
                                        ),
                                      ],
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

            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left:15.0),
                    child: Icon(Icons.star, size: 17, color: HexColor("#FCD400"),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 3.0),
                        child: Text(widget.agent.ratingsAverage.toString() + "(${widget.agent.ratingsQuantity.toString()} review)", style: TextStyle(
                      color: HexColor("#838383"),
                      fontWeight: FontWeight.normal,
                      fontSize: 13.0,),),
                  ),

                  Expanded(child: SizedBox()),

                  Container(
                    height: 20.0,
                    width: 67.0,
                    margin: EdgeInsets.only(top: 10.0, right: 15.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/disabled_layout.png",),fit: BoxFit.fitWidth),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),),
                    ),
                    child: Center(child: Text("Apartment", style: TextStyle(color: HexColor("#00B578"), fontSize: 10.0),),
                    ),
                  ),
                ]
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 15.0),
              child: Text(capitalisedTitle,style: TextStyle(color:HexColor("#181818"), fontWeight: FontWeight.bold, fontSize:20.0,),),
            ),

            Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 12.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(image: AssetImage("images/location_grey.png"),height: 16.0, width: 16.0,),

                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(capitalisedLocation + "," + " " + capitalisedCity + "," + " " + capitalisedState,style: TextStyle(color:HexColor("#7F7F7F"), fontWeight: FontWeight.normal, fontSize:14.0,),),
                    ),
                  ],
                )
            ),

              Padding(
              padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                description();
                              });
                            },
                            child: Center(
                                  child: Text("Description", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),)
                            ),
                          ),

                          Visibility(
                            visible: isDescriptionVisible,
                            child: Center(
                              child: Text("Description", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0, fontWeight: FontWeight.normal),),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Expanded(
                      child: Stack(
                        children: [

                          Center(
                            child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    gallery();
                                  });
                                },
                              child: Text("Gallery", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),),),
                          ),

                          Center(
                                child: Visibility(
                                  visible: !isGalleryVisible,
                                  child: Text("Gallery", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0, fontWeight: FontWeight.normal),
                                  ),
                                ),
                          ),

                        ],
                      ),
                    ),

                    Expanded(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                              review();
                              });
                            },
                            child: Center(
                              child: Text("Review", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),),
                            ),
                          ),

                          Center(
                            child: Visibility(
                                visible: !isReviewVisible,
                                child: Text("Review", style: TextStyle(color: HexColor("#00B578"), fontSize: 14.0, fontWeight: FontWeight.normal),)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child:  Container(
                            height: 2.0,
                            color: HexColor("#D6E9FC"),
                          ),
                        ),

                        Visibility(
                          visible: isDescriptionVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child:  Container(
                              height: 2.0,
                              color: HexColor("#00B578"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child:  Container(
                            height: 2.0,
                            color: HexColor("#D6E9FC"),
                          ),
                        ),

                        Visibility(
                          visible: !isGalleryVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child:  Container(
                              height: 2.0,
                              color: HexColor("#00B578"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child:  Container(
                            height: 2.0,
                            color: HexColor("#D6E9FC"),
                          ),
                        ),

                        Visibility(
                          visible: !isReviewVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child:  Container(
                              height: 2.0,
                              color: HexColor("#00B578"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25.0,
            ),

            Container(
              margin: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Stack(
                children: [
                  Visibility(
                    visible:  isDescriptionVisible,
                    child: DescriptionFragment(description: capitalisedDescription, createdAt: widget.createdAt, totalPackage: widget.totalPackage,
                           dimension: widget.dimension, bedroom: widget.bedroom, agent: widget.agent, toilets: widget.toilets, fence: widget.fence,
                           water: widget.water, parkingSpace: widget.parkingSpace),
                  ),

                  Visibility(
                    visible:  !isGalleryVisible,
                    child: GalleryFragment(propertyImages: widget.propertyImages),
                  ),

                  Visibility(
                    visible:  !isReviewVisible,
                    child: ReviewFragment(agent: widget.agent),
                  ),
                ],
              ),
            ),
        ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 85.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: HexColor("#C3BDBD"),
                blurRadius: 0.5,
                spreadRadius: 0.4,
                offset: Offset(1,1),
              ),
            ]
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 16.0),
                      child: Text("Price", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 16.0),
                        child: Text("₦"+formattedAnnualCost.toString(), style: TextStyle(color: HexColor("#00B578"), fontSize: 20.0, fontWeight: FontWeight.normal),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("/Yearly", style: TextStyle(color: HexColor("#838383"), fontSize: 14.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  makePhoneCall();
                },
                child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    color: HexColor("#00B578"),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.phone, color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Text("Inspect Now", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
