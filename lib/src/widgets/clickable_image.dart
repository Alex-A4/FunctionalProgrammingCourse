import 'package:flutter/material.dart';
import 'package:zoo_mobile/src/ui/image_viewer.dart';

///Getting the list of clickable images which onTap opens
/// ImageViewer by the selected image
class ClickableImages extends StatelessWidget {
  final List<String> _imageUrls;

  //Padding
  final double pLeft;
  final double pRight;
  final double pTop;
  final double pBottom;

  ClickableImages(
    this._imageUrls, {
    this.pLeft = 0.0,
    this.pBottom = 0.0,
    this.pRight = 0.0,
    this.pTop = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          //Creating list of images
          _imageUrls
              .map((link) => new Padding(
                    padding:
                        EdgeInsets.only(left: pLeft, right: pRight, bottom: pBottom, top: pTop),
                    child: GestureDetector(
                      //Open the ImageViewer
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(_imageUrls, _imageUrls.indexOf(link)),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.network(
                          link,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ))
              .toList(),
    );
  }
}
