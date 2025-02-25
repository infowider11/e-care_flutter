// ignore_for_file: avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:flutter/material.dart';
Future push({required  BuildContext context, required Widget screen,})async{
  print('presse kjhn d');
  return Navigator.push(context, MaterialPageRoute(builder: (context){
    return screen;
  }));
}

Future pushReplacement({required  BuildContext context, required Widget screen,})async{
  return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
    return screen;
  }));
}


Future bottomsheet(
    {
      double height = 650,
      double radius = 20,
      Color backcolor = MyColors.white,
      required BuildContext context,
      required dynamic child,
    }
    )async{
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: backcolor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  )
              ),
              height: height,
              child: child,
            );
          }
      );
    },
  );

}