// ignore: unused_import
import 'dart:ffi';

 
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'CustomTexts.dart';

class Chip_Custom extends StatelessWidget {

  final String text;
  final Color background;
  final Color textcolor;
  final double fontsize;

  const Chip_Custom({
    Key? key,
    required this.text,
    this.background = MyColors.green,
    this.textcolor = Colors.white,
    this.fontsize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 24,
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Center(child: ParagraphText(
        text: text, fontSize: fontsize, color: textcolor,
        fontFamily: 'bold',
      )),
    );
  }
}
