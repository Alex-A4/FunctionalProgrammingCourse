import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Getting circular progress bar
Widget getProgressBar() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.green[700],
      strokeWidth: 3.0,
    ),
  );
}

//Icon button to repeat downloading
Widget getUpdateScreen(VoidCallback action) {
  return Center(
    child: IconButton(
      iconSize: 50.0,
      icon: Icon(Icons.update),
      onPressed: action,
    ),
  );
}

void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    timeInSecForIos: 2,
  );
}
