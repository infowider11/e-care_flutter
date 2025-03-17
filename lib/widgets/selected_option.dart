import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';

class SelectedBox extends StatelessWidget {
  final String heading;
  final String? text;
  final Widget? icon;
  const SelectedBox({Key? key, required this.heading, this.text,this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeadingText(
              text: heading,
              fontSize: 16,
              fontFamily: 'regular',
              overflow: TextOverflow.ellipsis,
            ),
            vSizedBox,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MyColors.bordercolor, width: 1),
                  color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText(
                    fontSize: 10,
                    text: text ?? 'Value',
                    color: MyColors.onsurfacevarient,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Icon(Icons.highlight_remove_rounded, size: 20,)
                ],
              ),
            ),
            vSizedBox,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ParagraphText(text: 'Add', color: MyColors.onsurfacevarient,)
            //   ],
            // ),
            // vSizedBox2,
          ],
        ),
        if(icon!=null)
        Positioned(
            right: 10,
            top: 45,
            child: icon!,
        ),
      ],
    );
  }
}
