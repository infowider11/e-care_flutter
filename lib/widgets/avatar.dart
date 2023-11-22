
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/image_urls.dart';

class CircleAvatarcustom extends StatelessWidget {

  final String image;
  final Color bgcolor;
  final double borderradius;
  final double height;
  final double width;
  final double imgwidth;
  final double imgheight;
  final BoxFit? fit;



  const CircleAvatarcustom(
      {
        Key? key,
        this. image = MyImages.logo,
        this. bgcolor = Colors.white,
        this. borderradius = 50,
        this. height = 70,
        this. width = 70,
        this. imgheight = 30,
        this. imgwidth = 30,
        this.fit = BoxFit.fitHeight,
      }

      )
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderradius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: bgcolor,
          // border: Border.all(color: MyColors.border,),
        ),
        child: Image.asset(
          image,
          fit: fit,
          height: imgheight,
          width: imgwidth,
        ),
      ),
    );

  }
}
