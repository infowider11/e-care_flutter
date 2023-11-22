import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/doctor_module/money_request.dart';
import 'package:ecare/pages/add_new_card.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../functions/global_Var.dart';
import '../services/api_urls.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  List lists = [];
  bool load = false;
  String? wallet_amt;

  @override
  void initState() {
    // TODO: implement initState
    getDetail();
    get_lists();
    super.initState();
  }

  get_lists() async{
    setState(() {
      load = true;
    });
    Map<String,dynamic> data = {
      'doctor_id': await getCurrentUserId(),
    };
    var res = await Webservices.postData(apiUrl:ApiUrls.my_transactions, body: data, context: context);
    print('list------${res}');
    // wallet_amt = res['wallet_amt'].toString();
    lists = res['data'];

    setState(() {
      load=false;
    });
  }

  getDetail() async {
    // userData = await getUserDetails();
    var id= await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}');
    print('user-data $res');
    if(res['status'].toString()=='1'){
      user_Data=res['data'];
      wallet_amt = res['data']['wallet_amt'].toString();
      setState(() {

      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: appBar(context: context, appBarColor: MyColors.BgColor),
      body: load?CustomLoader():Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/patter.png', ),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeadingText(text: 'My Earnings', fontFamily: 'light', fontSize: 28,),
              vSizedBox2,
              MainHeadingText(text: 'My Earnings', fontSize: 18, fontFamily: 'light',),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyRequest())),
                child: MainHeadingText(text: '${wallet_amt??'0'} ZAR', fontSize: 22, color: MyColors.primaryColor,)
              ),
              MainHeadingText(text: 'Please ensure that your banking details are correct. You will receive payment for your consultation (minus the E-Care administrative fee) once the client has finalized their booking.', fontSize: 13),
              MainHeadingText(color:MyColors.primaryColor,text: '\nPlease note that in the event that a consultation does not take place or a client is unsatisfied with the service received, E-Care may choose to refund the total consultation fee to the client. This refund will be deducted from your next consultation fee.', fontSize: 13),
              vSizedBox4,
              MainHeadingText(text: 'Transaction', fontFamily: 'light', fontSize: 22,),
              vSizedBox,
              for(var i=0; i<lists.length;i++)
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: MyColors.bordercolor,
                      width: 1
                    )
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCircularImage(
                            imageUrl: lists[i]['paitent']['profile_image'],
                            fileType: CustomFileType.network,
                          width: 50,
                          height: 50,
                        ),
                        hSizedBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainHeadingText(text: 'Payment received from ', fontSize: 14, fontFamily: 'light',),
                            MainHeadingText(text: '${lists[i]['paitent']['first_name']} ${lists[i]['paitent']['last_name']??''} for consultation. ', fontSize: 14, fontFamily: 'light',),
                            // MainHeadingText(text: '${lists[i]['paitent']['first_name']} ${lists[i]['paitent']['last_name']??''} for ${lists[i]['specialist_category']['title']} ', fontSize: 14, fontFamily: 'light',),
                            vSizedBox05,
                            MainHeadingText(text: '${lists[i]['human_time']}', color: MyColors.primaryColor, fontSize: 11,),
                            MainHeadingText(text: '${lists[i]['amount']} ZAR', fontSize: 16, color: MyColors.primaryColor,)

                          ],
                        )
                      ],
                    ),
                    // Expanded(
                    //     child:MainHeadingText(text: '${lists[i]['amount']} ZAR', fontSize: 16, color: MyColors.primaryColor,)
                    // )
                  ],
                ),
              ),
              if(lists.length==0)
                Center(
                  heightFactor: 2.0,
                  child: Text('No data found.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
