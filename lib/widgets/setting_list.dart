import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'CustomTexts.dart';

class SettingList extends StatelessWidget {
  final String heading;
  final Function() func;

  const SettingList({Key? key,
    required this.heading,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: MyColors.bordercolor,
              width: 1
            )
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ParagraphText(text: heading, fontFamily: 'bold', color: MyColors.onsurfacevarient),
            const Icon(Icons.chevron_right_rounded, size: 24, color: MyColors.bordercolor,)
          ],
        ),
      ),
    );
  }
}
