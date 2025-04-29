
// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:ecare/services/log_services.dart';
import 'package:ecare/services/pay_stack/modals/FlutterPayStackInitializeTransactionResponseModal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:convert';

import '../../constants/global_keys.dart';
import '../../dialogs/loading_popup.dart';
import '../../widgets/showSnackbar.dart';
import 'modals/sub_bank_account_modal.dart';


late double percentageCharge;

enum PaymentStatus{
  success,ongoing,failed
}
class FlutterPayStackServices {
  static const String _baseUrl = 'https://api.paystack.co/';
  static const String _initializeTransactionUrl =
      '${_baseUrl}transaction/initialize';
  static const String _verifyTransactionUrl =
      '${_baseUrl}transaction/verify/';
  // https://api.paystack.co/transaction/verify/jep33wrwua
  static const String _addSubbankAccount =
      '${_baseUrl}subaccount';

  static Map<String, String> _payStackGlobalHeaders = {
    "Authorization":
    // "Bearer sk_test_a2f7cf6732341a7b64afc7c0268f2f7140086067", // test key
    "Bearer sk_live_88f2c54311fa957565043196ecbd3d17679d4a95", // Live key
    "Content-Type": "application/json",
  };
  // static const double percentageCharge = 15;
  // late final double percentageCharge;
  static Future<FlutterPayStackInitializeTransactionResponseModal?>
      initializeTransaction(
          {required String email, required String amount, String? subAccountCode}) async {
    // accessCode = jsonResponse['data']['access_code'];
    // var request = {
    //   "email": email,
    //   "amount": amount,
    //   // "subaccount_code": "ACCT_ro3qdbz65im9gr8",
    // };

    var request = {
      "email":email,
      "amount": amount,
      "bearer": "subaccount",
      "split": {
        "type": "flat",
        "bearer_type": "account",
        "subaccounts":subAccountCode==null?[]: [
          {
            // "subaccount": "ACCT_rlkg3u4edusfwm0", // Test sub account
            "subaccount": subAccountCode,
            "share": '${double.parse(amount)*(100-percentageCharge.toInt())/100}',
          }
        ]
      }
    };
    // if(subAccountCode!=null){
    //   request['subaccount_code'] = subAccountCode;
    // }

    print('the request is ${request}');
    // the request is {email: manish.1webwiders@gmail.com, amount: 60000, subaccount_code: ACCT_q0ood4tcouab1hp}
    // the request is {email: manish.1webwiders@gmail.com, amount: 60000, subaccount_code: ACCT_ro3qdbz65im9gr8}
    // The response is 200 : {"status":true,"message":"Authorization URL created",
    // "data":{"authorization_url":"https://checkout.paystack.com/bfy2akhwv66da0u",
    // "access_code":"bfy2akhwv66da0u",
    // "reference":"l7sn1d0k0v"}}
    http.Response response = await http.post(
      Uri.parse('${_initializeTransactionUrl}'),
      headers: _payStackGlobalHeaders,
      body: jsonEncode(request),
    );
    print('The response is1 ${response.statusCode} : ${response.body}');
    if(response.statusCode==400){
      var jsonResponse = jsonDecode(response.body);
      showSnackbar(jsonResponse['message']);
    }
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        return FlutterPayStackInitializeTransactionResponseModal.fromJson(
            jsonResponse['data'],
            true,
            jsonResponse['message'] ?? 'success message');
      } else {
        showSnackbar('Failed ${jsonResponse['message']}');
      }
    }
    return null;
  }

  static Future<PaymentStatus> isPaymentSuccessfull(String referenceId,{int count = 0, bool showLoading = true})async{
    try{
      // await EasyLoading.show(
      //   status: null,
      //   maskType: EasyLoadingMaskType.black,
      // );
      if(showLoading) {
        showLoadingPopup();
      }
    }catch(e){
      print('Could not show easy loading');
    }
    if(count<50){

      await Future.delayed(const Duration(milliseconds: 1400));
      print('checking response for reference id $referenceId');
      http.Response response = await http.get(
        Uri.parse('${_verifyTransactionUrl}$referenceId'),
        headers: _payStackGlobalHeaders,
      );


      print('the response is reference id : $referenceId ${response.statusCode} ${response.body}');
      try{
        CustomLogServices.sendMessageToSentry(message: 'the response is reference id : $referenceId ${response.statusCode} ${response.body}', sentryLevel: SentryLevel.info);
      }catch(e){
        print('Could not send message to sentry');
      }

      if(response.statusCode==200){
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['data']['status']=='success'){
          try{
            // EasyLoading.dismiss();
            if(showLoading) {
              Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
            }
          }catch(e){
            print('Could not show easy loading');
          }
          return PaymentStatus.success;
        }
        if(jsonResponse['data']['status']=='ongoing'){
          try{
            // EasyLoading.dismiss();
            if(showLoading) {
              Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
            }
          }catch(e){
            print('Could not show easy loading');
          }
          return PaymentStatus.ongoing;
          // count++;
          // await Future.delayed(Duration(milliseconds: 2400));
          // return isPaymentSuccessfull(referenceId,count: count);
        }

      }
    }
    try{
      // EasyLoading.dismiss();
      if(showLoading) {
        Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
      }
    }catch(e){
      print('Could not show easy loading');
    }
    return PaymentStatus.failed;
  }

  // static Future<bool> isPaymentSuccessfull(String referenceId,{int count = 0})async{
  //   try{
  //     // await EasyLoading.show(
  //     //   status: null,
  //     //   maskType: EasyLoadingMaskType.black,
  //     // );
  //     showLoadingPopup();
  //   }catch(e){
  //     print('Could not show easy loading');
  //   }
  //   if(count<50){
  //
  //     await Future.delayed(Duration(milliseconds: 1400));
  //     print('checking response for reference id $referenceId');
  //     http.Response response = await http.get(
  //       Uri.parse('${_verifyTransactionUrl}$referenceId'),
  //       headers: _payStackGlobalHeaders,
  //     );
  //
  //
  //     print('the response is reference id : $referenceId ${response.statusCode} ${response.body}');
  //     try{
  //       CustomLogServices.sendMessageToSentry(message: 'the response is reference id : $referenceId ${response.statusCode} ${response.body}', sentryLevel: SentryLevel.info);
  //     }catch(e){
  //       print('Could not send message to sentry');
  //     }
  //
  //     if(response.statusCode==200){
  //       var jsonResponse = jsonDecode(response.body);
  //       if(jsonResponse['data']['status']=='success'){
  //         try{
  //           // EasyLoading.dismiss();
  //           Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
  //         }catch(e){
  //           print('Could not show easy loading');
  //         }
  //         return true;
  //       }
  //       if(jsonResponse['data']['status']=='ongoing'){
  //         count++;
  //         await Future.delayed(Duration(milliseconds: 2400));
  //         return isPaymentSuccessfull(referenceId,count: count);
  //       }
  //
  //     }
  //     // count++;
  //     // await Future.delayed(Duration(milliseconds: 2400));
  //     // return isPaymentSuccessfull(referenceId,count: count);
  //   }
  //   try{
  //     // EasyLoading.dismiss();
  //     Navigator.pop(MyGlobalKeys.navigatorKey.currentContext!);
  //   }catch(e){
  //     print('Could not show easy loading');
  //   }
  //   return false;
  // }


  static Future<SubBankAccountModal?> addDoctorAccountToPayStack({
  required String businessName,
  required String settlementBankCode,
  required String accountNumber,
  required String percentageCharge,
})async{
    var request = {
      'business_name': businessName,
      'settlement_bank': settlementBankCode,
      'account_number': accountNumber,
      'percentage_charge': percentageCharge,
    };
print('the request for ${_addSubbankAccount} is $request');
    http.Response response = await http.post(
      Uri.parse('${_addSubbankAccount}'),
      headers: _payStackGlobalHeaders,
      body: jsonEncode(request),
    );
    print('the response code is ${response.statusCode}');
    if(response.statusCode==201){
      print('the response is2 ${response.body}');
      var jsonResponse = await jsonDecode(response.body);
      if(jsonResponse['status']){

        try{
          return SubBankAccountModal.fromJson(jsonResponse['data']);
        }catch(e){
          print('Error in catch block 528 $e');
        }
      }
    }else{
      try{
        var jsonResponse = await jsonDecode(response.body);
        if(jsonResponse['message']=='Settlement Bank is invalid'){
          showSnackbar('You have entered incorrect bank code.');
        }else{
          showSnackbar(jsonResponse['message']??'Bank account add failed(E: 838)');
        }

      }catch(e){
        print('Error in catch block 5d28 $e');
      }
    }
    return null;

  }

  static Future<bool?> updateDoctorAccountToPaystack({
    required String businessName,
    required String settlementBankCode,
    required String accountNumber,
    required String percentageCharge,
    required String code,
    required String email,
    required String bankname,
    })async{
    var request = {
      'business_name': businessName,
      'subaccount_code': settlementBankCode,
      'settlement_bank': bankname,
      'account_number': accountNumber,
      'percentage_charge': percentageCharge,
      'primary_contact_email':email,
    };
    print('request url----${_addSubbankAccount}/${code}');
    print('request data----${request}');
    http.Response response = await http.put(
      Uri.parse('${_addSubbankAccount}/${code}'),
      headers: _payStackGlobalHeaders,
      body: jsonEncode(request),
    );
    print('paystack reponse       ${response.body}');
    print('the response code is ${response.statusCode}');
    if(response.statusCode==201){
      print('the response is3 ${response.body}');
      var jsonResponse = await jsonDecode(response.body);
      if(jsonResponse['status']){
        try{
          // return SubBankAccountModal.fromJson(jsonResponse['data']);
          return true;
        }catch(e){
          print('Error in catch block 528 $e');
        }
      }
    }else{
      try{
        var jsonResponse = await jsonDecode(response.body);
        print('else########### $jsonResponse');
        return true;
        // if(jsonResponse['message']=='Settlement Bank is invalid'){
        //   showSnackbar('You have entered incorrect bank code.');

        // }else{
        //   //showSnackbar(jsonResponse['message']??'Bank account add failed(E: 838)');
        // }
      }catch(e){
        print('Error in catch block 5d28 $e');
      }
    }
    return null;
  }
}
