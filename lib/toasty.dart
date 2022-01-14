import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasty {
  show(String message, Toast duration, ToastGravity possition){
    Fluttertoast.showToast(
        msg: message,
        gravity: possition,
        toastLength: duration,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white, fontSize: 16.0
    );
  }
}