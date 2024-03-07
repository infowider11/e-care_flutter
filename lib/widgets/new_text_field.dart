// import 'package:ecare/widgets/customtextfield.dart';
// import 'package:flutter/material.dart';
//
// class NewCustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final String label;
//   final String labelfontfamily;
//   final BoxBorder? border;
//   final double horizontalPadding;
//   final bool obscureText;
//   final int? maxLines;
//   final Color bgColor;
//   final Color inputbordercolor;
//   final Color hintcolor;
//   final Color labelcolor;
//   final Color bordercolor;
//   final double fontsize;
//   final double labelfont;
//   final double left;
//   final double suffixheight;
//   final double height;
//   final double borderradius;
//   final double verticalPadding;
//   final String? prefixIcon;
//   final String? suffixIcon;
//   final TextAlign textAlign;
//   final double paddingsuffix;
//   final TextInputType? keyboardType;
//   final bool? enabled;
//   final bool boxshadow;
//   final bool showlabel;
//   final bool showlabeltop;
//   final Widget? suffix;
//   final Widget? preffix;
//   final bool? is_prefix_icon_widget;
//   final Function(String)? onChange;
//   final Function()? prefixonChange;
//   final Widget? prefix_widget_icon;
//   const NewCustomTextField({ Key? key,
//     required this.controller,
//     this.is_prefix_icon_widget=false,
//     this.prefix_widget_icon,
//     this.prefixonChange,
//     this.preffix,
//     required this.hintText,
//     this.label = 'label',
//     this.border,
//     this.onChange,
//     this.labelfontfamily = 'regular',
//     this.maxLines,
//     this.horizontalPadding = 0,
//     this.suffix,
//     this.enabled = true,
//     this.keyboardType=TextInputType.text,
//     // this.verticalPadding = false,
//     this.obscureText = false,
//     this.bgColor = Colors.white,
//     this.inputbordercolor = Colors.transparent,
//     this.bordercolor = MyColors.bordercolor,
//     this.hintcolor = MyColors.textcolor,
//     this.labelcolor = MyColors.headingcolor,
//     this.verticalPadding = 0,
//     this.fontsize = 13,
//     this.labelfont = 14,
//     this.left = 16,
//     this.suffixheight = 10,
//     this.height = 56,
//     this.borderradius = 15,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.textAlign = TextAlign.left,
//     this.paddingsuffix = 12,
//     this.boxshadow=false,
//     this.showlabel= false,
//     this.showlabeltop= false,}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CustomTextField(
//           controller:  controller,
//           hintText: hintText,
//           height: height,
//           maxLines: maxLines,
//           keyboardType: keyboardType,
//         )
//       ],
//     );
//   }
// }
