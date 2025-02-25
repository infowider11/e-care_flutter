// ignore_for_file: unused_local_variable, avoid_print

import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ecare/constants/colors.dart';
import 'package:ecare/constants/global_keys.dart';
import 'package:ecare/constants/sized_box.dart';
import 'package:ecare/functions/print_function.dart';
import 'package:ecare/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../widgets/CustomTexts.dart';
import '../functions/global_Var.dart';
import '../services/api_urls.dart';
import '../services/custom_navigation_services.dart';
import '../services/webservices.dart';
import '../widgets/loader.dart';
import '../widgets/showSnackbar.dart';

// const token =
//     '006ddbba166ad844f609413dedd53a01253IABcwDPCbMCU2TcOTpZinGUDvJ73Z/9BmfC63ymHhh5b11Aq764AAAAAEACXhJCZnnmtYgEAAQCfea1i';

class VideoCallScreen extends StatefulWidget {
  final String userId;
  final String name;
  final String bookingId;
  final String? token;
  // static const String id = 'video_call_screen';
  const VideoCallScreen(
      {Key? key,
      required this.userId,
      required this.bookingId,
      this.token = null,
      required this.name})
      : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  // static const String appId = 'b958b622ad394c88bc00e2c45e37e0c0';//'19b5c3689459408683d08b11e477c40c';
  static const String appId =
      '272699c3499e429d9a7477b7491b0e40'; //new app id of ecare client
  int? _remoteUid;
  bool? isRemoteUserSpeakerEnabled;
  bool? isSpeakerEnabled;
  bool isBackCameraEnabled = true;
  bool isAudioEnabled = true;
  bool isRemoteUserAudioEnabled = true;
  bool isVideoEnabled = true;
  bool isRemoteUserVideoEnabled = true;
  int call_duration = 0;

  int attempts = 0;

  RtcEngine? _engine;
  bool load = false;
  String? token = null;
  String channelName = '';
  String calling_id = '';

  Future<void> initForAgora() async {
    setState(() {
      load = true;
    });
    var request = {
      "call_by": user_Data!['id'],
      "call_to": widget.userId,
      "booking_id": widget.bookingId,
      // "user_type": user_Data!['user_type']??''
    };
    if (user_Data!['type'].toString() == '1') {
      var jsonResponse = await Webservices.postData(
          apiUrl: ApiUrls.StartCall, body: request, context: context);

      myCustomPrintStatement('call start----$jsonResponse');

      if (jsonResponse['status'] == 1) {
        setState(() {});
      } else {}
    } else {
      setState(() {});
    }
    channelName = '_prasoon_' + widget.bookingId;
    myCustomPrintStatement('token---$token');
    myCustomPrintStatement('channelName----$channelName');
    // token =
    // '007eJxTYIg7+PvBwdAp4mY3tk7XsDRVuMptyXDA6bMp99qQKBH79jUKDEnGyanmiUZmFsmWySappkmJxqnmhqbGRoZJphYGxkZJKsE8yfOW8CYvUT/FwsgAgSA+M4OhkTEDAwDCYx1x';
    // // token = widget.bookingId;
    // channelName = '123';
    await [Permission.microphone, Permission.camera].request();
    setState(() {
      load = false;
    });

    // creates the engine
    // _engine = await RtcEngine.create(appId);
    _engine = createAgoraRtcEngine();
    await _engine?.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    myCustomPrintStatement('the engine is created with app id ${appId}');
    // await _engine!.setEnableSpeakerphone(
    //     true);
    // await _engine!.enableVideo();

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onCameraReady: () {
        myCustomPrintStatement('fsdddd');
      },
      onLocalAudioStateChanged: (connection, ss, error) {
        _engine!.isSpeakerphoneEnabled().then((value) {
          isSpeakerEnabled = value;
          try {
            setState(() {});
          } catch (e) {
            myCustomPrintStatement('Error in catch block 2343 $e');
          }
        });
      },
      onRemoteVideoStateChanged:
          (connection, remoteUid, state, reason, elapsed) {
        debugPrint("remote user camera $remoteUid left channel $state");
        if (state == RemoteVideoState.remoteVideoStateStopped) {
          isRemoteUserVideoEnabled = false;
        } else {
          isRemoteUserVideoEnabled = true;
        }
      },
      onLocalVideoStats: (connection, df) {
        myCustomPrintStatement('local video stats');
        myCustomPrintStatement(df.captureBrightnessLevel);
      },
      onJoinChannelSuccess: (
        connection,
        int uid,
      ) {
        myCustomPrintStatement('Local user $uid joined');
        setState(() {});
      },
      onRejoinChannelSuccess: (connection, int1) {
        myCustomPrintStatement('rejoined fffff');
      },
      onUserEnableVideo: (rtcconnection, a, isenbla) {
        myCustomPrintStatement('The user ghass enabled $a $isenbla');
        isRemoteUserVideoEnabled = isenbla;
        setState(() {});
      },
      onUserJoined: (connection, int uid, int elapsed) {
        myCustomPrintStatement('Remote user $uid joined');
        setState(() {
          _remoteUid = uid;
        });
      },
      onUserOffline: (connection, int uid, UserOfflineReasonType reason) async {
        myCustomPrintStatement('Remote user $uid left');
        _remoteUid = null;
        // await Webservices.postData(apiUrl: ApiUrls.endCall, body: request, context: context);
        await _engine!.leaveChannel();
        Navigator.pop(context);
        setState(() {
          _remoteUid = null;
        });
      },
      onUserMuteAudio: (connection, remoteUid, muted) {
        isRemoteUserAudioEnabled = !muted;
        setState(() {});
        myCustomPrintStatement(
            'The user ghass audio enabled $remoteUid $muted');
      },
      onRtcStats: (connection, stats) async {
        //updates every two seconds
        // if (_showStats) {
        //   _stats = stats;
        // int d = await stats.duration;
        call_duration = stats.duration ?? 0;

        setState(() {});
        if (stats.duration == 300) {
          // 5 min. condition
          // var res = await Webservices.get(ApiUrls.mark_as_complete+widget.bookingId.toString());
          // myCustomPrintStatement('mark as complete---- ${res}');
        }

        myCustomPrintStatement(
            'updates every two seconds************call_duration******${call_duration}');
        setState(() {});
        // }
      },
    ));

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    myCustomPrintStatement(
        'about to join channel with name $channelName and token $token');

    await _engine!.enableVideo();
    await _engine!.enableAudio();
    await _engine!.setCameraAutoFocusFaceModeEnabled(true);
    await _engine!.setDefaultAudioRouteToSpeakerphone(true);
    await _engine!.startPreview();
    var randomId = Random().hashCode;
    randomId = 1;
    myCustomPrintStatement('joining with ${randomId}');
    attempts = 0;
    await joiningChannel();
    // await joinChannel();
    setState(() {
      load = false;
    });
  }

  Widget _renderRemoteView() {
    if (_remoteUid != null) {
      return Stack(
        children: [
          isRemoteUserVideoEnabled
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _engine!,
                    canvas: VideoCanvas(uid: _remoteUid),
                    connection: RtcConnection(channelId: channelName),
                  ),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(65), // Image radius
                          child: Image.network(user_Data!['profile_image'],
                              fit: BoxFit.cover),
                        ),
                      ),
                      vSizedBox05,
                      ParagraphText(
                          text: "${widget.name}, turn off their camera")
                    ],
                  ),
                ),
          // return RtcRemoteView.SurfaceView(
          //   uid: _remoteUid!,
          //   channelId: channelName,
          //   mirrorMode: VideoMirrorMode.Auto,
          // );
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isRemoteUserAudioEnabled
                        ? MyColors.primaryColor
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRemoteUserAudioEnabled ? Icons.mic : Icons.mic_off,
                    color: isRemoteUserAudioEnabled
                        ? MyColors.white
                        : MyColors.black,
                  ),
                ),
                vSizedBox,
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isRemoteUserVideoEnabled
                        ? MyColors.primaryColor
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRemoteUserVideoEnabled
                        ? Icons.videocam
                        : Icons.videocam_off,
                    color: isRemoteUserVideoEnabled
                        ? MyColors.white
                        : MyColors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Center(
        child: ParagraphText(
          text: user_Data!['type'].toString() == '2'
              ? 'Please wait provider will join soon.'
              : 'Please wait patient will join soon.',
          color: Colors.white,
        ),
      );
    }
  }

  Widget _renderLocalPreview() {
    return Container(
      height: 160,
      width: 160,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: int.parse(("0").toString())),
        ),
      ),
      // child: RtcLocalView.SurfaceView(),
    );
  }

  joiningChannel() async {
    // var cidepOr = VideoCallProvider();
    // var video = Provider.of<VideoCallProvider>(context, listen: false);
    try {
      print('trying to join channel ${channelName} attempt: ${attempts}');
      await _engine!.joinChannel(
        token: "",
        channelId: channelName,
        // uid: userData==null?randomId:userData!.userId,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
      attempts = 0;
    } catch (e) {
      print('trying to join channel attempt failed: ${attempts}..$e');
      if (attempts < 3) {
        await Future.delayed(const Duration(seconds: 2));
        attempts++;
        joiningChannel();
      } else {
        myCustomLogStatements('Popping .....1');
        CustomNavigation.popUntil(MyGlobalKeys.navigatorKey.currentContext!,
            (route) => route.isFirst);
        await Future.delayed(const Duration(seconds: 2));
        showSnackbar('The live stream may have been ended');
      }
    }
  }

  // joinChannel() async {
  //   try {
  //     await _engine!.joinChannel(token:token??'',channelId:  channelName,uid: 0, options: ChannelMediaOptions());
  //     // await _engine!.joinChannel(
  //     //   token,
  //     //   channelName,
  //     //   null,
  //     //   0,
  //     // );
  //     myCustomPrintStatement('the join  channel is called');
  //     await _engine!.setCameraAutoFocusFaceModeEnabled(true);
  //     // await _engine!.enableRemo(_remoteUid!, true);
  //     ///TODO: uncomment in the end manish 0510
  //     // await _engine!.enableRemoteSuperResolution(_remoteUid!, true);
  //   } catch (e) {
  //     myCustomPrintStatement('inside catch block234 $e');
  //     await _engine!.leaveChannel();
  //     await _engine!.joinChannel(token:token??'',channelId:  channelName,uid: 0, options: ChannelMediaOptions());
  //     await _engine!.setCameraAutoFocusFaceModeEnabled(true);
  //     // await _engine!.enableRemoteSuperResolution(_remoteUid!, true);
  //   }
  // }

  @override
  void initState() {
    
    initForAgora();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        await EasyLoading.show(
          status: null,
          maskType: EasyLoadingMaskType.black,
        );
        if (_engine != null) {
          await _engine!.leaveChannel();
          Map<String, dynamic> data = {
            'booking_id': widget.bookingId.toString(),
            'user_id': await getCurrentUserId(),
            'duration': call_duration.toString(),
          };
          var res = await Webservices.postData(
              apiUrl: ApiUrls.endCall, body: data, context: context);
        }
        setState(() {
          _remoteUid = null;
        });
        EasyLoading.dismiss();
        Navigator.pop(context, true);
        Navigator.pop(context);
      },
    );
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Leave Call?",
        style: TextStyle(color: Colors.red),
      ),
      content:
          const Text("Are you sure you would like to leave your consultation?"),
      actions: [
        okButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myCustomPrintStatement('back button---');
        showAlertDialog(context);
        return false;
      },
      child: Scaffold(
        // appBar: appBar(context: context, title: 'Manish Talreja'),
        body: load
            ? const CustomLoader()
            : SafeArea(
                child: Container(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        _renderRemoteView(),
                        // Container(),
                        Positioned(
                          top: 30,
                          right: 20,
                          child: _renderLocalPreview(),
                        ),
                        Positioned(
                          top: 10,
                          right: 16,
                          left: 16,
                          child: AppBar(
                            toolbarHeight: 70,
                            automaticallyImplyLeading: false,
                            titleSpacing: 16,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            title: AppBarHeadingText(
                              text: '${widget.name}',
                              color: Colors.white,
                            ),
                            // leading: implyLeading
                            //     ? IconButton(
                            //   icon: const Icon(
                            //     Icons.chevron_left_outlined,
                            //     color: Colors.black,
                            //     size: 30,
                            //   ),
                            //   onPressed: onBackButtonTap != null
                            //       ? onBackButtonTap
                            //       : () {
                            //     Navigator.pop(context);
                            //   },
                            // )
                            //     : null,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 16,
                          left: 16,
                          child: Container(
                            height: 100,
                            // width: 200,
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: IconButton(
                                    onPressed: () async {
                                      // await joinChannel();

                                      isSpeakerEnabled = await _engine!
                                          .isSpeakerphoneEnabled();
                                      myCustomPrintStatement(
                                          'the speaker is $isSpeakerEnabled');
                                      await _engine!.setEnableSpeakerphone(
                                          !isSpeakerEnabled!);
                                      isSpeakerEnabled = await _engine!
                                          .isSpeakerphoneEnabled();
                                      myCustomPrintStatement(
                                          'the speaker new  is $isSpeakerEnabled');
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      isSpeakerEnabled != true
                                          ? Icons.volume_off
                                          : Icons.volume_down,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: IconButton(
                                    onPressed: () async {
                                      await _engine!.switchCamera();
                                      isBackCameraEnabled =
                                          !isBackCameraEnabled;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      isBackCameraEnabled == true
                                          ? Icons.flip_camera_ios_outlined
                                          : Icons.flip_camera_ios_outlined,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: IconButton(
                                    onPressed: () async {
                                      bool? result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 32),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 32),
                                              buttonPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 32,
                                              ),
                                              title: const SubHeadingText(
                                                text: 'Are you sure?',
                                              ),
                                              actions: [
                                                GestureDetector(
                                                  child: const SubHeadingText(
                                                      text: 'No'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                GestureDetector(
                                                  child: const SubHeadingText(
                                                      text: 'Yes'),
                                                  onTap: () async {
                                                    await EasyLoading.show(
                                                      status: null,
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black,
                                                    );
                                                    // await _engine!.
                                                    Map<String, dynamic> data =
                                                        {
                                                      'booking_id': widget
                                                          .bookingId
                                                          .toString(),
                                                      'user_id':
                                                          await getCurrentUserId(),
                                                      'duration': call_duration
                                                          .toString(),
                                                    };
                                                    var res = await Webservices
                                                        .postData(
                                                            apiUrl:
                                                                ApiUrls.endCall,
                                                            body: data,
                                                            context: context);
                                                    EasyLoading.dismiss();
                                                    // var res =
                                                    // await Webservices.get(ApiUrls.endCall+widget.bookingId.toString());
                                                    myCustomPrintStatement(
                                                        'call end----$res');
                                                    CustomNavigation.pop(
                                                        MyGlobalKeys
                                                            .navigatorKey
                                                            .currentContext!,
                                                        true);
                                                    // Navigator.pop(context, true);
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                      if (result == true) {
                                        try {
                                          if (_remoteUid != null) {
                                            await _engine!.leaveChannel();
                                            await _engine!.joinChannel(
                                                token: token ?? '',
                                                channelId: channelName,
                                                uid: 0,
                                                options:
                                                    const ChannelMediaOptions());
                                            // await _engine!.joinChannel(token, channelName, null, 0);
                                            // await _engine!.setCameraAutoFocusFaceModeEnabled(true);
                                            _remoteUid = null;
                                          } else {
                                            try {
                                              await _engine!.leaveChannel();
                                              await _engine!.joinChannel(
                                                  token: token ?? '',
                                                  channelId: channelName,
                                                  uid: 0,
                                                  options:
                                                      const ChannelMediaOptions());
                                              // await _engine!.joinChannel(token, channelName, null, 0);
                                              // await _engine!.setCameraAutoFocusFaceModeEnabled(true);
                                              _remoteUid = null;
                                            } catch (e) {
                                              myCustomPrintStatement(
                                                  'Error in catch block 32 $e');
                                            }
                                          }

                                          Navigator.pop(context);
                                        } catch (e) {
                                          myCustomPrintStatement(
                                              'Error in catch block34 $e');
                                        }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.call_end,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: IconButton(
                                    onPressed: () async {
                                      // await joinChannel();

                                      if (!isAudioEnabled) {
                                        await _engine!.enableAudio();
                                        isAudioEnabled = true;
                                      } else {
                                        await _engine!.disableAudio();
                                        isAudioEnabled = false;
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      isAudioEnabled == true
                                          ? Icons.mic_none
                                          : Icons.mic_off,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // IconButton(
                                //   onPressed: () async {
                                //     await _engine!.leaveChannel();
                                //   },
                                //   icon: Icon(
                                //     Icons.circle,
                                //     size: 100,
                                //   ),
                                //   color: Colors.green,
                                // ),

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: IconButton(
                                    onPressed: () async {
                                      // await joinChannel();
                                      myCustomPrintStatement('video enable');

                                      if (!isVideoEnabled) {
                                        // await _engine!.enableVideo();
                                        await _engine!.muteLocalVideoStream(
                                            isVideoEnabled);
                                        isVideoEnabled = true;
                                      } else {
                                        // await _engine!.disableVideo();
                                        await _engine!.muteLocalVideoStream(
                                            isVideoEnabled);
                                        isVideoEnabled = false;
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      isVideoEnabled
                                          ? Icons.videocam
                                          : Icons.videocam_off,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    // color: Colors.green,
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () async {
                                //     // await joinChannel();
                                //     myCustomPrintStatement('video enable');
                                //     await _engine!.enableLocalVideo(true);
                                //     await _engine!.enableVideo();
                                //     // await _engine!.enableVirtualBackground(true, VirtualBackgroundSource(color:20));
                                //     myCustomPrintStatement('video ${_engine}');
                                //     // await _engine!.video
                                //   },
                                //   icon: Icon(
                                //     Icons.video_call,
                                //     size: 60,
                                //   ),
                                //   color: Colors.green,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
