import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/doctor_module/changePassword.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/booking_status.dart';
import 'package:ecare/pages/contact_us.dart';
import 'package:ecare/pages/create-profile.dart';
import 'package:ecare/pages/document.dart';
import 'package:ecare/pages/invoice.dart';
import 'package:ecare/pages/lab_test.dart';
import 'package:ecare/pages/messages.dart';
import 'package:ecare/pages/my_health_profile.dart';
import 'package:ecare/pages/setting.dart';
import 'package:ecare/pages/sick_notes.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/getCareblocks.dart';
import 'package:flutter/material.dart';

import '../constants/sized_box.dart';
import '../services/auth.dart';
import '../welcome.dart';
import 'booked_visit.dart';
import 'icd_codes_and_my_invoice_page.dart';
import 'my_visit.dart';

class MyECare extends StatefulWidget {
  const MyECare({Key? key}) : super(key: key);

  @override
  State<MyECare> createState() => _MyECareState();
}

class _MyECareState extends State<MyECare> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        // backgroundColor: Color(0xFE00A2EA).withOpacity(0.1),
        backgroundColor: MyColors.BgColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: CustomCircularImage(
              imageUrl: user_Data!['profile_image'],
              width: 100,
              height: 100,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingPage())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset('assets/images/menu.png', width: 24),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/patter.png', ),
              //   alignment: Alignment.topCenter,
              //   fit: BoxFit.fitWidth,
              // ),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSizedBox2,
              MainHeadingText(
                text: 'My E-Care',
                fontSize: 30,
                fontFamily: 'light',
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (user_Data!['is_skip'].toString() == '1') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateProfile()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHealthProfile()));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Health Profile',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ChangePasswordPage())),
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     padding: EdgeInsets.symmetric(vertical: 16),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 color: MyColors.onsurfacevarient, width: 1))),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(
                  //           text: 'Change Password',
                  //           color: MyColors.onsurfacevarient,
                  //           fontSize: 17,
                  //           fontFamily: 'bold',
                  //         ),
                  //         Icon(Icons.chevron_right_rounded)
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // GestureDetector(
                  //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingStatus())),
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     padding: EdgeInsets.symmetric(vertical: 16),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(color: MyColors.onsurfacevarient, width: 1)
                  //         )
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(text: 'My Booking status', color: MyColors.onsurfacevarient, fontSize: 14, fontFamily: 'light',),
                  //         Icon(Icons.chevron_right_rounded)
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BookedVisit())),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Consultations',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () => Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => VisitPage())),
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     padding: EdgeInsets.symmetric(vertical: 16),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 color: MyColors.onsurfacevarient, width: 1))),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(
                  //           text: 'My Completed Visits',
                  //           color: MyColors.onsurfacevarient,
                  //           fontSize: 17,
                  //           fontFamily: 'bold',
                  //         ),
                  //         Icon(Icons.chevron_right_rounded)
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessagePage())),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Messages',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),

                  // GestureDetector(
                  //   onTap: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => MyInvoicePage())),
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     padding: EdgeInsets.symmetric(vertical: 16),
                  //     decoration: BoxDecoration(
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 color: MyColors.onsurfacevarient, width: 1))),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(
                  //           text: 'My Invoices',
                  //           color: MyColors.onsurfacevarient,
                  //           fontSize: 17,
                  //           fontFamily: 'bold',
                  //         ),
                  //         Icon(Icons.chevron_right_rounded)
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ICDCodesAndMyInvoicePage())),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MainHeadingText(
                              text: 'My Invoices/ Statements with ICD-10 codes',
                              overflow: TextOverflow.ellipsis,
                              color: MyColors.onsurfacevarient,
                              fontSize: 17,
                              fontFamily: 'bold',
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SickNotesPage(
                              is_add_btn: false,
                            ))),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Sick Notes / Medical Certificates',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LabTestPage(
                          doc_name: 'My Prescriptions & Notes',
                        ))),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Prescriptions and Referral Notes',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsPage())),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'Contact Us',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                    GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context1) {
                            return AlertDialog(
                              title: Text(
                                'Logout',
                              ),
                              content: Text('Are you sure, want to logout?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await logout();
                                      // Navigator.of(context).pushReplacementNamed('/pre-login');
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Welcome_Page()),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Text('logout')),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context1);
                                    },
                                    child: Text('cancel')),
                              ],
                            );
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'Logout',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                  // vSizedBox,
                  // GestureDetector(
                  //   child: Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 10),
                  //     padding:
                  //         EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  //     decoration: BoxDecoration(
                  //       color: MyColors.white,
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         MainHeadingText(
                  //           text: 'My Uploaded Documents',
                  //           color: MyColors.onsurfacevarient,
                  //           fontSize: 17,
                  //           fontFamily: 'bold',
                  //         ),
                  //         Icon(Icons.expand_more_rounded)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // vSizedBox05,
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //       color: MyColors.white,
                  //       borderRadius: BorderRadius.circular(15)),
                  //   child: Column(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: (){
                  //
                  //         },
                  //         child: Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 10),
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 16, horizontal: 8),
                  //           decoration: BoxDecoration(
                  //             color: MyColors.white,
                  //             borderRadius: BorderRadius.circular(16),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               MainHeadingText(
                  //                 text: 'Uploaded Images',
                  //                 color: MyColors.onsurfacevarient,
                  //                 fontSize: 17,
                  //                 fontFamily: 'bold',
                  //               ),
                  //               Icon(Icons.chevron_right_rounded)
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //
                  //         },
                  //         child: Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 10),
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 16, horizontal: 8),
                  //           decoration: BoxDecoration(
                  //             color: MyColors.white,
                  //             borderRadius: BorderRadius.circular(16),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               MainHeadingText(
                  //                 text: 'Uploaded Radiology Reports',
                  //                 color: MyColors.onsurfacevarient,
                  //                 fontSize: 17,
                  //                 fontFamily: 'bold',
                  //               ),
                  //               Icon(Icons.chevron_right_rounded)
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //
                  //         },
                  //         child: Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 10),
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 16, horizontal: 8),
                  //           decoration: BoxDecoration(
                  //             color: MyColors.white,
                  //             borderRadius: BorderRadius.circular(16),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               MainHeadingText(
                  //                 text: 'Uploaded Lab Investigations',
                  //                 color: MyColors.onsurfacevarient,
                  //                 fontSize: 17,
                  //                 fontFamily: 'bold',
                  //               ),
                  //               Icon(Icons.chevron_right_rounded)
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         onTap:() {
                  //
                  //         },
                  //         child: Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 10),
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: 16, horizontal: 8),
                  //           decoration: BoxDecoration(
                  //             color: MyColors.white,
                  //             borderRadius: BorderRadius.circular(16),
                  //           ),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               MainHeadingText(
                  //                 text: 'Other Uploaded Documents',
                  //                 color: MyColors.onsurfacevarient,
                  //                 fontSize: 17,
                  //                 fontFamily: 'bold',
                  //               ),
                  //               Icon(Icons.chevron_right_rounded)
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
