
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'CustomTexts.dart';

AppBar appBar(
    {String? title,
      Color appBarColor = Colors.transparent,
      Color titleColor = MyColors.headingcolor,
      bool implyLeading = true,
      IconData backIcon = Icons.arrow_back_outlined,
      double fontsize = 16,
      double size = 20,
      // double toolbarHeight = 50,
      String badge = '0',
      String fontfamily = 'light',
      bool titlecenter = true,
      required BuildContext context,
      List<Widget>? actions, leading}) {
  return AppBar(
    // toolbarHeight: toolbarHeight,
    automaticallyImplyLeading: false,
    backgroundColor: appBarColor,
    elevation: 0,
    centerTitle: titlecenter,
    title: title == null
        ? null
        : AppBarHeadingText(
          text: title,
          color: titleColor,
          fontSize: fontsize,
          fontFamily: fontfamily,
        ),
    leading: implyLeading
        ? IconButton(
        icon:
        Icon(
         backIcon,
          color: titleColor,
          size: size,
        ),
      onPressed: () {
        Navigator.pop(context);
      },
    )
        : leading,
    actions: actions,
  );
}