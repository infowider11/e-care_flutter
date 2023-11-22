import 'package:ecare/constants/global_keys.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:flutter/material.dart';

Future showLoadingPopup()async{
  print('Theeeeeee show dialog is');
  return showDialog(context: MyGlobalKeys.navigatorKey.currentContext!, builder: (context){
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent,
      // backgroundColor: Color(0xFFffffff),
      child: WillPopScope(
        onWillPop: ()async{
          return false;
        },
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 520,
          child: Column(
            children: [
              vSizedBox2,
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(

                  image:DecorationImage(
                    image:  AssetImage(
                        MyImages.sessionExpire,
                    ),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              // Image.asset(MyImages.sessionExpire, height: 200,width: 200,),
              vSizedBox2,
              ParagraphText(text: 'Your payment is currently being processed. Once we receive confirmation from your bank, it will be automatically reflected as confirmed in the "Confirmed" tab of your "My Consultation" section. Please note that this process may take up to 30 minutes. If the payment status does not update within that time, kindly click on the "Payment processing" button to refresh the status of your payment.', textAlign: TextAlign.center,)
              // ParagraphText(text: 'Please wait while we are processing your payment. Do not close app till the payment response is fetched', textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  });
}