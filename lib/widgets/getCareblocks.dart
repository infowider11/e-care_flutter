import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';

class GetCareBlocks extends StatelessWidget {
  final String heading;
  final String image;
  final Color bgColor;
  final Color iconColor;
  final bool? is_network_image;
  final String? fontFamily;
  final double? fontSize;
  const GetCareBlocks({Key? key,
    required this.heading,
    this.fontSize=16,
    this.fontFamily='light',
    this.is_network_image=false,
    required this.image,
    this.bgColor = MyColors.white,
    this.iconColor = MyColors.white,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: MyColors.bordercolor,
              width: 1
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 55,
              height: 55,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: !is_network_image!?Image.asset(image, width: 24,):Image.network(image,width: 30,),
                ),
              ),
            ),
          ),
          hSizedBox,
          Expanded(flex: 8, child: MainHeadingText(text: heading, fontFamily: fontFamily, fontSize: fontSize, color: MyColors.onsurfacevarient,)),
          const Expanded(flex: 2, child: Icon(Icons.chevron_right_rounded))
        ],
      ),
    );
  }
}
