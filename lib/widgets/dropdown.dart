import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';
import 'package:dropdown_search/dropdown_search.dart';



// class DropDown extends StatefulWidget {
//   final String hint;
//   final Color bgcolor;
//   final String label;
//   final bool islabel;
//
//   const DropDown({Key? key,
//     this.hint = 'Select here...',
//     this.bgcolor = MyColors.white,
//     this.islabel = false,
//     this.label = 'Name',
//   }) : super(key: key);
//
//   @override
//   State<DropDown> createState() => _DropDownState();
// }
//
// class _DropDownState extends State<DropDown> {
//   final List<String> items = [
//     'Select here...',
//     '5 Minutes',
//     '10 Minutes',
//     '15 Minutes',
//     '20 Minutes',
//   ];
//   String? selectedValue;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // vSizedBox2,
//           // ParagraphText(
//           //   text: 'Select Employee Count',
//           //   fontSize: 14,
//           //   color: MyColors.bordercolor,
//           // ),
//           // SizedBox(height: 7),
//           if(widget.islabel)
//           MainHeadingText(text: widget.label, fontSize: 12, fontFamily: 'light', color: MyColors.onsurfacevarient,),
//           vSizedBox05,
//           DropdownButtonHideUnderline(
//             child: DropdownButton2(
//               isExpanded: true,
//               hint: Text(
//                 widget.hint,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: MyColors.bordercolor,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               items: items
//                   .map((item) => DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(
//                   item,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     // fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ))
//                   .toList(),
//               value: selectedValue,
//               onChanged: (value) {
//                 setState(() {
//                   selectedValue = value as String;
//                 });
//               },
//               icon: const Icon(
//                 Icons.expand_more_outlined,
//               ),
//               iconSize: 20,
//               iconEnabledColor: MyColors.bordercolor,
//               iconDisabledColor: Colors.grey,
//               buttonHeight: 56,
//               buttonWidth: MediaQuery.of(context).size.width,
//               buttonPadding: const EdgeInsets.only(left: 14, right: 14),
//               buttonDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(
//                   color: MyColors.bordercolor,
//                 ),
//                 // color: MyColors.primaryColor,
//                 color: widget.bgcolor,
//               ),
//               buttonElevation: 0,
//               itemHeight: 30,
//               itemPadding: const EdgeInsets.only(left: 14, right: 14),
//               dropdownMaxHeight: 200,
//               dropdownWidth: MediaQuery.of(context).size.width - 48,
//               dropdownPadding: null,
//               dropdownDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(4),
//                 color: Colors.white,
//                 border: Border.all(
//                   color: MyColors.bordercolor,
//                 ),
//
//               ),
//               dropdownElevation: 0,
//               scrollbarRadius: const Radius.circular(40),
//               scrollbarThickness: 6,
//               scrollbarAlwaysShow: true,
//               offset: const Offset(0, 0),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class CustomDropdownButton extends StatefulWidget {
  final List items;
  final String hint;
  final BoxBorder? border;
  final dynamic selected;
  final double? maxheight;
  final String? keyward;
  final Function(dynamic value)? onChanged;
  const CustomDropdownButton(
      {Key? key, this.keyward,
        required this.items, required this.hint, this.onChanged, this.selected,this.border,this.maxheight})
      : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}
class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
       height: 55,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xFEFFFFFF),
          // border: widget.border,
          border: Border.all(color: MyColors.bordercolor),
          borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.only(left: 10),
      child: DropdownSearch(
        /// commented to check
        // maxHeight:widget.maxheight??200,
        selectedItem: widget.selected,
        /// commented to check
        // dropDownButton: Icon(
        //   Icons.keyboard_arrow_down_outlined,
        //   size: 24,
        //   color: Color(0xFE7A7A7A),
        // ),
        /// commented to check
        // dropdownSearchDecoration: InputDecoration.collapsed(
        //   hintText: widget.hint,
        // ),
        /// commented to check
        // mode: Mode.MENU,
        items: widget.items,
        onChanged: widget.onChanged,
      ),
    );
  }
}
