import 'package:ecare/Services/api_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants/colors.dart';
import '../constants/image_urls.dart';
import '../services/auth.dart';
import '../services/validation.dart';
import '../services/webservices.dart';
import '../widgets/buttons.dart';
import '../widgets/customtextfield.dart';
import '../widgets/loader.dart';
import '../widgets/showSnackbar.dart';
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldpassword=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController cpassword=TextEditingController();
bool load=false;
bool old=false;
bool newpass =false;
bool cpass =false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'),),
      body:SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          
          children: [
            vSizedBox4,
            CustomTextField(
              controller: oldpassword,
              obscureText: !old,
              hintText: '**********',
              prefixIcon: MyImages.password,
              showlabeltop: true,
              label: 'Current Password',
              suffix: IconButton(
                onPressed: (){
                  old=!old;
                  setState(() {

                  });
                },
                icon: old?Icon(Icons.visibility_off):Icon(Icons.visibility),
              ),
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 18,
            ),
            vSizedBox4,
            CustomTextField(
              controller: password,
              obscureText: !newpass,
              suffix: IconButton(
                onPressed: (){
                  newpass=!newpass;
                  setState(() {

                  });
                },
                icon: newpass?Icon(Icons.visibility_off):Icon(Icons.visibility),
              ),
              hintText: '**********',
              prefixIcon: MyImages.password,
              showlabeltop: true,
              label: 'New Password',
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 18,
            ),
            vSizedBox4,
            CustomTextField(
              controller: cpassword,
              obscureText: !cpass,
              suffix: IconButton(
                onPressed: (){
                  cpass=!cpass;
                  setState(() {

                  });
                },
                icon: cpass?Icon(Icons.visibility_off):Icon(Icons.visibility),
              ),
              hintText: '**********',
              prefixIcon: MyImages.password,
              showlabeltop: true,
              label: 'Confirm Password',
              labelfont: 12,
              labelcolor: MyColors.paragraphcolor,
              bgColor: Colors.transparent,
              fontsize: 16,
              hintcolor: MyColors.headingcolor,
              suffixheight: 18,
            ),
            vSizedBox4,

            vSizedBox4,
            RoundEdgedButton(
                text: 'Update',
                onTap: () async {
                  if (oldpassword.text == '') {
                    showSnackbar( 'Please enter your password.');
                  }else if(password.text == ''){
                    showSnackbar( 'Please Enter your New Password.');

                  }  else if (cpassword.text=='') {
                    showSnackbar( 'Please Enter your Confirm Password.');

                  }   else if(cpassword.text!=password.text){
                    showSnackbar( 'Confirm Password and New password should be same.');

                  }
                  else{
                    Map<String, dynamic> data = {
                      'user_password':oldpassword.text,
                      'new_password':password.text,
                      'confirm_password':cpassword.text,
                      'user_id': await getCurrentUserId()

                    } ;
                    await EasyLoading.show(
                      status: null,
                      maskType: EasyLoadingMaskType.black,
                    );
                    setState(() {
                      load=true;
                    });
                    var res = await Webservices.postData(apiUrl: ApiUrls.change_password, body: data, showSuccessMessage: true);
                    await EasyLoading.dismiss();

                    setState(() {
                      load=false;
                    });
                    if(res['status'].toString()=='1'){
                      showSnackbar( res['message']);
                      Navigator.pop(context);
                    }
                    // else{
                    // showSnackbar( res['message']);
                    //
                    // }
                  };

                }),
          ],
        ),
      ),
    );
  }
}
