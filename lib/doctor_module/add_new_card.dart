// import 'package:ecare/constants/colors.dart';
// import 'package:ecare/pages/choose_schedule.dart';
// import 'package:ecare/pages/schedule_appointment.dart';
// import 'package:ecare/widgets/CustomTexts.dart';
// import 'package:ecare/widgets/appbar.dart';
// import 'package:ecare/widgets/buttons.dart';
// import 'package:ecare/widgets/customtextfield.dart';
// import 'package:ecare/widgets/dropdown.dart';
// import 'package:flutter/material.dart';
//
// import '../constants/sized_box.dart';
//
// class AddNewCard extends StatefulWidget {
//   const AddNewCard({Key? key}) : super(key: key);
//
//   @override
//   State<AddNewCard> createState() => _AddNewCardState();
// }
//
// class _AddNewCardState extends State<AddNewCard> {
//   TextEditingController email = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.BgColor,
//       appBar: appBar(
//         context: context,
//         appBarColor: Color(0xFE00A2EA).withOpacity(0.11)
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         color: Color(0xFE00A2EA).withOpacity(0.11),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               MainHeadingText(text: 'Add New Card', fontFamily: 'light', fontSize: 32),
//               vSizedBox4,
//
//               CustomDropdownButton(hint: 'African Bank Limited', islabel: true, label: 'Select your bank name',),
//               vSizedBox,
//
//               DropDown(hint: 'Saving account', islabel: true, label: 'Select  your account type',),
//               vSizedBox,
//
//               CustomTextField(controller: email, hintText: 'john smith', label: 'Enter your branch code', showlabel: true,),
//               vSizedBox,
//
//               CustomTextField(controller: email, hintText: 'john smith', label: 'Name of account holder', showlabel: true,),
//               vSizedBox,
//
//               CustomTextField(controller: email, hintText: 'xxxx/xxxx/xxxx', label: 'Debit Card Number', showlabel: true,),
//               vSizedBox,
//
//               CustomTextField(controller: email, hintText: 'eg. 25/2023 ', label: 'Expiration(MM/YY)', showlabel: true,),
//               vSizedBox,
//
//               CustomTextField(controller: email, hintText: 'xxx', label: 'CVV', showlabel: true,),
//               vSizedBox2,
//
//               RoundEdgedButton(text: 'Save Debit Card')
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }