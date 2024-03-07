import 'package:ecare/constants/constans.dart';
import 'package:ecare/dialogs/consent_page_dialog.dart';
import 'package:ecare/functions/customDialogBox.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/select_type_page.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/sized_box.dart';
import 'constants/colors.dart';
import 'constants/image_urls.dart';

class Welcome_Page_Next extends StatefulWidget {
  const Welcome_Page_Next({Key? key}) : super(key: key);

  @override
  State<Welcome_Page_Next> createState() => _Welcome_Page_NextState();
}

class _Welcome_Page_NextState extends State<Welcome_Page_Next> {
  PageController controller = PageController();
  page1() {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 24),
            height: MediaQuery.of(context).size.height - 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      MyImages.welcome_background2,
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft
                ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox8,
                vSizedBox16,
                MainHeadingText(
                  text: 'Schedule your next Video \nConsultation, at your leisure,\nin a few easy steps...',
                  color: MyColors.white,
                  fontSize: 25,
                  fontFamily: 'light',
                  height: 1.4,
                ),
                vSizedBox16,
                vSizedBox2,

                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   shadow
                              // ]
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 6 ),
                            child: Row(
                              children: [
                                Image.asset(MyImages.check_icon, height: 24, width: 24,),
                                hSizedBox,
                                ParagraphText(
                                  text: 'General Medical\nDoctors',
                                  color: MyColors.white, fontSize: 14,
                                  fontFamily: 'semibold',
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    vSizedBox2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            // boxShadow: [
                            //   shadow
                            // ]
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12 ),
                          child: Row(
                            children: [
                              Image.asset(MyImages.check_icon, height: 24, width: 24,),
                              hSizedBox,
                              ParagraphText(
                                text: 'Medical Specialists',
                                color: MyColors.white,
                                fontSize: 14,
                                fontFamily: 'semibold',
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    vSizedBox2,
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   shadow
                              // ]
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12 ),
                            child: Row(
                              children: [
                                Image.asset(MyImages.check_icon, height: 24, width: 24,),
                                hSizedBox,
                                Expanded(child: ParagraphText(text: 'Mental Healthcare ', fontFamily: 'semibold',color: MyColors.white, fontSize: 14,))
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    // vSizedBox2,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       width: MediaQuery.of(context).size.width / 2 - 20,
                    //       decoration: BoxDecoration(
                    //         color: MyColors.white.withOpacity(0.3),
                    //         borderRadius: BorderRadius.circular(12),
                    //         // boxShadow: [
                    //         //   shadow
                    //         // ]
                    //       ),
                    //       padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12 ),
                    //       child: Row(
                    //         children: [
                    //           Image.asset(MyImages.check_icon, height: 24, width: 24,),
                    //           hSizedBox,
                    //           ParagraphText(
                    //             text: 'Psychologists ',
                    //             color: MyColors.white,
                    //             fontSize: 14,
                    //             fontFamily: 'semibold',
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    vSizedBox2,
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: MediaQuery.of(context).size.width / 2 - 20,
                    //       decoration: BoxDecoration(
                    //         color: MyColors.white.withOpacity(0.3),
                    //         borderRadius: BorderRadius.circular(12),
                    //         // boxShadow: [
                    //         //   shadow
                    //         // ]
                    //       ),
                    //       padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12 ),
                    //       child: Row(
                    //         children: [
                    //           Image.asset(MyImages.check_icon, height: 24, width: 24,),
                    //           hSizedBox,
                    //           ParagraphText(text: 'Allied Healthcare', fontFamily: 'semibold',
                    //             color: MyColors.white, fontSize: 14,)
                    //         ],
                    //       ),
                    //     ),
                    //     Container(
                    //
                    //     ),
                    //   ],
                    // ),
                    vSizedBox2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          decoration: BoxDecoration(
                            color: MyColors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            // boxShadow: [
                            //   shadow
                            // ]
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12 ),
                          child: Row(
                            children: [
                              Image.asset(MyImages.check_icon, height: 24, width: 24,),
                              hSizedBox,
                              Expanded(
                                child: ParagraphText(
                                  text: 'Allied Healthcare ',
                                  color: MyColors.white,
                                  fontSize: 14,
                                  fontFamily: 'semibold',
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    vSizedBox2,
                  ],
                )

              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                itemCount: 1,
                controller: controller,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return page1();
                    default:
                      return page1();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        backgroundColor: Color(0xFFCAE6FF),
        onPressed: () async{
          bool? result = await showCustomDialogBox(context: context, child: ConsentPageDialog());
          // return;

          if(result==true){
            push(context: context, screen: Select_Type_Page());
          }

        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.arrow_forward_outlined,
          size: 20,
          color: MyColors.headingcolor,
        ),
      ),
    );
  }
}
