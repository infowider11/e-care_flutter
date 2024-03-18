import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';

String? validateString(String? str, String message, BuildContext context){
  String? value = (str==null)?"":str.trim();
  if(value==null || value==''){
    showSnackbar(message);
    return "err";
  }
  else{
    return null;
  }
}

String? validateEmail(String email, BuildContext context){
  bool emailValid = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(email);
  // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  if (emailValid == false || email == null) {

    showSnackbar("Please enter your valid email address.");
    return 'Please enter your valid email address';
  }
  else
    return null;
}