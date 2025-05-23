import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool isSwitched = false;
  bool isMapVisible = false;

  late GoogleMapController mapController;

  // initiate camera position

  static const CameraPosition _kInitialPosition = CameraPosition
    (target: LatLng(37.7749, -122.4194),
    zoom: 14,
    );

  // function handle map creation
  _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       body: SingleChildScrollView(
         scrollDirection: Axis.vertical,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [

           GestureDetector(
             onTap: (){
               Navigator.pop(context);
             },
             child: Container(
             height: 40.0,
             width: 40.0,
             margin: EdgeInsets.only(left: 16.0, top: 50.0),
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

             Padding(
               padding: const EdgeInsets.only(top: 20.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 16.0),
                     child: Text("249 Results",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize:22.0,),),
                   ),

                   Expanded(child: SizedBox()),

                   Padding(
                     padding: const EdgeInsets.only(left: 16.0),
                     child: Text("Map View",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize:16.0,),),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(left: 10.0, right: 16.0),
                     child: CustomSwitch(
                       value: isSwitched,
                       onChanged: (value) {
                         setState(() {
                           isSwitched = value;
                           isMapVisible = !isMapVisible;
                         });
                       },
                     ),
                   ),

                 ],
               ),
             ),

             Padding(
             padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
             child: SingleChildScrollView(
             scrollDirection: Axis.horizontal,
             child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Container(
                height: 40.0,
                width: 170.0,
                margin: const EdgeInsets.only(left: 16.0, right: 10.0),
                child: TextFormField(
            // controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "Search Location....",
              suffixIcon: Icon(Icons.search, color: HexColor("#00B578"), size: 25.0,),
              hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.normal),
              // Customize label color
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#B7BFC5"), width: 1.0),
                borderRadius: BorderRadius.circular(20.0),// Border color when not focused
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#B7BFC5"), width: 1.0),
                borderRadius: BorderRadius.circular(20.0),// Same border color when focused
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#B7BFC5"), width: 1.0),
                borderRadius: BorderRadius.circular(20.0),// General border color
              ),
              counterText: '',
            ),
            style: TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.normal),
            maxLines: 1,
            maxLength: 18,
            // onChanged: (query) => _filterItems(query),
          ),
               ),

               Stack(
          children: [
            Container(
              height: 40.0,
              width: 130.0,
              margin: const EdgeInsets.only(right: 10.0),
              child: TextFormField(
                // controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Price",
                  hintStyle: TextStyle(fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.normal),
                  // Customize label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#B7BFC5"), width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),// Border color when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#B7BFC5"), width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),// Same border color when focused
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#B7BFC5"), width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),// General border color
                  ),
                  counterText: '',
                ),
                style: TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.normal),
                maxLines: 1,
                maxLength: 18,
                enabled: false,
                // onChanged: (query) => _filterItems(query),
              ),
            ),

               Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 100),
                child: Image(image: AssetImage("images/naira_logo.png"), width: 15.0, height: 18.0,),
              ),
          ],
               ),

               Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: ElevatedButton(onPressed:() {
              // Action to be taken on button press
              // loading();
              //  makePostRequest();
            },// Disable button if form is invalid() {
              child: Text("Apply", style: TextStyle(fontSize: 13.0),),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                minimumSize: Size(70.0, 40.0),
                // fixedSize: Size(300.0, 50.0),
                textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0)),
                ),
                // side: BorderSide(color: Colors.black, width: 2),
                // alignment: Alignment.topCenter
              ),
            ),
          ),
               ),

             ],
               ),
              ),
             ),

           Visibility(
             visible: isMapVisible,
             child: Container(
               height: 300,
               width: MediaQuery.of(context).size.width,
               margin: EdgeInsets.only(left: 16.0, right: 16.0),
               decoration: BoxDecoration(
                 image: DecorationImage(image: AssetImage("images/map_image.png"), fit: BoxFit.fitWidth),
                 borderRadius: BorderRadius.circular(10.0),
               ),
               // child: GoogleMap(onMapCreated: _onMapCreated,
               //     initialCameraPosition: _kInitialPosition,
               // markers: _markers(),
               // ),
             ),
           ),

            Container(
              height: 500.0,
               child: GridView.builder(
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2, // Number of columns
                   crossAxisSpacing: 10, // Horizontal spacing
                   mainAxisSpacing: 10, // Vertical spacing
                   childAspectRatio: 0.8, // Aspect ratio of the grid items
                 ),
                 itemCount: 10, // Number of items
                 padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 20.0),
                 itemBuilder: (context, index) {
                   return Card(
                   color: Colors.white,
                   elevation: 2,
                   shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5),
                             child: Image(image: AssetImage("images/house_image.png"),),
                           ),

                           Padding(
                             padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                             child: Text("The Stable",style: TextStyle(color:HexColor("#181818"), fontWeight: FontWeight.bold, fontSize:12.20,),),
                           ),

                           Padding(
                             padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                             child: Text("₦ 5999.99",style: TextStyle(color:HexColor("#00B578"), fontWeight: FontWeight.normal, fontSize:11,),),
                           ),

                           Padding(
                             padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Image(image: AssetImage("images/location_grey.png"),height: 12.2, width: 12.2,),

                               Padding(
                                 padding: const EdgeInsets.only(left: 5.0),
                                 child: Text("Lagos Island",style: TextStyle(color:HexColor("#7F7F7F"), fontWeight: FontWeight.normal, fontSize:9.15,),),
                               ),
                             ],
                             )
                           ),
                         ],
                       ),
                   );
                 },
               ),
             ),

             GestureDetector(
               onTap: (){

               },
               child: Center(
                 child: Padding(
                   padding: const EdgeInsets.only(top: 5.0, bottom: 35.0),
                   child: CircleAvatar(
                     radius: 18.0,
                     backgroundColor: HexColor("#00B578"),
                     child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15.0,),
                   ),
                 ),
               ),
             ),
           ],
         ),
       ),
    );
  }

  Set<Marker> _markers(){
    return{
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(title: 'san Francisco'),
      ),
    };
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 30,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value ? HexColor("#00B578") : HexColor("#EEEEEE"),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
