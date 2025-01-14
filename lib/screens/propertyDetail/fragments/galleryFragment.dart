import'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class GalleryFragment extends StatefulWidget {
      const GalleryFragment({super.key, required this.propertyImages});

     final List<String> propertyImages;

  @override
  State<GalleryFragment> createState() => _GalleryFragmentState();
}

class _GalleryFragmentState extends State<GalleryFragment> {


  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: HexColor("#F9F9F9"),
      ),
        child: Container(
           margin: EdgeInsets.only(top: 0.0),
           child: Column(
            children: [
              Row(
                children: [
               Padding(
               padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                child: Text("Gallery", style: TextStyle(color: HexColor("#2A2B3F"), fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 5.0),
                    child: Text("(4)", style: TextStyle(color: HexColor("#00B578"), fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),

              Container(
                height: 400.0,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10, // Horizontal spacing
                    mainAxisSpacing: 10, // Vertical spacing
                    childAspectRatio: 0.8, // Aspect ratio of the grid items
                  ),
                  itemCount: widget.propertyImages.length, // Number of items
                  padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 20.0),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(image: NetworkImage(widget.propertyImages[index]), fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    );
                  },
                ),
              ),

            ],
        ),
      ),
    );
  }
}
