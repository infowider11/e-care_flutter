import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
import 'package:ecare/widgets/showSnackbar.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Services/api_urls.dart';
import '../services/validation.dart';
import '../services/webservices.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();
  bool load=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body:Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Image.asset(
              MyImages.logo,
              height: 100,
              width: MediaQuery.of(context).size.width,
            ),
            vSizedBox,
            // MainHeadingText(text: 'SignUp to E-Care', fontSize: 32, fontFamily: 'light', color: MyColors.primaryColor,),
            vSizedBox4,
            CustomTextField(
              controller: email,
              hintText: 'Email Address',
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
            RoundEdgedButton(
              text: 'Send',
              onTap: () async {
                if(validateEmail(email.text, context) == null){
                  await EasyLoading.show(
                    status: null,
                    maskType: EasyLoadingMaskType.black,
                  );
                  setState(() {
                    load=true;
                  });
                  var res=await Webservices.get('${ApiUrls.forgot}?email=${email.text}');
                  await EasyLoading.dismiss();

                  setState(() {
                    load=false;
                  });
              if(res['status'].toString()=='1'){
                Navigator.pop(context);
                showSnackbar( res['message'].toString());
              }
              else{
                showSnackbar( res['message'].toString());
              }

                }
              },
            ),
            vSizedBox6,
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     Divider(
            //       color: MyColors.headingcolor,
            //       // thickness: 1,
            //       height: 40,
            //     ),
            //
            //     Container(
            //       height: 30,
            //       decoration: BoxDecoration(
            //         color: Color(0xFFCAE6FF),
            //         borderRadius: BorderRadius.circular(8),
            //
            //       ),
            //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           ParagraphText(
            //             text: 'Or Sign in with Google account',
            //             fontFamily: 'light',
            //             color: MyColors.headingcolor,
            //             fontSize: 12,
            //           ),
            //         ],
            //       ),
            //     )
            //
            //   ],
            // ),
            // vSizedBox2,
            // Center(child: Image.asset(MyImages.google, height: 30,)),
            // vSizedBox2,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ParagraphText(
            //       text: 'already have an account? ',
            //     ),
            //     GestureDetector(
            //       onTap: (){
            //         push(context: context, screen: LoginPage());
            //       },
            //       child: ParagraphText(
            //         text: 'Login',
            //         fontFamily: 'semibold',
            //         underlined: true,
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
