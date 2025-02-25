// ignore_for_file: avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/pages/temperature.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
 
import 'package:flutter/material.dart';

import 'choose_doctor.dart';

class HowLongFeltThisWay extends StatefulWidget {
  final Map? cate;
  final Map? sub_cate;
  final String? other_reason;
  const HowLongFeltThisWay(
      {Key? key, this.cate, this.sub_cate, this.other_reason})
      : super(key: key);

  @override
  State<HowLongFeltThisWay> createState() => _HowLongFeltThisWayState();
}

class _HowLongFeltThisWayState extends State<HowLongFeltThisWay> {
  TextEditingController days = TextEditingController();

  @override
  void initState() {
    
    super.initState();
    print('cate---${widget.cate}---------sub-cate----${widget.sub_cate}');
    print('other reason---${widget.other_reason}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(
                text: (widget.cate!['id'].toString() == '1')
                    ? 'How long have you felt this way?'
                    : 'Please add a small note describing your condition/ needs from this consultation to assist your healthcare practitioner in understanding your needs',
                fontSize: 32,
                fontFamily: 'light',
              ),
              vSizedBox4,
              RoundEdgedButton(
                  text: 'Continue',
                  onTap: () {
                    // if(validateString(days.text,'Please Enter Field', context))
                    if (widget.cate!['id'].toString() == '1') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TemparaturePage(
                                cate: widget.cate,
                                sub_cate: widget.sub_cate,
                                other_reason: widget.other_reason,
                                days: days.text,
                              )));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SyptomsPage(
                      //               cate: widget.cate,
                      //               sub_cate: widget.sub_cate,
                      //               other_reason: widget.other_reason,
                      //               days: days.text,
                      //             )));

                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseDoctor(
                                cate: widget.cate,
                                sub_cate: widget.sub_cate,
                                other_reason: widget.other_reason,
                                days: days.text,
                              )));
                    }
                  }),
              vSizedBox2,
              Column(
                // mainAxisSize: MainAxisSize.,
                children: [
                  Row(
                    children: [
                      Expanded(
                        // flex: 8,
                        child: CustomTextField(
                          maxLines:
                              (widget.cate!['id'].toString() == '1') ? 1 : 20,
                          height:
                              (widget.cate!['id'].toString() == '1') ? 56 : 200,
                          controller: days,
                          hintText: (widget.cate!['id'].toString() == '1')
                              ? 'Days'
                              : 'Please add a small description…',
                          keyboardType: (widget.cate!['id'].toString() == '1')
                              ? TextInputType.number
                              : null,
                        ),
                      ),
                      // hSizedBox,
                      // Expanded(
                      //   flex: 4,
                      //   child: DropDown(),
                      // )
                    ],
                  ),
                  vSizedBox
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
