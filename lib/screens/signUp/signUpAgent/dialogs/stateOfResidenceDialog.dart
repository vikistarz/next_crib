
import'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:next_crib/screens/signUp/signUpAgent/models/StateResponseModel.dart';

import '../../../database/appPrefHelper.dart';
import '../../../database/saveValues.dart';
import '../../../webService/apiConstant.dart';


class StateOfResidenceDialog extends StatefulWidget {
  const StateOfResidenceDialog({super.key});

  @override
  State<StateOfResidenceDialog> createState() => _StateOfResidenceDialogState();
}

class _StateOfResidenceDialogState extends State<StateOfResidenceDialog> {

  String stateCode = "";
  String errorMessage = "";
  bool isLoadingVisible = true;


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

  TextEditingController searchController = TextEditingController();
  List<StateResponseModel> _items = [];
  List<StateResponseModel> _filteredItems = [];


  Future<List<StateResponseModel>> fetchState() async {
    loading();
    final String apiUrl = ApiConstant.getStateApi;
    final response = await http.get(
        Uri.parse(apiUrl));

    print("request: " + response.toString());
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      List<dynamic> items = json.decode(response.body);
      return items.map((json) => StateResponseModel.fromJson(json)).toList();

    }

    else {
      isNotLoading();
      throw Exception('Failed to load items');
    }
  }

  void saveUserDetails() async {

    SaveValues mySaveValues = SaveValues();

    await mySaveValues.saveString(AppPreferenceHelper.SELECTED_STATE_CODE, stateCode);
  }


  @override
  void initState() {
    super.initState();
    _loadItems();
  }


  Future<void> _loadItems() async {
    try {
      final items = await fetchState();
      setState(() {
        _items = items;
         _filteredItems = items;
        loading();
      });
    } catch (e) {
      setState(() {
        loading();
      });
      print("Error loading items: $e");
    }
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _items;
      });
    } else {
      setState(() {
        _filteredItems = _items
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: HexColor("#E8E7E7"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios, size: 25.0, color: Colors.black,),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Text("Select State", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            height: 45.0,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: HexColor("#C3BDBD"), size: 23.0,),
                hintText: "Search Here",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) => _filterItems(query),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          Expanded(
            child: Container(
              height: 500.0,
              margin: EdgeInsets.only(bottom: 20.0),
              child: FutureBuilder<List<StateResponseModel>>(
                future: fetchState(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child:  Visibility(
                        visible: !isLoadingVisible,
                        child: SpinKitFadingCircle(
                          color: Colors.black,
                          size: 50.0,),
                      ),);
                  }
                  else if (snapshot.hasError) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 170.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: SizedBox(),),

                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 20.0),
                                  child: Text('Sorry an error occurred', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal,),),
                                ),

                                Expanded(child: SizedBox(),),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                              child: Center(
                                child: ElevatedButton(onPressed: () {

                                  fetchState();
                                },
                                  child: Text("Try Again", style: TextStyle(fontSize: 14.0),),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: HexColor("#FF2121"), padding: EdgeInsets.all(10.0),
                                    minimumSize: Size(200.0, 30.0),
                                    // fixedSize: Size(300.0, 50.0),
                                    textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
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
                          ],
                        ),
                        // child: Center(child: Text('Error: ${snapshot.error}')),
                      ),
                    );
                    // return Dialog(
                    //
                    //   backgroundColor: Colors.white,
                    //   child: Container(
                    //     height: 200.0,
                    //       child: Center(child: Text('Error: ${snapshot.error}'))),
                    // );
                    // return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return Dialog(
                      backgroundColor: Colors.white,
                      child: Container(
                        height: 170.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: SizedBox(),),

                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 20.0),
                                  child: Text('No result Found', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal,),),
                                ),

                                Expanded(child: SizedBox(),),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                              child: Center(
                                child: ElevatedButton(onPressed: () {

                                  Navigator.pop(context);
                                },
                                  child: Text("Try Again", style: TextStyle(fontSize: 14.0),),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: HexColor("#FF2121"), padding: EdgeInsets.all(10.0),
                                    minimumSize: Size(200.0, 30.0),
                                    // fixedSize: Size(300.0, 50.0),
                                    textStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
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
                          ],
                        ),
                        // child: Center(child: Text('Error: ${snapshot.error}')),
                      ),
                    );
                  }
                  else {
                    return Expanded(
                      child:  _filteredItems.isEmpty
                          ? Center(
                        child: Text("No Results Found",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                       :
                        ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                      
                          final item = _filteredItems[index];
                          // final item = snapshot.data![index];
                      
                          return GestureDetector(
                            onTap: () {
                              stateCode = item.isoCode;
                              saveUserDetails();
                              Navigator.pop(context, item.name);
                            },
                            child: Container(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: [
                      
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Icon(Icons.location_on_rounded, size: 16.0, color: HexColor("#00B578"),)
                                  ),
                      
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(item.name,style: TextStyle(color:Colors.black, fontWeight: FontWeight.normal, fontSize:14.0,),),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
