import 'package:badges/badges.dart' as badges;
import 'package:ecare/constants/colors.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/functions/navigation_functions.dart';
import 'package:ecare/pages/how_it_works.dart';
import 'package:ecare/pages/setting.dart';
import 'package:ecare/services/api_urls.dart';
import 'package:ecare/services/auth.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import '../constants/image_urls.dart';
import '../constants/sized_box.dart';
import '../pages/messages.dart';
import '../pages/video_player_page.dart';
import '../services/webservices.dart';
import 'notification.dart';

class DoctorHowItWorks extends StatefulWidget {
  const DoctorHowItWorks({Key? key}) : super(key: key);

  @override
  State<DoctorHowItWorks> createState() => _DoctorHowItWorksState();
}

class _DoctorHowItWorksState extends State<DoctorHowItWorks> {
  late VideoPlayerController _controller;
  Map userData={};
  Map video_data={};
  bool load=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
    get_videos();
  }

  get_videos() async{
    setState(() {
      load=true;
    });
    var res = await Webservices.get('${ApiUrls.homevideo+'1'}');
    setState(() {
      load=false;
    });
    print('get video----res----$res');
    if(res['status'].toString()=='1'){
      video_data=res['data'];
      // _controller = VideoPlayerController.network(
      //     video_data['video'])
      //   ..initialize().then((_) {
      //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //     setState(() {});
      //   });
      setState(() {

      });
    }
  }

  getDetail() async {
    // userData = await getUserDetails();
    var id= await getCurrentUserId();
    var res = await Webservices.get('${ApiUrls.get_user_by_id}?user_id=${id}');
    print('res $res');
    if(res['status'].toString()=='1'){
      user_Data=res['data'];
      setState(() {

      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFE00A2EA).withOpacity(0.1),
        title:userData!=null? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(user_Data!=null)
                Container(
                  clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            ),

                    child: CustomCircularImage(imageUrl: user_Data!['profile_image'],),
                    // Image.network('${userData['profile_image']}', width: 35)
              ),
                hSizedBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainHeadingText(text: '${user_Data!['first_name']} ${user_Data!['last_name']}', fontFamily: 'light', fontSize: 15,),
                      MainHeadingText(text: 'Welcome Back!', fontFamily: 'light', color: MyColors.primaryColor, fontSize: 12,),
                    ],
                  ),
                )
              ],
            )
        ):Container(),
        actions: <Widget>[

          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 2),
            showBadge: unread_noti_count!=0?true:false,
            badgeContent: Text('${unread_noti_count}',style: TextStyle(color: Colors.white),),
            child: IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage()));
              },
            ),
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top:0,end:2),
            showBadge: unread_noti_count!=0?true:false,
            badgeContent: Text('${unread_noti_count}',style: TextStyle(color: Colors.white),),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorNotificationPage()));
              },
            ),
          ),
        ],
      ),
      body: load?CustomLoader():Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/patter.png', ),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            MainHeadingText(text: 'How it works - Health Provider guide', fontSize: 30, fontFamily: 'semibold',),
            vSizedBox2,
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () async{
                  push(context: context, screen: VideoPlayerPage(videoModal: video_data,));
                  },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(MyImages.thumb,
                          height: 200,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,))),
                Positioned(
                  bottom: -20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HowItWorks())),
                      child: RoundEdgedButton(text: 'How it works', horizontalPadding: 10, isIcon: true, iconName: Icons.chevron_right_rounded, width: 140, borderRadius: 100, color: Colors.white, textColor: MyColors.onsurfacevarient, )
                    )
                  )
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}