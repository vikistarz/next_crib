import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
class AgentDashboardPage extends StatefulWidget {
  const AgentDashboardPage({super.key});

  @override
  State<AgentDashboardPage> createState() => _AgentDashboardPageState();
}

class _AgentDashboardPageState extends State<AgentDashboardPage> {
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
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        // _showExitDialog(context);
        // return exitApp; // Return true to exit, false to stay
         SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Upload Images")),
        body: Column(
          children: [
            Center(
              child: Container(
                child: Wrap(
                  children: selectedImages.map((image) {
                    return Container(
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor("#838383"), width: 1.0),
                      ),

                        child: Image.file(image, width: 150, height: 150, fit: BoxFit.fill),
                    );
                  }).toList(),
                ),
              ),
            ),


            ElevatedButton(
              onPressed: pickImages,
              child: Text("Pick Images"),
            ),


            // SizedBox(height: 20),
            //
            // // Image holder container
            // GestureDetector(
            //   onTap: pickImages, // Open gallery when tapped
            //   child: Container(
            //     width: 150,
            //     height: 150,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: selectedImages.isEmpty
            //         ? Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.image, size: 50, color: Colors.grey),
            //         Text("Tap to select image",
            //             style: TextStyle(color: Colors.grey)),
            //       ],
            //     )
            //         : Image.file(selectedImages.first, fit: BoxFit.cover), // Show first image
            //   ),
            // ),
            //
            // SizedBox(height: 20),
            //
            // // Upload Button
            // ElevatedButton(
            //   onPressed: selectedImages.isNotEmpty ? () => uploadImages(selectedImages) : null,
            //   child: Text("Upload Images"),
            // ),
          ],
        ),
      ),
    );
    }
    // Upload function (dummy implementation)
    Future<void> uploadImages(List<File> images) async {
    print("Uploading ${images.length} images...");

    Future<bool> _showExitDialog(BuildContext context) async {
      return await showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) => AlertDialog(
          title: Text("Exit App"),
          content: Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Stay in app
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Exit app
              child: Text("Exit"),
            ),
          ],
        ),
      ) ??
          false; // Return false if dialog is dismissed
    }

    }
}
