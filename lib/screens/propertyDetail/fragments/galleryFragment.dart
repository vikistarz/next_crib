import'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
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
                    child: Text("("+widget.propertyImages.length.toString()+")", style: TextStyle(color: HexColor("#00B578"), fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10, // Horizontal spacing
                    mainAxisSpacing: 10, // Vertical spacing
                    childAspectRatio: 0.8, // Aspect ratio of the grid items
                  ),
                  shrinkWrap: true, // Important!
                  physics: NeverScrollableScrollPhysics(), //
                  itemCount: widget.propertyImages.length, // Number of items
                  padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 20.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                       _showCustomDialog(context, widget.propertyImages[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(image: NetworkImage(widget.propertyImages[index]), fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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

  void _showCustomDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0), // Rounded corners
          ),
          child: Container(
            width: 400, // Fixed width
            height: 450, // Fixed height (square dialog)
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: Colors.black, // Background color
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0, top: 20.0),
                        child: Image(image: AssetImage("images/cancel_x.png"),width: 25.0, height: 25.0,),
                      ),
                    )),

                  // Image corner radius
                    SizedBox(
                      width: 380,
                      height: 320,
                      child: PhotoView.customChild(
                        child: Image.network(
                          imageUrl,fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text("Image failed to load"),
                          ),
                        ),
                        backgroundDecoration: BoxDecoration(color: Colors.black),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 4.0,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
