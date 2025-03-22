import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:next_crib/screens/agentDashboard/ui/agentDashboard.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/appPrefHelper.dart';
import '../database/saveValues.dart';
import '../dialogs/errorMessageDialog.dart';
import '../dialogs/successMessageDialog.dart';
import '../signUp/signUpAgent/dialogs/cityDialog.dart';
import '../signUp/signUpAgent/dialogs/stateOfResidenceDialog.dart';
import '../utilities/locationService.dart';
import '../webService/apiConstant.dart';

// enum FenceTypeEnum { Yes, No}
// enum AvailableWaterEnum { Yes, No}
// enum ParkingSpaceEnum { Yes, No}

class CreatePropertyPage extends StatefulWidget {
  const CreatePropertyPage({super.key});

  @override
  State<CreatePropertyPage> createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {

  _CreatePropertyPageState(){
    selectedPropertyTypeValue = propertyType[0];
    selectedBedroomNumber = bedroomNumber[0];
    selectedToiletNumber = numberOfToilets[0];
    selectedStock = numberOfStock[0];

  }

  final propertyType = ["Room Self Contain", "Flat", "Duplex"];

  final bedroomNumber = [1, 2, 3, 4, 5];

  final numberOfToilets = [1, 2, 3, 4, 5];

  final numberOfStock = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

   bool isChecked = false;

  String? selectedPropertyTypeValue = "";
  int? selectedBedroomNumber;
  int? selectedToiletNumber;
  String? selectedFence = "";
  String? selectedWater = "";
  String? selectedParkingSpace = "";
  int? selectedStock;

  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool isLoadingVisible = true;
  bool cityVisible = false;
  bool officeAddressVisible = false;
  String token = "";
  String errorMessage = "";
  double? longitude;
  double? latitude;


  // FenceTypeEnum? _fenceTypeEnum;
  // AvailableWaterEnum? _availableWaterEnum;
  // ParkingSpaceEnum? _parkingSpaceEnum;


  // Function to validate the form and update button state
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


  TextEditingController statesController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController openingHourController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController annualCostController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dimensionController = TextEditingController();



  @override
  void dispose() {
    statesController.dispose();
    cityController.dispose();
    openingHourController.dispose();
    officeAddressController.dispose();
    annualCostController.dispose();
    totalCostController.dispose();
    descriptionController.dispose();
    dimensionController.dispose();
    super.dispose();
  }

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

  void updateStateTextValue(){
    setState(() {
      statesController.text = states == null ? "" : "$states";
    });
  }

  void updateCityTextValue(){
    setState(() {
      cityController.text = city == null ? "" : "$city";
    });
  }

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
      // fetchNearByProperties(latitude!, longitude!);
    }
  }

  Future<void> getLogLat() async {
    PermissionStatus status = await Permission.location.request();

    if(status.isGranted) {
      //get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        // locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
    else{
      setState(() {
        // locationMessage = "Location permission is required.";
      });
    }
  }


  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = []; // Store selected images

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
        if (selectedImages.length > 4) {
          selectedImages = selectedImages.sublist(0, 4); // Limit to 4 images
        }
      });
    }
  }

  Future<void> createProperty() async {
    print("📢 Button Clicked!");

      // Send intValue to backend or use it as needed
      loading();
      SaveValues mySaveValues = SaveValues();
      String? agentId = await mySaveValues.getString(AppPreferenceHelper.AGENT_ID);

    int? intAnnual = int.tryParse(annualCostController.text); // Convert string to int
    int? intTotal = int.tryParse(totalCostController.text);
    int? intDimension = int.tryParse(dimensionController.text);

    if (intAnnual == null || intTotal == null || intDimension == null) {
      print("⚠ Invalid integer input detected!");
      return;
    }

      const String apiUrl = ApiConstant.createProperty;
      try{
        final uri = Uri.parse(apiUrl);
        var request = http.MultipartRequest('POST', uri);
        //
        // request.headers["Authorization"] = "Bearer $token"; // Add token
        // request.headers["Content-Type"] = "multipart/form-data";

        request.fields['title'] = selectedPropertyTypeValue.toString();
        request.fields['category'] = 'rent';
        request.fields['annualCost'] = intAnnual.toString();
        request.fields['agent'] = agentId!;
        request.fields['totalPackage'] = intTotal.toString();
        request.fields['stock'] = selectedStock.toString();
        request.fields['dimension'] = intDimension.toString();
        request.fields['description'] = descriptionController.text;
        request.fields['state'] = statesController.text;
        request.fields['city'] = cityController.text;
        request.fields['location'] = officeAddressController.text;
        request.fields['coordinates'] = longitude.toString();
        request.fields['coordinates'] = latitude.toString();
        request.fields['bedrooms'] = selectedBedroomNumber.toString();
        request.fields['toilets'] = selectedToiletNumber.toString();
        request.fields['parkingSpace'] = selectedParkingSpace!;
        request.fields['water'] = selectedWater!;
        request.fields['fence'] = selectedFence!;

        for (var image in selectedImages) {
          final mimeType = _getMimeType(image.path);
          request.files.add(
            http.MultipartFile.fromBytes(
              'propertyImages', // Change this key based on API requirements
              await image.readAsBytes(),
              filename: image.path.split('/').last,
              contentType: MediaType('image', mimeType),
            ),
          );
        }

        print("request: " + request.toString());
        final response = await request.send();
        print(response.statusCode);

        if(response.statusCode == 201){
          isNotLoading();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print('Response Body: ${responseString}');
          var jsonResponse = json.decode(responseString);
          final Map<String, dynamic> data = jsonResponse;
          // token = data['skillProvider']['token'];
          // serviceProviderWalletId = data['wallet']['id'];
          // print(serviceProviderWalletId);

          setState(() {
            showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (BuildContext context) {
                  return SuccessMessageDialog(
                    content: 'Property Published Successfully',
                    onButtonPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const AgentDashboardPage();
                      }));
                    },
                  );
                });
          });
        }


        else{
          isNotLoading();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print('Response Body: ${responseString}');
          var jsonResponse = json.decode(responseString);
          final Map<String, dynamic> errorData = jsonResponse;
          errorMessage = errorData['message'] ?? 'Unknown error occurred';
          print(errorMessage);
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
      catch(e){
        print('Exception during image upload: $e');
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


  // Function to get MIME type
  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      default:
        return 'octet-stream';
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
        title: Text("List your property", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
        centerTitle: false,
      ),
      body: SingleChildScrollView(

        child: Form(
          key: _formKey,
          onChanged: _validateFormField,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                height: 30.0,
                width: 75.0,
                margin: EdgeInsets.only(top: 20.0, left: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(color: HexColor("#FF6D17"), width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(child: SizedBox()),

                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Image(image: AssetImage('images/rent.png'), width: 14.0, height: 14.0,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 0.0),
                      child: Text("Rent", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#A2A7AF"),),),
                    ),

                    Expanded(child: SizedBox()),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: Text("Property Info", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                    child: Text("Property Type", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),


                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: DropdownButtonFormField( value: null,
                    items: propertyType.map((e){
                      return DropdownMenuItem(child: Text(e), value: e,);
                    }
                    ).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedPropertyTypeValue = value.toString();
                      });
                    },
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: "Type",
                      labelStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                      counterText: '',
                    ),
                    style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    // enabled: false,
                  ),
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Number of Bedrooms", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: DropdownButtonFormField( value: null,
                  items: bedroomNumber.map((e){
                    return DropdownMenuItem(child: Text(e.toString()), value: e,);
                  }
                  ).toList(),
                  onChanged: (value){
                    setState(() {
                      selectedBedroomNumber = value;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Bedrooms",
                    labelStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                    counterText: '',
                  ),
                  style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                  // enabled: false,
                ),
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Number of Toilets", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: DropdownButtonFormField( value: null,
                  items: numberOfToilets.map((e){
                    return DropdownMenuItem(child: Text(e.toString()), value: e,);
                  }
                  ).toList(),
                  onChanged: (value){
                    setState(() {
                      selectedToiletNumber = value;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Toilets",
                    labelStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                    counterText: '',
                  ),
                  style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                  // enabled: false,
                ),
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Is Property Fenced?", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),



              Row(
                children: [
                Expanded(
                  child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                        child: RadioListTile(
                            title: Text("Yes", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                            // tileColor: Colors.grey.shade200,
                            value: "Yes",
                            dense: true,
                            activeColor: HexColor("#00B578"),
                            groupValue: selectedFence,
                            onChanged: (value){
                              setState(() {
                                selectedFence = value.toString();
                              });
                            }
                        ),
                      ),
                ),


                Expanded(
                  child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                        child: RadioListTile(
                            title: Text("No", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                            // tileColor: Colors.grey.shade200,
                            dense: true,
                            activeColor: HexColor("#00B578"),
                            value: "No",
                            groupValue: selectedFence,
                            onChanged: (value){
                              setState(() {
                                selectedFence = value.toString();
                              });
                            }),
                    ),
                ),

                ],
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Is There Running Water?", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                      child: RadioListTile(
                          title: Text("Yes", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                          // tileColor: Colors.grey.shade200,
                          value: "Yes",
                          dense: true,
                          activeColor: HexColor("#00B578"),
                          groupValue: selectedWater,
                          onChanged: (value){
                            setState(() {
                              selectedWater = value.toString();
                            });
                          }
                      ),
                    ),
                  ),


                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                      child: RadioListTile(
                          title: Text("No", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                          // tileColor: Colors.grey.shade200,
                          dense: true,
                          activeColor: HexColor("#00B578"),
                          value: "No",
                          groupValue: selectedWater,
                          onChanged: (value){
                            setState(() {
                              selectedWater = value.toString();
                            });
                          }),
                    ),
                  ),
                ],
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Is There Parking Space?", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                      child: RadioListTile(
                          title: Text("Yes", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                          // tileColor: Colors.grey.shade200,
                          value: "Yes",
                          activeColor: HexColor("#00B578"),
                          dense: true,
                          groupValue: selectedParkingSpace,
                          onChanged: (value){
                            setState(() {
                              selectedParkingSpace = value.toString();
                            });
                          }
                      ),
                    ),
                  ),


                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                      child: RadioListTile(
                          title: Text("No", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                          // tileColor: Colors.grey.shade200,
                          dense: true,
                          value: "No",
                          activeColor: HexColor("#00B578"),
                          groupValue: selectedParkingSpace,
                          onChanged: (value){
                            setState(() {
                              selectedParkingSpace = value.toString();
                            });
                          }),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Stock", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: DropdownButtonFormField( value: null,
                  items: numberOfStock.map((e){
                    return DropdownMenuItem(child: Text(e.toString()), value: e,);
                  }
                  ).toList(),
                  onChanged: (value){
                    setState(() {
                      selectedStock = value;
                    });
                  },
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Stock",
                    labelStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
                    counterText: '',
                  ),
                  style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                  // enabled: false,
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Dimension", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  validator: (value) {
                    final regex = RegExp(r'^[+-]?\d+(\.\d+)?$');
                    if (value == null || value.isEmpty) {
                      return 'Please enter house dimension';
                    }
                    if (value.length < 3) {
                      return 'Please enter a valid dimension';
                    }
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid dimension';
                    }
                    else{
                      return null; // Return null if the input is valid
                    }
                  },
                  controller: dimensionController,
                  keyboardType:TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "Dimension of Property",
                    hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    counterText: '',
                  ),
                  style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                ),
              ),






              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: Text("Property location", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                    child: Text("State", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),




              GestureDetector(
                onTap: (){
                  setState(() {

                    // cityVisible = !cityVisible;
                    // officeAddressVisible = !officeAddressVisible;

                  });

                  _openStateOfResidenceDialog();
                },
                child:  Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select State of residence';
                      }
                      else{
                        return null; // Return null if the input is valid
                      }
                    },
                    controller: statesController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined, size: 25.0, color: HexColor("#474545")),
                      hintText: "State",
                      hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    enabled: false,
                  ),
                ),
              ),


              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("City", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),



              Visibility(
                // remove! later
                visible: !cityVisible,
                child: new GestureDetector(
                  onTap: (){
                    setState(() {
                      // officeAddressVisible = !officeAddressVisible;
                    });
                    _openCityDialog();
                  },
                  child:  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select City';
                        }
                        else{
                          return null; // Return null if the input is valid
                        }
                      },
                      controller: cityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),),
                        suffixIcon: Icon(Icons.arrow_drop_down_outlined, size: 25.0, color: HexColor("#474545")),
                        hintText: "City",
                        hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      enabled: false,
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Address", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: HexColor("#00B578"),),),
                  ),
                ],
              ),


              Visibility(
                visible: !officeAddressVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Office Address';
                      }
                      else{
                        return null; // Return null if the input is valid
                      }
                    },
                    controller: officeAddressController,
                    keyboardType:TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Address of Property",
                      hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      counterText: '',
                    ),
                    style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text("Property features", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
              ),

                 Row(
                   children: [

                     Expanded(child: SizedBox()),

                     Container(
                       margin: const EdgeInsets.only(top: 20.0),
                       height: 100.0,
                       width: 100.0,
                       decoration: BoxDecoration(
                         image: DecorationImage(image: AssetImage("images/image_upload_picture.png"), fit: BoxFit.fitWidth),
                         borderRadius: BorderRadius.circular(20.0),
                       ),
                       child: Center(
                         child: Column(
                           children: [

                             Padding(
                               padding: const EdgeInsets.only(top: 20.0),
                               child: Image(image: AssetImage("images/upload_add.png"), width: 28.0, height: 28.0,),
                             ),

                             Padding(
                               padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                               child: Text("Upload your Property Photo.", style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.normal, color: HexColor("#4C535F"),),),
                             ),

                           ],
                         ),
                       ),
                     ),


                     GestureDetector(
                       onTap: pickImages,
                       child: Container(
                         margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                         height: 100.0,
                         width: 100.0,
                         decoration: BoxDecoration(
                           image: DecorationImage(image: AssetImage("images/add_property_photo.png"), fit: BoxFit.fitWidth),
                           borderRadius: BorderRadius.circular(20.0),
                         ),
                         child: Icon(Icons.add, color: HexColor("#141B34"),size: 27.0,),
                       ),
                     ),

                     Expanded(child: SizedBox()),

                   ],
                 ),


              Center(
                child: Container(
                  child: Wrap(
                    children: selectedImages.map((image) {

                     return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          // border: Border.all(color: HexColor("#838383"), width: 1.0),
                          child: Image.file(image, width: 150.0, height: 200.0, fit: BoxFit.fill),
                        ),
                      );

                    }).toList(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text("Property Price", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: HexColor("#212529"),),),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text("Price (Annual)", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: TextFormField(
              validator: (value) {
                final regex = RegExp(r'^[₦0-9,]+$');
                if (value == null || value.isEmpty) {
                  return 'Please enter rent amount';
                }

                if (!regex.hasMatch(value)) {
                  return 'Please enter a valid amount';
                }
                else{
                  return null; // Return null if the input is valid
                }
              },
              keyboardType: TextInputType.number,
              controller: annualCostController,
              maxLength: 11,// Automatically formats as currency
              decoration: InputDecoration(
                hintText: "Property Annual Price",
                hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
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
                    child: Text("Total Package (Price)", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#00B578"),),),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  validator: (value) {
                    final regex = RegExp(r'^[₦0-9,]+$');
                    if (value == null || value.isEmpty) {
                      return 'Please enter total Package';
                    }

                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid amount';
                    }
                    else{
                      return null; // Return null if the input is valid
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: totalCostController,
                  maxLength: 11,// Automatically formats as currency
                  decoration: InputDecoration(
                    hintText: "Property Total Package",
                    hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
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
                    child: Text("Property Descriptions", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#6A7380"),),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 2.0),
                    child: Text("*", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: HexColor("#00B578"),),),
                  ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 50.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  validator: (value) {
                    // final regex = RegExp(r'^[a-zA-Z]+$');
                    if (value == null || value.isEmpty) {
                      return 'Please enter description of the property';
                    }
                    // if (!regex.hasMatch(value)) {
                    //   return 'Please enter only letters';
                    // }
                    else{
                      return null; // Return null if the input is valid
                    }
                  },
                  controller: descriptionController,
                  keyboardType:TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter the property description e.g The Terrace Duplex is beautiful and... ",
                    hintStyle: TextStyle(color: HexColor("#C3BDBD"), fontSize: 14.0, fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#A2A7AF"), width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                  ),
                  maxLines: 2,
                  maxLength: 100,
                  style: TextStyle(color: HexColor("#212529"), fontSize: 14.0, fontWeight: FontWeight.normal),
                ),
              ),

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 50.0),
                    child: Center(
                      child: ElevatedButton(onPressed: _isButtonEnabled
                          ? () {
                        // Action to be taken on button press
                         createProperty();
                      }
                          : null, // Disable button if form is invalid() {
                        child: Text("Publish", style: TextStyle(fontSize: 18.0),),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: HexColor("#00B578"), padding: EdgeInsets.all(10.0),
                          minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
                          // fixedSize: Size(300.0, 50.0),
                          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
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
                    visible: !isLoadingVisible,
                    child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 50.0),
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

                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
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
        // cityVisible = true;
        cityController.text = "";
      });
    }
    else {
      setState(() {
        // cityVisible = false;
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
        // officeAddressVisible = true;
      });
    }
    else{
      setState(() {
        // officeAddressVisible = false;
      });
    }
  }

}
