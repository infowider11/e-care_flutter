import 'package:ecare/constants/colors.dart';
import 'package:ecare/doctor_module/hpcsa-form.dart';
import 'package:ecare/doctor_module/my_wallet.dart';
import 'package:ecare/doctor_module/setting.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/consultation_notes.dart';
import 'package:ecare/pages/contact_us.dart';
import 'package:ecare/pages/messages.dart';
import 'package:ecare/pages/payment_method.dart';
import 'package:ecare/pages/prescriptions_doctor.dart';
import 'package:ecare/pages/privacy_policy.dart';
import 'package:ecare/pages/referral_letter.dart';
import 'package:ecare/pages/sick_notes.dart';
import 'package:ecare/pages/terms_cond_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/sized_box.dart';
import '../functions/global_Var.dart';
import '../pages/add_bank_account_page.dart';
import '../pages/icdCodesPage.dart';
import '../services/auth.dart';
import '../welcome.dart';
import 'notification.dart';

class DoctorMyECare extends StatefulWidget {
  const DoctorMyECare({Key? key}) : super(key: key);

  @override
  State<DoctorMyECare> createState() => _DoctorMyECareState();
}

class _DoctorMyECareState extends State<DoctorMyECare> {
  TextEditingController amount = TextEditingController();
  bool issubmenu = false;
  Map userData = {}..addAll(user_Data!);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  getDetail() async {
    // userData = await getUserDetails();
    var id= await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}');
    print('prasoon $res');
    if(res['status'].toString()=='1'){
      userData=res['data'];
      amount.text=userData['consultation_fees'];
      setState(() {

      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        backgroundColor: MyColors.BgColor,
        automaticallyImplyLeading: false,
        title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network('${userData['profile_image']}',
                        width: 35)),
                hSizedBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(
                      text:
                          '${userData['first_name']} ${userData['last_name']}',
                      fontFamily: 'light',
                      fontSize: 15,
                    ),
                    MainHeadingText(
                      text: 'Welcome Back!',
                      fontFamily: 'light',
                      color: MyColors.primaryColor,
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            )),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorNotificationPage()));
              getDetail();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.notifications,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
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
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorSettingPage()));
                      getDetail();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: MyColors.onsurfacevarient, width: 1))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Profile',
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
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => hpcsaregistration()));
                      // getDetail();
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
                            text: 'My HPCSA Registration',
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
                        MaterialPageRoute(builder: (context) => MyWallet())),
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
                            text: 'My Earnings',
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
                        MaterialPageRoute(builder: (context) => MessagePage())),
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
                            text: 'My Messages ',
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
                  //           builder: (context) => PaymentMethod())),
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
                  //           text: 'Payment method and payment history',
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
                    onTap: () {
                      push(context: context, screen: AddBankAccountPage());
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient,
                                  width:  1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Banking Details',
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
                    onTap: () {
                      setState(() {
                        issubmenu = !issubmenu;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: issubmenu
                                      ? Colors.transparent
                                      : MyColors.onsurfacevarient,
                                  width: issubmenu ? 0 : 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainHeadingText(
                            text: 'My Consultation Documents',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          if(issubmenu)Icon(Icons.expand_more_outlined),
                          if(!issubmenu)Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                  // if (issubmenu)
                  // vSizedBox05,
                  if (issubmenu)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              push(
                                  context: context,
                                  screen: Prescriptions_Doctor_Page());
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MainHeadingText(
                                    text: 'Prescriptions',
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
                                    builder: (context) => SickNotesPage())),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MainHeadingText(
                                    text: 'Sick note',
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
                            onTap: () {
                              push(
                                  context: context,
                                  screen: Referral_Letter_Page());
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MainHeadingText(
                                    text: 'Referral letters',
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
                            onTap: () {
                              // showSnackbar('Coming soon 1234');
                              push(
                                  context: context,
                                  screen: IcdCodesPage());
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  MainHeadingText(
                                    text: 'Statements with ICD-10 codes',
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
                            onTap: () {
                              push(
                                  context: context,
                                  screen: Consultation_Notes_Page());
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MainHeadingText(
                                    text: 'My Consultation notes',
                                    color: MyColors.onsurfacevarient,
                                    fontSize: 17,
                                    fontFamily: 'bold',
                                  ),
                                  Icon(Icons.chevron_right_rounded)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColors.onsurfacevarient, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainHeadingText(
                                  text: 'My Consultation Rates',
                                  color: MyColors.onsurfacevarient,
                                  fontSize: 17,
                                  fontFamily: 'bold',
                                ),
                                vSizedBox05,
                                ParagraphText(
                                  text:
                                      'E-Care\'s administration fee varies between 15 to 20% of your consultation fee and will be deducted from your consultation fee',
                                  fontSize: 11,
                                  fontFamily: 'light',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MainHeadingText(
                                  text:
                                      '${userData['consultation_fees']??'0'} ZAR',
                                  color: MyColors.primaryColor,
                                  fontSize: 12,
                                  fontFamily: 'light',
                                ),
                                px3,
                                GestureDetector(
                                    onTap: () => {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Stack(
                                                children: <Widget>[
                                                  Positioned(
                                                    right: -40.0,
                                                    top: -40.0,
                                                    child: InkResponse(
                                                      onTap: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child: Icon(Icons.close),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  Form(
                                                    // key: ,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[

                                                        Align(
                                                          heightFactor: 0.8,
                                                          alignment: Alignment.topRight,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                              size: 25,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Text('Consultant Fee',style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.w600,
                                                          ),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            keyboardType: TextInputType.number,
                                                            decoration: InputDecoration(
                                                                hintText: 'Enter Amount.'
                                                            ),
                                                            controller: amount,

                                                            // hi: 'Enter Amount.',
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: ElevatedButton(
                                                            // color: MyColors.primaryColor,
                                                            child: Text("Submit",style: TextStyle(color: MyColors.primaryColor),),
                                                            onPressed: () async{
                                                              // Navigator.pop(context);
                                                              // return;
                                                              if(amount.text==''){
                                                                showSnackbar( 'Please Enter Amount.');
                                                              } else if(int.parse(amount.text)==0) {
                                                                showSnackbar( 'Amount should be getter then 0.');
                                                                } else {
                                                                Map<String,dynamic> data = {
                                                                  'consultation_fees':amount.text,
                                                                  'user_id':userData['id'].toString()
                                                                };
                                                                await EasyLoading.show(
                                                                  status: null,
                                                                  maskType: EasyLoadingMaskType.black,
                                                                );
                                                                var res = await Webservices.postData(apiUrl: ApiUrls.editconsultantfees, body: data, context: context);
                                                                print('update---$res');
                                                                await EasyLoading.dismiss();
                                                                if(res['status'].toString()=='1'){
                                                                  getDetail();
                                                                  showSnackbar( res['message']);
                                                                  Navigator.pop(context);
                                                                }
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    },
                                  behavior: HitTestBehavior.translucent,
                                  child:Icon(Icons.edit,color: MyColors.primaryColor,size: 22.0,),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorNotificationPage())),
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
                            text: 'My Notifications',
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
                            builder: (context) => PrivacyPolicy())),
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
                            text: 'Privacy policy',
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
                            builder: (context) => TermsCondPage())),
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
                            text: 'Terms and conditions',
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
                    onTap: () => {
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
                          }),
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
                            text: 'Sign Out',
                            color: MyColors.onsurfacevarient,
                            fontSize: 17,
                            fontFamily: 'bold',
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              vSizedBox16,
              vSizedBox16,
              vSizedBox16,
              vSizedBox16,
            ],
          ),
        ),
      ),
    );
  }
}
