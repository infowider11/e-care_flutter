import 'dart:developer';

import 'package:flutter/foundation.dart';


bool showPrintStatements = true;
bool showLogStatements = true;
void myCustomPrintStatement(Object? data, {bool showPrint = false, bool overrideDebugCondition = false}){
  if(showPrintStatements || showPrint){
    if(kDebugMode || overrideDebugCondition){

      print(data);
      return;
    }
  }

}

void myCustomLogStatements(Object? data, {bool showLog = false, bool overrideDebugCondition = false}){
  if(showLogStatements || showLog){
    if(kDebugMode || overrideDebugCondition){
      log(data.toString());
      return;
    }
  }

}