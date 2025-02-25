// ignore_for_file: unused_local_variable, deprecated_member_use, avoid_print

import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/navigation.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/chat.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/list_ui_1.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../services/webservices.dart';
import '../widgets/custom_confirmation_dialog.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool load = false;
  List lists = [];
  Map current_user = {};

  @override
  void initState() {
    
    super.initState();
    get_chat_list();
  }

  get_chat_list() async {
    current_user = await getUserDetails();
    setState(() {
      load = true;
    });
    Map<String, dynamic> data = {
      'user_id': await getCurrentUserId(),
      'type': user_Data!['type'],
    };
    var res = await Webservices.get('${ApiUrls.chat_list+await getCurrentUserId()}&type=${user_Data!['type']}');
    print('get chat-----$res');
    if(res['status'].toString()=='1'){
      lists=res['data'];
      setState(() {

      });
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context,title: 'Message',titlecenter: true,fontfamily: 'bold'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MainHeadingText(
            //   text: 'Message',
            //   fontSize: 32,
            //   fontFamily: 'light',
            // ),
            // vSizedBox,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child: Container(
                // height: 200,
                padding: const EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width,
                // height: 200.0,
                decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.0)
                ),
                // height: 200,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info,color: Colors.red.withOpacity(0.5),),
                    const Expanded(
                      child: Text(
                          style: TextStyle(
                              fontSize: 13,
                              ),
                              'Please note that the messaging portal between'
                              ' you and your healthcare practitioner will'
                              ' only be accessible from the time your'
                              ' payment is finalized until 48 hours'
                              ' after your consultation. You may use'
                              ' this portal to ask questions and send'
                              ' documents, but healthcare practitioners'
                              ' are not obligated to respond. Please use'
                              ' this portal responsibly, and remember to'
                              ' contact your nearest healthcare'
                              ' practitioner/hospital immediately for'
                              ' urgent or emergency medical concerns.'
                              ' Thank you for your cooperation and we hope you'
                              ' have a productive consultation with'
                              ' your healthcare practitioner.',
                              textAlign: TextAlign.start,
                              softWrap: true,
                         ),
                    )
                  ],
                ),
              ),
            ),
            if(!load)
            for (var i = 0; i < lists.length; i++)
              GestureDetector(
                  onTap: () async{
                  await push(context: context, screen:
                  ChatPage(other_user_id: current_user['id'].toString()==lists[i]['sender_id'].toString()?
                    lists[i]['receiver_id'].toString():lists[i]['sender_id'].toString(),
                    booking_id: lists[i]['booking_id'].toString(),));
                     get_chat_list();
                  },
                  child: ListUI01(
                    isimage: false,
                    networkimage: true,
                    image: lists[i]['sender_data']['profile_image'],
                    bgColor: MyColors.lightBlue.withOpacity(0.11),
                    borderColor: MyColors.lightBlue.withOpacity(0.11),
                    heading: '${lists[i]['sender_data']['name']}',
                    subheading: '${lists[i]['message']}',
                    badge_count: '${lists[i]['unread']??'0'}',
                    isIcon: false,
                    isDelete: true,
                    deleteTap: () async{
                      Map<String, dynamic> data = {
                        'booking_id': lists[i]['booking_id'].toString(),
                        'type':user_Data!['type'],
                      };
                      bool? result= await showCustomConfirmationDialog(
                          headingMessage: 'Are you sure you want to delete?',
                          // description: 'Are you sure you want to delete?'
                      ) ;
                      if(result==true){
                        setState(() {
                          load = true;
                        });
                        var res = await Webservices.postData(
                            apiUrl: ApiUrls.deleteChat,
                            body: data,
                            context: context);
                        get_chat_list();
                      }
                    },
                    rightText: '${lists[i]['create_date']}',
                    isRightText: true,
                  )),
              if(lists.length==0&&!load)
              const Center(
                child: Text('No chat yet.'),
              ),
              if(load)
              const Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: CustomLoader(),
              ),
          ],
        ),
      ),
    );
  }
}
