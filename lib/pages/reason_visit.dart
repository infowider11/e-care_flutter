// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/long_felt_way.dart';
import 'package:ecare/pages/other_reason_visit.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
// ignore: unused_import
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../services/api_urls.dart';
import '../services/webservices.dart';

class ReasonPage extends StatefulWidget {
  final Map? cate;
  const ReasonPage({Key? key, this.cate}) : super(key: key);

  @override
  State<ReasonPage> createState() => _ReasonPageState();
}

class _ReasonPageState extends State<ReasonPage> {
  TextEditingController search = TextEditingController();
  bool load = false;
  List lists = [];

  @override
  void initState() {
    
    super.initState();
    print('working-----${widget.cate}');
    // get_subcate();
    filterSubcategory();
  }
filterSubcategory(){
 lists = categories.where((element) => element['parent'] ==widget.cate!['id'] ,).toList();
 setState(() {
   
 });
}
  get_subcate() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.getList(
        ApiUrls.getSpecialistCategory + "?cat=" + widget.cate!['id']);
    print('subcate------$res');
    lists = res;
    setState(() {});
    setState(() {
      load = false;
    });
    if(widget.cate!['id'].toString()=='1'||lists.length==0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReasonVisit(
                cate: widget.cate,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context),
      body: load
          ? const CustomLoader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeadingText(
                    text: widget.cate!['id'].toString() == '28'
                        ? 'Please select the type of Allied Healthcare suitable for your needs.'
                        : widget.cate!['id'].toString() == '23'
                            ? 'Please select the type of Mental Healthcare suitable for your needs.'
                            : widget.cate!['id'].toString() == '2'
                                ? 'Please select the type of Medical Specialists suitable for your needs.'
                                : ''
                                    'Please select the type of General Medical Doctor suitable for your needs.',
                    fontFamily: 'light',
                    fontSize: 32,
                  ),
                  // vSizedBox2,
                  // CustomTextField(
                  //   onChange: ((val) => {
                  //         setState(() {}),
                  //       }),
                  //   controller: search,
                  //   hintText: 'Search...',
                  //   borderradius: 20,
                  // ),
                  vSizedBox05,
                  //  Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 10.0),
                  //       child: RoundEdgedButton(
                  //         onTap: () => Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => HowLongFeltThisWay(
                  //                       cate: widget.cate,
                  //                     ))),
                  //         text: 'Continue with only Category Basis',
                  //         bordercolor: MyColors.primaryColor,
                  //         color: MyColors.white,
                  //         textColor: MyColors.primaryColor,
                  //       ),
                  //     ),
                  vSizedBox05,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if(widget.cate!['id'].toString()!='23')
                      // ParagraphText(
                      //   text: 'Or Choose from top reasons',
                      //   fontSize: 12,
                      // ),
                      // vSizedBox,
                      if(widget.cate!['id'].toString()=='1')
                      GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReasonVisit(
                                        cate: widget.cate,
                                      ))),
                          child: const ParagraphText(
                              text: 'Other Reason',
                              fontSize: 16,
                              color: MyColors.primaryColor)),
                    ],
                  ),
                   if(widget.cate!['id'].toString()=='1')
                  vSizedBox2,
                  for (int i = 0; i < lists.length; i++)
                    if (((lists[i]['title'].toLowerCase() as String)
                            .contains(search.text) ||
                        (lists[i]['title'].toUpperCase() as String)
                            .contains(search.text)))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: RoundEdgedButton(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HowLongFeltThisWay(
                                        cate: widget.cate,
                                        sub_cate: lists[i],
                                      ))),
                          text: '${lists[i]['title']}',
                          bordercolor: MyColors.primaryColor,
                          color: MyColors.white,
                          textColor: MyColors.primaryColor,
                        ),
                      ),
                  if (lists.isEmpty)
                    const  Center(
                        child: Text('No Data Found.'),
                      
                    )
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'Cough',
                  //   bordercolor: MyColors.bordercolor,
                  //   color: MyColors.white,
                  //   textColor: MyColors.onsurfacevarient,
                  // ),
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'Coronavirus (Covid-19) evaluation',
                  //   bordercolor: MyColors.bordercolor,
                  //   color: MyColors.white,
                  //   textColor: MyColors.onsurfacevarient,
                  // ),
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'Influenza(flu)',
                  //   bordercolor: MyColors.bordercolor,
                  //   color: MyColors.white,
                  //   textColor: MyColors.onsurfacevarient,
                  // ),
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'Nasal congestion',
                  //   bordercolor: MyColors.bordercolor,
                  //   color: MyColors.white,
                  //   textColor: MyColors.onsurfacevarient,
                  // ),
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'sore throat',
                  //   bordercolor: MyColors.bordercolor,
                  //   color: MyColors.white,
                  //   textColor: MyColors.onsurfacevarient,
                  // ),
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'Allergies',
                  //   bordercolor: MyColors.bordercolor,
                  //   color: MyColors.white,
                  //   textColor: MyColors.onsurfacevarient,
                  // ),
                  // vSizedBox,
                  // RoundEdgedButton(
                  //   text: 'See all',
                  //   bordercolor: MyColors.primaryColor,
                  //   textColor: MyColors.white,
                  // ),
                ],
              ),
            ),
    );
  }
}
