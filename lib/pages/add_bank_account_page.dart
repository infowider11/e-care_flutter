import 'dart:convert';
import 'dart:developer';

import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/pay_stack/flutter_paystack_services.dart';
import 'package:ecare/services/webservices.dart';
import 'package:ecare/widgets/Customdropdownbutton.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/showSnackbar.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../services/auth.dart';
import '../services/pay_stack/flutter_paystack_services.dart';
import '../services/pay_stack/modals/sub_bank_account_modal.dart';
import '../widgets/appbar.dart';
import '../widgets/loader.dart';
import 'package:ecare/widgets/customtextfield.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({Key? key}) : super(key: key);

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  bool load = false;
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController accountholdername = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController banknameController = TextEditingController();
  List Banks = [];
  Map current_user = {};

  Map? selected_bank;

  get_southAfrika_banks() async {
    var res = await Webservices.getsouthAfrikabanks();
    var json_res = jsonDecode(res.body);
    print('bankss------ ${json_res}');
    if (json_res['status'] == true) {
      Banks = json_res['data'];
      if (current_user['is_bank_account_added'].toString() == '1') {
        for(int i=0;i<Banks.length;i++){
          if(Banks[i]['id'].toString()==current_user['bank_details']['bankid'].toString()){
            selected_bank=Banks[i];
            setState(() {

            });
          }

        }
      }
      setState(() {});
    }
  }

  get_bank_detail() async{
    var id = await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}&M=${DateTime.now().microsecond}');
    // print('user data---$res');
    log('user data---$res');
    if (res['status'].toString() == '1') {
      current_user = res['data'];
      user_Data = res['data'];
      setState(() {});
      if (res['data']['is_bank_account_added'].toString() == '1') {
        accountNumberController.text =
            res['data']['bank_details']['account_number'] ?? '';
        businessNameController.text =
            res['data']['bank_details']['business_name'] ?? '';
        accountholdername.text =
            res['data']['bank_details']['account_holder_name'] ?? '';
        bankCodeController.text =
            res['data']['bank_details']['subaccount_code'] ?? '';
        banknameController.text =
            res['data']['bank_details']['bank_name'] ?? '';
        // selected_bank = res['data']['settlement_bank'];
        //
        setState(() {});
      }
      get_southAfrika_banks();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // get_southAfrika_banks();
    get_bank_detail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffold,
      appBar: appBar(
          context: context,
          title: 'My Banking Details',
          fontsize: 20,
          fontfamily: 'light'),
      body: load
          ? CustomLoader()
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox2,
                  CustomTextField(
                      controller: businessNameController,
                      hintText: 'Business Name'),
                  vSizedBox,
                  CustomTextField(
                      controller: accountholdername,
                      hintText: 'Account Holder Name'),
                  vSizedBox,
                  CustomTextField(
                      controller: accountNumberController,
                      hintText: 'Account Number'),
                  vSizedBox,
                  Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.bordercolor),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomDropdownButton(
                      margin: 0.0,
                      selectedItem: selected_bank??null,
                      isLabel: false,
                      onChanged: ((dynamic value) {
                        print('select bank ---- ${value}');
                        selected_bank = value;
                        if(current_user['is_bank_account_added'].toString()=='0'){
                          bankCodeController.text = value['code'].toString();
                        }
                        setState(() {});
                      }),
                      items: Banks,
                      hint: 'Bank Name',
                      itemMapKey: 'name',
                      text: '',
                    ),
                  ),
                  vSizedBox,
                  // CustomTextField(
                  //     controller: banknameController, hintText: 'Bank Name'),
                  // vSizedBox,
                  CustomTextField(
                      controller: bankCodeController,
                      hintText: 'Bank Code',
                      enabled: false,
                  ),
                  vSizedBox4,
                  RoundEdgedButton(
                    text: current_user['is_bank_account_added'].toString()=='1'?'Update Account':'Add Account',
                    color: MyColors.primaryColor,
                    onTap: current_user['is_bank_account_added'].toString()=='0'?()async {
                      if (businessNameController.text.isEmpty) {
                        showSnackbar('Please add your business name');
                      } else if (accountholdername.text.isEmpty) {
                        showSnackbar('Please account holder name');
                      } else if (accountNumberController.text.isEmpty) {
                        showSnackbar('Please add your account number');
                      } else if (selected_bank == null) {
                        showSnackbar('Please select bank');
                      } else if (bankCodeController.text.isEmpty) {
                        showSnackbar('Please add your bank code');
                      } else {
                        setState(() {
                          load = true;
                        });
                        SubBankAccountModal? subBankAccount =
                            await FlutterPayStackServices
                                .addDoctorAccountToPayStack(
                                    businessName: businessNameController.text,
                                    settlementBankCode: bankCodeController.text,
                                    accountNumber: accountNumberController.text,
                                    percentageCharge: '${percentageCharge}',);
                        if (subBankAccount != null) {
                          // showSnackbar(
                          //     'The bank account is added successfully ${subBankAccount.subaccount_code}');
                          var request = {
                            'account_number': subBankAccount.account_number,
                            'account_holder_name': accountholdername.text,
                            'subaccount_code': subBankAccount.subaccount_code,
                            'settlement_bank': subBankAccount.settlement_bank,
                            'business_name':businessNameController.text,
                            'percentage_charge':
                                subBankAccount.percentage_charge.toString(),
                            'bankname': selected_bank!['name'],
                            'bankid': selected_bank!['id'].toString(),
                            'currency': selected_bank!['currency'],
                            'user_id': user_Data!['id'],
                          };
                          var jsonResponse = await Webservices.postData(
                              apiUrl: ApiUrls.addBankAccount,
                              body: request,
                              context: context);
                          if(jsonResponse['status'].toString()=='1'){
                              showSnackbar('Banking details saved";and is able to proceed to create schedule/time slots.');
                              get_bank_detail();
                          }
                        }
                        setState(() {
                          load = false;
                        });
                      }
                    }:()async {
                      if (businessNameController.text.isEmpty) {
                        showSnackbar('Please add your business name');
                      } else if (accountholdername.text.isEmpty) {
                        showSnackbar('Please account holder name');
                      } else if (accountNumberController.text.isEmpty) {
                        showSnackbar('Please add your account number');
                      } else if (selected_bank == null) {
                        showSnackbar('Please select bank');
                      } else if (bankCodeController.text.isEmpty) {
                        showSnackbar('Please add your bank code');
                      } else {
                        setState(() {
                          load = true;
                        });
                        var res =
                        await FlutterPayStackServices
                            .updateDoctorAccountToPaystack(
                            email: user_Data!['email'],
                            bankname: selected_bank!['name'],//current_user['bank_details']['settlement_bank'],
                            businessName: businessNameController.text,
                            settlementBankCode: bankCodeController.text,
                            accountNumber: accountNumberController.text,
                            percentageCharge: '${percentageCharge}',
                            code: bankCodeController.text);
                        print('update bank detail on paystack $res');
                        // return;
                        if (res != null) {
                          // showSnackbar(
                          //     'The bank account is added successfully ${subBankAccount.subaccount_code}');
                          Map<String,dynamic> data = {
                            'account_number': accountNumberController.text,
                            'account_holder_name': accountholdername.text,
                            'subaccount_code': bankCodeController.text,
                            'settlement_bank': selected_bank!['name'],
                            'business_name':businessNameController.text,
                            'percentage_charge':
                            percentageCharge.toString(),
                            'bankname':selected_bank!['name'],
                            'bank_id':current_user['bank_details']['id'].toString(),//selected_bank!['id'].toString(),
                            'currency':selected_bank!['currency'],
                            'bankid': selected_bank!['id'].toString(),
                            // 'user_id': user_Data!['id'],
                          };
                          var jsonResponse = await Webservices.postData(
                              apiUrl: ApiUrls.editBankAccount,
                              body: data,
                              context: context);
                          if(jsonResponse['status'].toString()=='1'){
                            showSnackbar('Banking details updated successfully.');
                            Navigator.pop(context);
                            // get_bank_detail();
                          }
                        }
                        setState(() {
                          load = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
