import 'package:badges/badges.dart' as badges;
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';

class ListUI01 extends StatelessWidget {
  final String heading;
  final String subheading;
  final String thirdHead;
  final String image;
  final String rightText;
  final Color bgColor;
  final Color borderColor;
  final Color thirdHeadColor;
  final bool isIcon;
  final bool isRightText;
  final bool isimage;
  final bool? networkimage;
  final bool isthirdHead;
  final double imgWidth;
  final Function()? onPressed;
  final Function(String)? onSelected;
  final String? badge_count;
  ListUI01({
    Key? key,
    this.badge_count='0',
    this.onSelected,
    required this.heading,
    this.subheading = "Aug 10, 2022",
    this.networkimage = false,
    this.rightText = "9:00 PM",
    this.image = 'assets/images/download.png',
    this.bgColor = MyColors.white,
    this.borderColor = MyColors.borderColor2,
    this.thirdHeadColor = MyColors.green,
    this.isIcon = true,
    this.isRightText = false,
    this.isthirdHead = false,
    this.onPressed,
    this.isimage = true,
    this.thirdHead = 'Confirmed',
    this.imgWidth = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(    
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (networkimage!)
                CustomCircularImage(
                  imageUrl: image,
                  width: 40,
                  height: 40,
                ),
              if (isimage)
                Image.asset(
                image,
                height: 50.0,
                width: 50.0,
                  fit: BoxFit.cover,
                ),
              hSizedBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: MainHeadingText(
                            text: heading,
                            color: MyColors.headingcolor,
                            fontSize: 16,
                            fontFamily: 'bold',
                          ),
                        ),
                        hSizedBox,
                        if (isRightText)
                          ParagraphText(
                            text: rightText,
                            color: MyColors.onsurfacevarient,
                            fontSize: 14,
                          ),
                        hSizedBox,
                        if (badge_count!=null&&int.parse(badge_count.toString())>0)
                          badges.Badge(
                            position: badges.BadgePosition.topEnd(top: 5, end: 2),
                            showBadge: true,
                            badgeContent: Text('${badge_count.toString()}',style: TextStyle(color: Colors.white),),
                            // child: IconButton(
                            //   icon: Icon(Icons.chat),
                            //   onPressed: () {},
                            // ),
                          ),
                        // Badge(
                          //   showBadge: true,
                          //   badgeContent: Text('${badge_count.toString()}',style: TextStyle(color: Colors.white),),
                          // ),
                      ],
                    ),
                    MainHeadingText(
                      text: subheading,
                      color: MyColors.headingcolor,
                      fontFamily: 'light',
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isthirdHead)
                      MainHeadingText(
                          text: thirdHead,
                          color: thirdHeadColor,
                          fontSize: 8
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        vSizedBox
      ],
    );
  }
}

class ListUI02 extends StatelessWidget {
  final String heading;
  final String subheading;
  final String thirdHead;
  final String image;
  final String rightText;
  final Color bgColor;
  final Color borderColor;
  final Color thirdHeadColor;
  final bool isIcon;
  final bool isRightText;
  final bool isimage;
  final bool isthirdHead;
  final double imgWidth;
  final Function()? editonTap;
  final Function()? sendonTap;
  final Function()? deleteonTap;
  final bool is_edit;
  const ListUI02({
    Key? key,
    required this.heading,
    this.sendonTap,
    this.editonTap,
    this.is_edit=true,
    this.deleteonTap,
    this.subheading = "Aug 10, 2022",
    this.rightText = "9:00 PM",
    this.image = 'assets/images/download.png',
    this.bgColor = MyColors.white,
    this.borderColor = MyColors.borderColor2,
    this.thirdHeadColor = MyColors.green,
    this.isIcon = true,
    this.isRightText = false,
    this.isthirdHead = false,
    this.isimage = true,
    this.thirdHead = 'Confirmed',
    this.imgWidth = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 14,horizontal: 8.0),
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Row(
                  children: [
                    Expanded(
                      flex:0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainHeadingText(
                            text: heading,
                            color: MyColors.headingcolor,
                            fontSize: 13,
                            fontFamily: 'bold',
                          ),
                          Row(
                            children: [
                              MainHeadingText(
                                text: subheading,
                                color: MyColors.headingcolor,
                                fontFamily: 'light',
                                fontSize: 10,
                              ),
                              hSizedBox,
                              if (isthirdHead)
                                MainHeadingText(
                                    text: thirdHead,
                                    color: thirdHeadColor,
                                    fontSize: 10)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: new Container(),flex: 0,),
                  ],
                ),
              ),

              hSizedBox2,
              if(is_edit)
              Expanded(
                child: RoundEdgedButton(
                  onTap: editonTap,
                  fontSize: 10,
                  text: 'Edit',
                  isSolid: false,
                  width: 60,
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  height: 30,
                ),
              ),
              hSizedBox,
              Expanded(
                child: RoundEdgedButton(
                  onTap: sendonTap,
                  fontSize: 10,
                  text: 'Download',
                  width: 60,
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  height: 30,
                ),
              ),
              hSizedBox,
              Expanded(
                child: RoundEdgedButton(
                  fontSize: 10,
                  onTap: deleteonTap,
                  color: Colors.red,
                  text: 'Delete',
                  width: 60,
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  height: 30,
                ),
              ),
              if(isIcon)
            IconButton(
              onPressed: () {
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    // PopupMenuItem 1
                    PopupMenuItem(
                      value: 1,
                      // row with 2 children
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text("Prescription")
                        ],
                      ),
                    ),
                    // PopupMenuItem 2
                    PopupMenuItem(
                      value: 2,
                      // row with two children
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text("Sick note")
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      // row with two children
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text("Referral Letter")
                        ],
                      ),
                    ),
                  ],
                  offset: Offset(0, 58),
                  color: MyColors.white,
                  elevation: 0,
                  // on selected we show the dialog box
                  onSelected: (value) {
                    // if value 1 show dialog
                    if (value == 1) {
                      // push(context: context, screen: Prescriptions_Doctor_Page(
                      //   booking_id: info['id'].toString(),
                      // ));
                    } else if (value == 2) {

                    } else if(value == 3){

                    }
                  },
                );
              },
              icon: Icon(Icons.more_vert),
            ),
              // Image.asset('assets/images/download.png', width: 24,),

              if (isRightText)
                ParagraphText(
                  text: rightText,
                  color: MyColors.onsurfacevarient,
                  fontSize: 14,
                )
            ],
          ),
        ),
        vSizedBox
      ],
    );
  }
}
