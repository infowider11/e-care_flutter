import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
 
import 'package:flutter/material.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({Key? key}) : super(key: key);

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  TextEditingController email = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainHeadingText(text: 'Upload Documents ', fontSize: 32, fontFamily: 'light',),
              vSizedBox2,
              // ParagraphText(fontSize: 16, text: 'If this document is intended for your provider to review, please schedule an appointment for further discussion.'),
              // vSizedBox,
              // ParagraphText(fontSize: 16, text: 'Your provider will be able to view this document during your next visit.'),
              // vSizedBox4,
              // CustomTextField(controller: email, hintText: 'e.g:hyperoxy', label: 'Document name', showlabel: true),
              // vSizedBox2,
              //
              // MainHeadingText(text: 'Patient', fontFamily: 'light', color: MyColors.headingcolor, fontSize: 16),
              // vSizedBox,
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyColors.teritiary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 170,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.add_rounded, color: MyColors.white, size: 18,), hSizedBox,
                          MainHeadingText(text: 'Add Prescription', fontSize: 14, fontFamily: 'light', color: MyColors.white,)
                        ],
                      ),
                    ),
                    vSizedBox2,
                    Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.add_rounded, color: MyColors.white, size: 18,),
                          hSizedBox,
                          MainHeadingText(text: 'Add Sick Note', fontSize: 14, fontFamily: 'light', color: MyColors.white,)
                        ],
                      ),
                    ),
                    vSizedBox2,
                    Container(
                      width: 195,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_rounded, color: MyColors.white, size: 18,),hSizedBox,
                          MainHeadingText(text: 'Add Referral Letters', fontSize: 14, fontFamily: 'light', color: MyColors.white,)
                        ],
                      ),
                    ),
                    vSizedBox2,
                    Container(
                      width: 220,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_rounded, color: MyColors.white, size: 18,),
                          hSizedBox,
                          MainHeadingText(text: 'Add Consultation Notes', fontSize: 14, fontFamily: 'light', color: MyColors.white,)
                        ],
                      ),
                    ),
                    vSizedBox2,



                    // for(var i = 0; i<2; i++)
                    //   Container(
                    //     decoration: BoxDecoration(
                    //         border: Border(
                    //             bottom: BorderSide(
                    //                 color: MyColors.bordercolor,
                    //                 width: 1
                    //             )
                    //         )
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         ParagraphText(text: 'John Smith', color: MyColors.onsurfacevarient, ),
                    //         Checkbox(
                    //           checkColor: Colors.white,
                    //           value: isChecked,
                    //           onChanged: (bool? value) {
                    //             setState(() {
                    //               isChecked = value!;
                    //             });
                    //           },
                    //         )
                    //       ],
                    //     ),
                    //   )
                  ],
                ),
              ),

              vSizedBox2,

              // RoundEdgedButton(text: 'Submit', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Question1Surgeries())),)
            ],
          ),
        ),
      ),
    );
  }
}
