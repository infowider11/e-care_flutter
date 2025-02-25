import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/global_keys.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';
import 'buttons.dart';



Future<bool?>  showCustomConfirmationDialog({
      required String headingMessage,
      String? description,
    })async{
  return await showDialog(
      context: MyGlobalKeys.navigatorKey.currentContext!,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubHeadingText(
                color: Colors.red,
                  fontSize: 22, text:   headingMessage,
                ),
                vSizedBox,
                if(description!=null)
                  ParagraphText(text: description,),
                if(description!=null)
                  vSizedBox2,
                vSizedBox2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundEdgedButton(
                      text: 'No',
                      verticalPadding: 0,
                      // horizontalPadding: 0,
                      height: 36,
                      width: 100,
                      color: MyColors.primaryColor,
                      isSolid: false,
                      onTap: () {
                        Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
                      },
                    ),
                    hSizedBox2,
                    RoundEdgedButton(
                      text: 'Yes',
                      verticalPadding: 0,
                      height: 36,
                      width: 100,
                      color: MyColors.primaryColor,
                      onTap: () {
                        Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!, true);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}