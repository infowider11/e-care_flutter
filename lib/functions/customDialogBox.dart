
import 'package:flutter/material.dart';

Future showCustomDialogBox({required BuildContext context, required dynamic child, double paddingHorizontal = 16, double paddingVertical = 16, double insetPadding = 16}){
  return showDialog(context: context, builder: (context){
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding:  EdgeInsets.symmetric(horizontal: insetPadding),
      contentPadding:const  EdgeInsets.all(0),
      // title: Text('Allow Liza to see', textAlign: TextAlign.center,),
      children: [
        SimpleDialogOption(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height - 470,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                // border: Border.all(
                //     color: MyColors.primaryColor
                // ),

              ),
              child: child,
            )
        ),
      ],
    );
  });
}