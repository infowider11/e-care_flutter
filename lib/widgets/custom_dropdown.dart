
// ignore_for_file: avoid_print

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../functions/validation_function.dart';
import 'CustomTexts.dart';

// class CustomDropdownButton1<T> extends StatelessWidget {
//   final double height;
//   final bool isextra_text;
//   final bool enable;
//   final String? extra_text;
//   ///
//   final String? text;
//   final bool isLabel;
//   final Color labelColor;
//
//   final List<T> items;
//   T? selectedItem;
//   final String hint;
//   final BoxBorder? border;
//   final void Function(T? value)? onChanged;
//   final double margin;
//   final double labelFontSize;
//   final String itemMapKey;
//   final Color fieldColor;
//   final double borderRadius;
//   final CrossAxisAlignment crossAxisAlignment;
//   final String? Function(T?)? validator;
//   CustomDropdownButton1({Key? key,
//     this.height = 0,
//     this.isextra_text = false,
//     this.enable = false,
//     this.extra_text = '',
//     this.margin = 0,
//     this.labelFontSize = 15,
//     this.validator,
//     this.text,
//     this.selectedItem,
//     this.labelColor =Colors.black,
//     required this.items,
//     required this.hint,
//     this.onChanged,
//     this.border,
//     this.borderRadius = 16,
//
//     this.isLabel = true,
//     this.itemMapKey = 'name',
//     this.fieldColor=Colors.transparent,
//     this.crossAxisAlignment = CrossAxisAlignment.start
//
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: crossAxisAlignment,
//       children: [
//
//
//         if(text!=null)
//           Text(text!, style: TextStyle(fontSize: labelFontSize, color: labelColor, fontFamily: 'bold'),),
//         Container(
//           height: 60,
//           margin: EdgeInsets.symmetric(vertical: margin),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(borderRadius)
//           ),
//           // decoration: BoxDecoration(
//           //     // color: Color(0xFEF0F0F0),
//           //     color: Colors.transparent,
//           //     // border: Border.all(color: Color(0xFEF0F0F0)),
//           //     border: Border.all(color: MyColors.bordercolor),
//           //     borderRadius: BorderRadius.circular(borderRadius)),
//           // padding: EdgeInsets.only(left: 16, top: 0),
//           child:  DropdownSearch<T>(
//             validator: validator,
//
//             // popupBackgroundColor: Colors.transparent,
//             // popupElevation: 0,
//             // // dro
//             // dropdownSearchDecoration: InputDecoration.collapsed(
//             //
//             //     hintText: '  $hint',
//             //     hintStyle: TextStyle(color: Color(0xFF999999), fontFamily: 'light')
//             // ),
//             // mode: Mode.MENU,
//
//             popupProps: PopupProps.modalBottomSheet(
//               fit: FlexFit.loose,
//               showSelectedItems: false,
//               title: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SubHeadingText(text: '$hint',),
//               ),
//               // title: Container(
//               //   color: Colors.transparent,
//               //   height: 100,
//               // ),
//             ),
//             dropdownDecoratorProps: DropDownDecoratorProps(
//                 dropdownSearchDecoration: InputDecoration(
//                   // labelText: "Menu mode",
//                   // hintText: "$hint",
//                   labelText: hint,
//                   // alignLabelWithHint: true,
//
//                   floatingLabelBehavior: FloatingLabelBehavior.auto,
//                   // labelText: "$hint",
//                   hintStyle: TextStyle(color: Color(0xFF999999), fontFamily: 'light'),
//                   // border: InputBorder.none,
//                   border:OutlineInputBorder(
//                     // borderSide: BorderSide(color: Colors.black),
//                     borderRadius: BorderRadius.circular(borderRadius),
//                     borderSide: BorderSide(color: MyColors.blackColor50,width: 1.5),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     // borderSide: BorderSide(color: Colors.black),
//                     borderRadius: BorderRadius.circular(borderRadius),
//                     borderSide: BorderSide(color: MyColors.blackColor50),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     // borderSide: BorderSide(color: Colors.black),
//                     borderRadius: BorderRadius.circular(borderRadius),
//                     borderSide: BorderSide(color: MyColors.primaryColor,width: 1.5),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     // borderSide: BorderSide(color: Colors.black),
//                     borderRadius: BorderRadius.circular(borderRadius),
//                     borderSide: BorderSide(color: MyColors.redColor,width: 1.5),
//                   ),
//                 )
//
//             ),
//
//             dropdownButtonProps: DropdownButtonProps(
//
//             ),
//             items: items,
//
//             // popupTitle: Container(
//             //   color: Colors.transparent,
//             //   height: 100,
//             // ),
//
//
//             // popupItemBuilderr: ,
//             dropdownBuilder:
//             // selectedItem==null?null:
//                 (context,value){
//               // myCustomPrintStatement('the value is ${value.toString()}');
//               // myCustomPrintStatement('the a is $a');
//               if(value==null){
//                 return Container(
//                   child: ParagraphText(text: '$hint'),
//                 );
//               }
//               try{
//                 return Text('${(value as Map)['${itemMapKey}']}');
//
//               }catch(e){
//                 myCustomPrintStatement('Error in catch block  5d55 $e');
//               }
//               return Container(
//                 decoration: BoxDecoration(
//                   // color:Colors.white,
//                   // border: Border(bottom: BorderSide(color: Colors.black12))
//                 ),
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(value.toString()+'sdfas'),
//                     // Divider(),
//                   ],
//                 ),
//               );
//
//
//             },
//             itemAsString: (T? value){
//               myCustomPrintStatement('this is called');
//               try{
//                 return ' ${(value as Map)['${itemMapKey}']}';
//               }catch(e){
//                 myCustomPrintStatement('Error in catch block  555 $e');
//               }
//               return '  ${value}';
//               // return '  ${value.toString()}';
//             },
//             selectedItem: selectedItem,
//
//
//
//             onChanged: onChanged,
//             // onChanged: (val){
//             //   selectedItem = val;
//             //   if(onChanged!=null){
//             //     onChanged!(val);
//             //   }
//             // },
//           ),
//         ),
//       ],
//     );
//   }
// }


class CustomDropdownButton<T> extends StatelessWidget {
  final String? text;
  final bool isLabel;
  final bool enable;
  final Color labelColor;
  final List<T> items;
  final T? selectedItem;
  final String hint;
  final double leftPadding;
  final double height;
  final BoxBorder? border;
  final bool isextra_text;
  final String? extra_text;
  final void Function(T? value)? onChanged;
  final double margin;
  final double labelFontSize;
  final String itemMapKey;
  final Color fieldColor;
  final Color bgColor;
  final CrossAxisAlignment crossAxisAlignment;
  final String? Function(T?)? validator;
  const CustomDropdownButton({Key? key,
    this.margin = 0,
    this.labelFontSize = 15,
    this.validator = ValidationFunction.requiredValidation,
     this.text,
    this.selectedItem,
    this.labelColor =Colors.black,
    required this.items,
    required this.hint,
    this.onChanged,
    this.border,
    this.leftPadding = 16,
    this.height = 55,
    this.bgColor = Colors.transparent,
    this.extra_text,
    this.isextra_text = false,
    this.enable = true,
    this.isLabel = true,
    this.itemMapKey = 'title',
    this.fieldColor=Colors.transparent,

    this.crossAxisAlignment = CrossAxisAlignment.start

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [


        // if(text!=null)
        // Text(text!, style: TextStyle(fontSize: labelFontSize, color: labelColor, fontFamily: 'bold'),),
        Container(
          height: height,
          margin: EdgeInsets.symmetric(vertical: margin),
          // decoration: BoxDecoration(
          //     // color: Color(0xFEF0F0F0),
          //     color: Colors.transparent,
          //     // border: Border.all(color: Color(0xFEF0F0F0)),
          //     border: Border.all(color: MyColors.bordercolor),
          //     borderRadius: BorderRadius.circular(8)),
          // padding: EdgeInsets.only(left: 16, top: 0),
          child:  DropdownSearch<T>(
            validator: validator,
            enabled: enable,
            // popupBackgroundColor: Colors.transparent,
            // popupElevation: 0,
            // // dro
            // dropdownSearchDecoration: InputDecoration.collapsed(
            //
            //     hintText: '  $hint',
            //     hintStyle: TextStyle(color: Color(0xFF999999), fontFamily: 'light')
            // ),
            // mode: Mode.MENU,

            popupProps: PopupProps.modalBottomSheet(
              // fit: FlexFit.loose,
              showSelectedItems: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: SubHeadingText(text: '$hint',),
              ),
              // title: Container(
              //   color: Colors.transparent,
              //   height: 100,
              // ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(

                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                // labelText: "Menu mode",
                // hintText: "$hint",
                labelText: hint,
                // alignLabelWithHint: true,

                floatingLabelBehavior: FloatingLabelBehavior.never,
                // labelText: "$hint",
                hintStyle: const TextStyle(color: Color(0xFF999999), fontFamily: 'light'),
                // border: InputBorder.none,
                border: InputBorder.none,
                // border:OutlineInputBorder(
                //   // borderSide: BorderSide(color: Colors.black),
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: BorderSide(color: MyColors.bordercolor,width: 1.5),
                // ),
                // enabledBorder: OutlineInputBorder(
                //   // borderSide: BorderSide(color: Colors.black),
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: BorderSide(color: MyColors.bordercolor),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   // borderSide: BorderSide(color: Colors.black),
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: BorderSide(color: MyColors.primaryColor,width: 1.5),
                // ),
                // errorBorder: OutlineInputBorder(
                //   // borderSide: BorderSide(color: Colors.black),
                //   borderRadius: BorderRadius.circular(8),
                //   borderSide: BorderSide(color: MyColors.red,width: 1.5),
                // ),
                // fillColor: Colors.green,
                // hoverColor: Colors.green,
                // focusColor: Colors.green,

              ),

            ),


            dropdownButtonProps: const DropdownButtonProps(
              // color: Colors.green,

            ),
            items: items,

            dropdownBuilder:
            // selectedItem==null?null:
                (context,value){
              print('the value is ${value.toString()}');
              // print('the a is $a');
              if(value==null){
                return Container(
                  // color: Colors.green,
                  child: Padding(
                    padding:  EdgeInsets.only(left: leftPadding),
                    child: ParagraphText(text: '$hint'),
                  ),
                );
              }
              try{
                return Padding(
                  padding:  EdgeInsets.only(left: leftPadding),
                  child: Text('${(value as Map)['${itemMapKey}']}'),
                );
                // return Container(
                //   // color: Colors.blue,
                //   child: Column(
                //                             children: [
                //             if(isextra_text==false)
                //             Text((value as Map)['${itemMapKey}']),
                //             if(isextra_text==true)
                //             Text('${extra_text}'+(value as Map)['${itemMapKey}']),
                //             // Divider(),
                //           ],
                //   ),
                // );

              }catch(e){
                print('Error in catch block  5d55 $e');
              }
              return Container(
                decoration: const BoxDecoration(
                    // color:Colors.green,
                    // border: Border(bottom: BorderSide(color: Colors.black12))
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(isextra_text==false)
                      Text(value.toString()),
                    if(isextra_text==true)
                      Text('${extra_text}'+value.toString()),
                    // vSizedBox2
                    // Text(value.toString()),
                    // Divider(),
                  ],
                ),
              );


            },
            itemAsString: (T? value){
              print('this is called');
              try{
                return ' ${(value as Map)['${itemMapKey}']}';
              }catch(e){
                print('Error in catch block  555 $e');
              }
              return '  ${value.toString()}';
            },
            selectedItem: selectedItem,
            onChanged: onChanged,
            // popupTitle: Container(
            //   color: Colors.transparent,
            //   height: 100,
            // ),
            // popupItemBuilderr: ,
          ),
        ),
      ],
    );
  }
}

