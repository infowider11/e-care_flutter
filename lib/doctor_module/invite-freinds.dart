import 'package:contacts_service/contacts_service.dart';
import 'package:ecare/pages/setting.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../doctor_module/notification.dart';
import '../services/auth.dart';
import '../widgets/customtextfield.dart';

class DoctorInvitePage extends StatefulWidget {
  const DoctorInvitePage({Key? key}) : super(key: key);

  @override
  State<DoctorInvitePage> createState() => _DoctorInvitePageState();
}

class _DoctorInvitePageState extends State<DoctorInvitePage> {
  Map userData={};
  bool load=false;
  late List<Contact> contacts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
    // get_contact_list();
    _askPermissions();
  }

  get_contact_list() async{
    setState(() {
      load=true;
    });
      contacts = await ContactsService.getContacts(withThumbnails: true);
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
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
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
                    MainHeadingText(text: 'Welcome Back!', fontFamily: 'light', color: MyColors.primaryColor, fontSize: 12,),
                  ],
                )
              ],
            )
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorNotificationPage())),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.notifications, size: 24,),
            ),
          ),
        ],
      ),
      body: load?CustomLoader():SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            MainHeadingText(text: 'Invite your friends & family!', fontSize: 32, fontFamily: 'light',),
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
                                contacts[i].initials()!=''?Text(contacts[i].initials()):Icon(Icons.person),radius: 30.0,),
                                hSizedBox2,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MainHeadingText(text: '${contacts[i].displayName}',
                                          fontSize: 16, fontFamily: 'medium', color: MyColors.headingcolor,),
                                      vSizedBox05,
                                      MainHeadingText(text: '${getPhone(contacts[i].phones)}', fontSize: 12, fontFamily: 'medium', color: Color(0xFE7a7a7a)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                              var msg = 'Hello, \nOne of your friend username has been invited you to e care app,'
                                  'Install it by clicking below link. https://bluediamondresearch.com/WEB01/e_care/admin \n'
                                  'Thanks'+'\n${contacts[i].displayName}';
                              _sendSMS(msg,[getPhone(contacts[i].phones)]);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MyColors.headingcolor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
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

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
