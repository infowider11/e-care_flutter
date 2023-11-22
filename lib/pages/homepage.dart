import 'package:badges/badges.dart' as badges;
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/image_urls.dart';
import 'package:ecare/dialogs/loading_popup.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:ecare/pages/how_it_works.dart';
import 'package:ecare/pages/messages.dart';
import 'package:ecare/pages/setting.dart';
import 'package:ecare/widgets/CustomTexts.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/buttons.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../constants/navigation.dart';
import '../constants/sized_box.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/custom_circular_image.dart';
import 'notification.dart';
import 'video_player_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool load = false;
  Map video_data = {};
  late VideoPlayerController _controller;

  get_videos() async {
    setState(() {
      load = true;
    });
    var res = await Webservices.get('${ApiUrls.homevideo + '2'}');
    setState(() {
      load = false;
    });
    print('get video----res----$res');
    if (res['status'].toString() == '1') {
      video_data = res['data'];
      _controller = VideoPlayerController.network(video_data['video'])
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    get_videos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BgColor,
      appBar: AppBar(
        backgroundColor: Color(0xFE00A2EA).withOpacity(0.1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 5),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomCircularImage(
              imageUrl: user_Data!['profile_image'],
              fileType: CustomFileType.network,
            ),
          ),
        ),
        actions: <Widget>[
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 5, end: 2),
            showBadge: unread_noti_count != 0 ? true : false,
            badgeContent: Text(
              '${unread_noti_count}',
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagePage()));
              },
            ),
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 5, end: 2),
            showBadge: unread_noti_count != 0 ? true : false,
            badgeContent: Text(
              '${unread_noti_count}',
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
          ),
          // GestureDetector(
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Image.asset('assets/images/menu.png', width: 24),
          //   ),
          // ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/patter.png',
              ),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            MainHeadingText(
              text: 'Get ready for your first video visit',
              fontSize: 30,
              fontFamily: 'light',
            ),
            vSizedBox2,
            Expanded(
              child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Center(
                    //   child: CustomLoader(color: MyColors.primaryColor,),
                    // ),
                    if (!load)
                      GestureDetector(
                          onTap: () async {
                            push(
                                context: context,
                                screen: VideoPlayerPage(
                                  videoModal: video_data,
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              MyImages.thumb,
                              height: 200,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                            // child: Image.network(video_data['video_thumbnail'],
                            //   height: 250,
                            //   fit: BoxFit.cover,
                            //   width: MediaQuery.of(context).size.width,)
                          )),
                    Positioned(
                      bottom: 70,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]),
                        child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HowItWorks()));
                            },
                            child: RoundEdgedButton(
                              text: 'How it works',
                              horizontalPadding: 10,
                              isIcon: true,
                              iconName: Icons.chevron_right_rounded,
                              width: 140,
                              borderRadius: 100,
                              color: Colors.white,
                              textColor: MyColors.onsurfacevarient,
                            )),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
