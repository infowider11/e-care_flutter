import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomNavigation{
  static Future push({required  BuildContext context, required Widget screen,})async{
    return Navigator.push(context, MaterialPageRoute(builder: (context){
      return screen;
    }));
  }

  static Future pushCupertino({required  BuildContext context, required Widget screen,})async{
    return    Navigator.push(context,CupertinoPageRoute(builder: (context){
      return screen;
    }));
  }

  static Future pushReplacement({required  BuildContext context, required Widget screen,})async{
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return screen;
    }));
  }
  static Future pushAndRemoveUntil({required  BuildContext context, required Widget screen,})async{
    return   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen,), (route) => false);
  }


  static Future pop<T extends Object?>(BuildContext context, [ T? result ])async{
    return Navigator.pop(context, result);
  }

  static Future popUntil<T extends Object?>(BuildContext context,RoutePredicate predicate)async{
    return Navigator.popUntil(context, predicate);
  }

}