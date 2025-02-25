// import 'package:contacts_service/contacts_service.dart';
// ignore_for_file: deprecated_member_use, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:sms_advanced/sms_advanced.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../doctor_module/notification.dart';
import '../services/auth.dart';

class DoctorInvitePage extends StatefulWidget {
  const DoctorInvitePage({Key? key}) : super(key: key);

  @override
  State<DoctorInvitePage> createState() => _DoctorInvitePageState();
}

class _DoctorInvitePageState extends State<DoctorInvitePage> {
  Map userData={};
  bool load=false;
  List<ContactInfo> contacts = [];

  @override
  void initState() {
    
    super.initState();
    getDetail();
    // get_contact_list();
    _askPermissions();
  }

  get_contact_list() async{
    setState(() {
      load=true;
    });
      contacts = await FlutterContactsService.getContacts(withThumbnails: true);
    print('contact list----${contacts}');
    setState(() {
      load=false;
    });
  }


  getDetail() async {
    userData=await getUserDetails();
    // print(userData);
    setState(() {

    });
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      get_contact_list();
      // if (routeName != null) {
      //   // Navigator.of(context).pushNamed(routeName);
      // }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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

                    child: Image.network('${userData['profile_image']}', width: 35)),
                hSizedBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeadingText(text: '${userData['first_name']} ${userData['last_name']}', fontFamily: 'light', fontSize: 15,),
                    const MainHeadingText(text: 'Welcome Back!', fontFamily: 'light', color: MyColors.primaryColor, fontSize: 12,),
                  ],
                )
              ],
            )
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorNotificationPage())),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.notifications, size: 24,),
            ),
          ),
        ],
      ),
      body: load?const CustomLoader():SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const MainHeadingText(text: 'Invite your friends & family!', fontSize: 32, fontFamily: 'light',),
            vSizedBox4,
            if(contacts.length>0)
            Column(
              children: [
                // CustomTextField(labelText: '', hintText: 'Invite your friends & family to download the app', upperSpace: 0, isIcon: true, icon: Icons.search_outlined,),
                for(var i = 0; i < contacts.length; i++)
                  if(contacts[i].displayName != null)
                Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                (contacts[i].avatar!=null && contacts[i].avatar!.length>0)?
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: MemoryImage(contacts[i].avatar!),
                                  backgroundColor: Colors.grey,
                                )
                                    :
                                CircleAvatar(child:
                                contacts[i].initials()!=''?Text(contacts[i].initials()):const Icon(Icons.person),radius: 30.0,),
                                hSizedBox2,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MainHeadingText(text: '${contacts[i].displayName}',
                                          fontSize: 16, fontFamily: 'medium', color: MyColors.headingcolor,),
                                      vSizedBox05,
                                      MainHeadingText(text: '${getPhone(contacts[i].phones)}', fontSize: 12, fontFamily: 'medium', color: const Color(0xFE7a7a7a)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                              // var msg = 'Hello, \nOne of your friend username has been invited you to e care app,'
                              //     'Install it by clicking below link. https://bluediamondresearch.com/WEB01/e_care/admin \n'
                              //     'Thanks'+'\n${contacts[i].displayName}';
                              ///TODO: uncomment in the end manish 0510
                              // _sendSMS(msg,[getPhone(contacts[i].phones)]);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MyColors.headingcolor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: MainHeadingText(text: 'Invite', fontSize: 14, color: MyColors.headingcolor, fontFamily: 'medium',),
                              ),
                            ),
                          )
                        ],
                      ),
                      vSizedBox2,
                    ],
                  ),
                vSizedBox4
              ],
            )
          ],
        ),
      ),
    );
  }
  String getPhone(phones){
    String m = "";
    for (var i in phones){
      // log('checking----'+i.value.toString());
      m=i.value??"";
      return i.value??"";
    }
    return m;

  }

  // void _sendSMS(String message, List<String> recipents) async {
  //   SmsSender sender = new SmsSender();
  //   // String address = someAddress();
  //   for(var client in recipents){
  //     sender.sendSms(new SmsMessage(client, 'Hello flutter world!'));
  //   }
  //   // String _result = await sendSMS(message: message, recipients: recipents)
  //   //     .catchError((onError) {
  //   //   print(onError);
  //   // });
  //   // print(_result);
  // }
}
