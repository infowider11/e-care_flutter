import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_1_allergies.dart';
import 'package:ecare/pages/question_1_condition.dart';
import 'package:ecare/pages/question_1_medication.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/dropdown.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../services/auth.dart';
import '../services/webservices.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController msg = TextEditingController();
  bool load = false;
  String? country_code;
  String? country_short_code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_current_user();
  }

  get_current_user() async {
    var id = await getCurrentUserId();
    setState(() {
      load = true;
    });
    Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}')
        .then((value) async {
      print('the status is ${value}');
      if(value['status'].toString()=='1'){
        email.text=value['data']['email'];
        phone.text=value['data']['phone'];
        country_code=value['data']['phone_code'];
        country_short_code=value['data']['country_code'];
        name.text=value['data']['first_name']+' '+value['data']['last_name'];
        setState(() {

        });
      }
      // if()
      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context,title: 'Contact Us',fontsize: 20,fontfamily: 'light'),
      body: load?CustomLoader():SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MainHeadingText(
            //   text: 'Contact Us ',
            //   fontSize: 32,
            //   fontFamily: 'light',
            // ),
            // vSizedBox4,
            Column(
              children: [
                CustomTextField(
                    controller: name,
                    label: 'Full Name',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'John '),
                vSizedBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone number'),
                    IntlPhoneField(
                      onChanged: (p) {
                        print('ghdvfh');
                        // phone.text=p.countryCode;
                        country_code = p.countryCode;
                        country_short_code = p.countryISOCode;
                        print('country_code-${country_code.toString()}');
                        setState((){});
                        // print(p.completeNumber);
                      },
                      onCountryChanged: ((c) => {
                        print('country----${c.code}'),
                        country_short_code = c.code,
                        setState(() {

                        }),
                      }),
                      dropdownIcon:Icon(Icons.phone,color: Colors.transparent,) ,
                      controller: phone,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: MyColors.bordercolor),
                              borderRadius: BorderRadius.circular(15)
                          )
                        // labelStyle: TextStyle(color:MyColors.paragraphcolor, backgroundColor: Color(0xFFCAE6FF)),
                        // enabledBorder:InputBorder(borderSide: BorderSide(Border.all(color: bordercolor))),
                        // focusedBorder: InputBorder(
                        //   borderSide: BorderSide(color: MyColors.bordercolor),
                        // ),
                        // border: InputBorder(
                        //   borderSide: BorderSide(color: MyColors.bordercolor),
                        // ),


                        // focusedBorder: Border.all()
                      ),
                      initialCountryCode: country_short_code, // SOUTH AFRICA
                      // onChanged: (phone) {
                      //   print(phone.completeNumber);
                      // },
                    ),
                  ],
                ),
                // CustomTextField(
                //     controller: phone,
                //     label: 'Phone number',
                //     keyboardType: TextInputType.number,
                //     showlabel: true,
                //     labelcolor: MyColors.onsurfacevarient,
                //     hintText: '+91 9898989959'),



                vSizedBox,
                CustomTextField(
                    controller: email,
                    label: 'Email',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'Email Address'),
                vSizedBox,
                CustomTextField(
                    maxLines: 5,
                    height: 120,
                    controller: msg,
                    label: 'Message',
                    showlabel: true,
                    labelcolor: MyColors.onsurfacevarient,
                    hintText: 'hi there!'),
                vSizedBox,
              ],
            ),
            vSizedBox2,
            RoundEdgedButton(
              text: 'Send',
              onTap: () async{
                if(name.text==''){
                  showSnackbar( 'Please enter full name.');
                } else if (phone.text=='') {
                  showSnackbar( 'Please enter phone number.');
                } else if(email.text==''){
                  showSnackbar( 'Please enter email.');
                } else if(msg.text==''){
                  showSnackbar( 'Please enter message.');
                } else {
                  Map<String,dynamic> data = {
                    'name':name.text,
                    'email':email.text,
                    'phone':phone.text,
                    'country_code':country_short_code,
                    'phone_code':country_code.toString(),
                    'message':msg.text,
                  };
                  setState(() {
                    load=true;
                  });
                  var res = await Webservices.postData(apiUrl: ApiUrls.ContactUs, body: data, context: context);
                  setState(() {
                    load=false;
                  });
                  print('ssss---$res');
                  if(res['status'].toString()=='1'){
                    Navigator.pop(context);
                    showSnackbar(res['message']);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
