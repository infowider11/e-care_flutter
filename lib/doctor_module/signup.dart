// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/signup_form_1.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../services/validation.dart';

class SignUp_Page_Doctor extends StatefulWidget {
  const SignUp_Page_Doctor({Key? key}) : super(key: key);

  @override
  State<SignUp_Page_Doctor> createState() => _SignUp_Page_DoctorState();
}

class _SignUp_Page_DoctorState extends State<SignUp_Page_Doctor> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController password = TextEditingController();
  String country_code = "";
  String country_short_code = "";
  String gender = 'male';
  bool show_pass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              MyImages.logo,
              height: 100,
              width: MediaQuery.of(context).size.width,
            ),
            vSizedBox,
            const MainHeadingText(
              text: 'SignUp to E-Care',
              fontSize: 32,
              fontFamily: 'light',
              color: MyColors.primaryColor,
            ),
            vSizedBox4,
            CustomTextField(
              controller: fname,
              hintText: 'First Name',
              prefixIcon: MyImages.profile,
              showlabeltop: true,
              label: 'First Name',
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 16,
            ),
            vSizedBox4,
            CustomTextField(
              controller: lname,
              hintText: 'Last Name',
              prefixIcon: MyImages.profile,
              showlabeltop: true,
              label: 'Last Name',
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 16,
            ),
            vSizedBox4,
            Stack(
              clipBehavior: Clip.none,
              children: [
                IntlPhoneField(
                  // showDropdownIcon: false,
                  onChanged: (p) {
                    print('ghdvfh $p');
                    print('onchange value---$p');
                    // phone.text=p.countryCode;
                    country_code = p.countryCode;
                    country_short_code = p.countryISOCode;
                    print('country_code-${country_code.toString()}');
                    setState(() {});
                    // print(p.completeNumber);
                  },
                  onCountryChanged: (country) {
                    // print('country-----$country');
                  },
                  dropdownIcon: const Icon(
                    Icons.phone,
                    color: Colors.transparent,
                  ),
                  controller: phone,
                  decoration: InputDecoration(
                      // suffixIcon: Icon(Icons.phone),
                      // prefixIcon: Icon(Icons.phone,color: Colors.black,),
                      // labelText: 'Phone Number',
                      // floatingLabelAlignment: FloatingLabelAlignment.start,
                      // label:Container(
                      //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      //   decoration: BoxDecoration(
                      //       color: Color(0xFFCAE6FF),
                      //       borderRadius: BorderRadius.circular(10)
                      //   ),
                      //   child: ParagraphText(
                      //     text: "Phone Number",
                      //     fontSize: 16,
                      //     color: MyColors.paragraphcolor,
                      //     fontFamily: 'regular',
                      //   ),
                      // ) ,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: MyColors.bordercolor),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: MyColors.bordercolor),
                          borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: MyColors.bordercolor),
                          borderRadius: BorderRadius.circular(15))
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
                  initialCountryCode: 'ZA', // SOUTH AFRICA
                  // onChanged: (phone) {
                  //   print(phone.completeNumber);
                  // },
                ),
                Positioned(
                  left: 14,
                  top: -10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFCAE6FF),
                        borderRadius: BorderRadius.circular(10)),
                    child: const ParagraphText(
                      text: "Phone Number",
                      fontSize: 12,
                      color: MyColors.paragraphcolor,
                      fontFamily: 'regular',
                    ),
                  ),
                ),
              ],
            ),
            vSizedBox,
            CustomTextField(
              controller: email,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: MyImages.profile,
              showlabeltop: true,
              label: 'Email',
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 16,
            ),
            vSizedBox4,
            GestureDetector(
              onTap: () async {
                var m = await showDatePicker(
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: DateTime(DateTime.now().year - 16),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(DateTime.now().year - 15));
                if (m != null) {
                  DateFormat formatter = DateFormat('yyyy-MM-dd');
                  String formatted = formatter.format(m);
                  dob.text = formatted;
                  // print('checking date------${formatted}');
                }
              },
              child: CustomTextField(
                controller: dob,
                hintText: 'Date of birth',
                prefixIcon: MyImages.date,
                showlabeltop: true,
                enabled: false,
                label: 'DOB',
                labelfont: 12,
                labelcolor: MyColors.paragraphcolor,
                bgColor: Colors.transparent,
                fontsize: 16,
                hintcolor: MyColors.headingcolor,
                suffixheight: 16,
              ),
            ),
            vSizedBox4,
            CustomTextField(
              obscureText: !show_pass,
              suffix: IconButton(
                onPressed: () {
                  show_pass = !show_pass;
                  setState(() {});
                },
                icon: show_pass
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              controller: password,
              hintText: '**********',
              prefixIcon: MyImages.password,
              showlabeltop: true,
              label: 'Password',
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 18,
            ),
            vSizedBox2,
            const MainHeadingText(
              text: 'Select Gender',
              color: MyColors.onsurfacevarient,
              fontSize: 14,
              fontFamily: 'light',
            ),
            vSizedBox,
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    gender = 'male';
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: (gender == 'male')
                              ? MyColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: MyColors.primaryColor, width: 1)),
                      child: ParagraphText(
                        text: 'Male',
                        fontFamily: 'light',
                        fontSize: 11,
                        color: (gender == 'male')
                            ? MyColors.white
                            : MyColors.headingcolor,
                      )),
                ),
                hSizedBox,
                GestureDetector(
                  onTap: () {
                    gender = 'female';
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: (gender == 'female')
                              ? MyColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: MyColors.bordercolor, width: 1)),
                      child: ParagraphText(
                        text: 'Female',
                        fontFamily: 'light',
                        fontSize: 11,
                        color: (gender == 'female')
                            ? MyColors.white
                            : MyColors.headingcolor,
                      )),
                ),
              ],
            ),
            vSizedBox2,
            RoundEdgedButton(
              text: 'Continue',
              onTap: () {
                // print(phone.)
                if (validateString(fname.text, "Please enter your first name.",
                            context) ==
                        null &&
                    validateString(lname.text, "Please enter your last name.",
                            context) ==
                        null &&
                    validateString(phone.text,
                            "Please enter your phone number.", context) ==
                        null &&
                    validateEmail(email.text, context) == null &&
                    validateString(dob.text, "Please enter your date of birth.",
                            context) ==
                        null &&
                    validateString(password.text,
                            "Please enter your last name.", context) ==
                        null) {
                  Map<String, dynamic> data = {
                    "first_name": fname.text,
                    "last_name": lname.text,
                    "phone": phone.text,
                    "country_code": country_short_code.toString(),
                    "phone_code": country_code.toString(),
                    "email": email.text,
                    "dob": dob.text,
                    "password": password.text,
                    "gender": gender.toString(),
                    "type": '1' //1 for doctor
                  };
                  print('[data]------${data}');
                  push(
                      context: context,
                      screen: SignUpForm1(
                        data: data,
                      ));
                }
              },
            ),
            vSizedBox2,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ParagraphText(
                  text: 'Already have an account? ',
                ),
                GestureDetector(
                  onTap: () {
                    push(context: context, screen: const LoginPage());
                  },
                  child: const ParagraphText(
                    text: 'Login',
                    fontFamily: 'semibold',
                    underlined: true,
                  ),
                ),
              ],
            ),
            vSizedBox4,
          ],
        ),
      ),
    );
  }
}
