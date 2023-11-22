import 'package:ecare/services/api_urls.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/constans.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/loginpage.dart';
import 'package:ecare/pages/question_2_allergies.dart';
import 'package:ecare/pages/question_2_medication.dart';
import 'package:ecare/pages/review_profile.dart';
import 'package:ecare/pages/who_i_am_page.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/customtextfield.dart';
// import 'package:ecare/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/Customdropdownbutton.dart';
import '../widgets/showSnackbar.dart';

class RelativesPage extends StatefulWidget {
  final bool? is_update;
  final Map? pre_data;
  const RelativesPage({Key? key,this.is_update,this.pre_data}) : super(key: key);

  @override
  State<RelativesPage> createState() => RelativesPageState();
}

class RelativesPageState extends State<RelativesPage>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  List relatives = [];
  Map? selected_value;

  get_relatives() async{
    var res = await Webservices.get(ApiUrls.getrelatives);
    print('list---$res');
    if (res['status'].toString() == '1') {
      relatives = res['data'];
      setState(() {});
    }
  }

  get_info() async{
    setState(() {
      // load=true;
    });
    var res = await Webservices.get(ApiUrls.healthdetail+'?user_id='+await getCurrentUserId()+'m==1');
    print('info-----$res');
    if(res['status'].toString()=='1'){
      // lists=res['data'];
      setState(() {

      });
    }
    setState(() {
      // load=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_relatives();
    print('get-----${widget.pre_data}');
    selected_value = widget.is_update==true?widget.pre_data:null;
    print('selectd_value----$selected_value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            MainHeadingText(
              text: 'Which relatives? ',
              fontSize: 32,
              fontFamily: 'light',
            ),
            vSizedBox,
            ParagraphText(
                fontSize: 16,
                text:
                    'Specify which of your first-degree relatives has each conditions.'),
            vSizedBox2,
            CustomDropdownButton(
              text: 'Relatives',
              itemMapKey: 'name',
              items: relatives,
              hint: 'Select Relatives',
              selectedItem: widget.is_update==true?widget.pre_data:null,
              onChanged: ((dynamic value) => {
                    print('value----$value'),
                    selected_value = value,
                    setState(() {})
                  }),
            ),
            // vSizedBox2,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     ParagraphText(text: 'Alcohol or Drug Abuse'),
            //     Icon(
            //       Icons.highlight_remove_rounded,
            //       size: 20,
            //     )
            //   ],
            // ),
            vSizedBox2,
            RoundEdgedButton(
              text: widget.is_update==true?'Update':'Save',
              onTap: () async{
                if(selected_value!=null){
                  Map<String,dynamic> data = {
                    'user_id':await getCurrentUserId(),
                    'step6':'6',
                    'relative':selected_value!['id'].toString(),
                  };
                  await EasyLoading.show(
                    status: null,
                    maskType: EasyLoadingMaskType.black,
                  );
                  var res = await Webservices.postData(apiUrl: ApiUrls.healthProfile, body: data, context: context);
                  EasyLoading.dismiss();
                  print('step 6-----$res');
                  if(res['status'].toString()=='1'){
                    if(widget.is_update==true)
                      Navigator.pop(context);
                      else
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReviewProfile()));
                  } else {
                    showSnackbar( 'Somting Went Wrong.');
                  }
                } else {
                  showSnackbar( 'Please Select Relative.');
                }
              }
            )
          ],
        ),
      ),
    );
  }
}
