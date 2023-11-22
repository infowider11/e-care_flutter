import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/image_urls.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';
import 'avatar.dart';



class StaffList extends StatelessWidget {
  final String text;
  final String subtext;
  final String image;
  final double? letterspaceing;
  final double? height;
  final double horizontalpadding;
  final Color? color;
  final Color? textcolor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final bool underlined;
  final bool usericon;
  final bool popupmenu;
  final bool popup;
  const StaffList({
    Key? key,
    required this.text,
    required this.subtext,
    this.color = MyColors.headingcolor,
    this.textcolor = MyColors.headingcolor,
    this.fontSize,
    this.image = MyImages.logo,
    this.letterspaceing,
    this.height,
    this.horizontalpadding = 16,
    this.fontWeight,
    this.fontFamily = 'regular',
    this.textAlign,
    this.underlined = false,
    this.usericon=true,
    this.popupmenu=false,
    this.popup=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColors.bordercolor)
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.symmetric(horizontal: horizontalpadding, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 15,
            child: Row(
              children: [
                if(usericon)
                Container(
                  height: 50 ,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: MyColors.border,),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        image,
                        fit: BoxFit.contain,
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
                hSizedBox,
                Flexible(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: usericon==true? EdgeInsets.all(0.0) : EdgeInsets.only(left: 16),
                        child: ParagraphText(text: text,
                          fontSize: 16,
                          fontFamily: 'semibold',
                          color: textcolor,

                        ),
                      ),
                      Padding(
                        padding: usericon==true? EdgeInsets.all(0.0) : EdgeInsets.only(left: 16),
                        child: ParagraphText(text: subtext,fontSize: fontSize,
                          fontFamily: fontFamily, color: color,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(popupmenu)
          Flexible(
            flex: 1,
              child:PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.black,),
                elevation: 0,
                offset: Offset(-30, 0),
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text('Upload Photo'),
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text('Remove Photo'),
                    ),
                  ),
                ],
              ),
          ),
          if(popup)
          Flexible(
            flex: 1,
            child:GestureDetector(
            onTap: (){
              // showDialog<void>(context: context, builder: (context) => dialog1);
              },
              child: Container(
                  color: MyColors.backcolor,
                    child: Icon(
                        Icons.more_vert, color: Colors.black)
                ),
            ),
          ),
        ],
      ),
    );
  }
}


class salary_detail_list extends StatelessWidget {

  final String text;
  final String subtext;
  final double? letterspaceing;
  final double? height;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final bool underlined;
  final bool usericon;
  final bool popupmenu;
  const salary_detail_list({
    Key? key,
    required this.text,
    required this.subtext,
    this.color,
    this.fontSize,
    this.letterspaceing,
    this.height,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.underlined = false,
    this.usericon=false,
    this.popupmenu=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColors.primaryColor)
      ),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        children: [

          Expanded(
            flex: 7,
            child: Row(
              children: [
                if(usericon)
                  Flexible(
                      child: CircleAvatarcustom(
                        image: MyImages.logo,
                        bgcolor: Colors.transparent,
                        height: 35,
                        fit: BoxFit.fitHeight,)
                  ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: usericon==true? EdgeInsets.all(0.0) : EdgeInsets.only(left: 16),
                        child: ParagraphText(text: text,
                          fontSize: 16,
                          fontFamily: 'medium',
                        ),
                      ),
                      Padding(
                        padding: usericon==true? EdgeInsets.all(0.0) : EdgeInsets.only(left: 16),
                        child: ParagraphText(text: subtext,fontSize: 12,
                          fontFamily: 'light',),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(popupmenu==false)
            Flexible(
              flex: 1,
              child:Icon(
                Icons.keyboard_arrow_up_outlined,
              ),
            ),
          if(popupmenu==true)
            Flexible(
              flex: 1,
              child:Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
            ),
        ],
      ),
    );
  }
}