// import 'package:calltofix/modals/videos_modal.dart';
// import 'package:calltofix/widgets/CustomTexts.dart';
// import 'package:calltofix/widgets/customLoader.dart';
import 'package:ecare/functions/global_Var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:video_player/video_player.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import '../widgets/CustomTexts.dart';
import '../widgets/appbar.dart';
import '../widgets/loader.dart';

class VideoPlayerPage extends StatefulWidget {
  final Map? videoModal;
  const VideoPlayerPage({Key? key,this.videoModal}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

  late VlcPlayerController _videoPlayerController;
  bool isPlaying = false;

  late VideoPlayerController _controller;
  // late VideoPlayerController _controller2;

  @override
  void initState() {
    // _controller = VideoPlayerController.asset('assets/images/doctor.mp4')..initialize().then((_) {
    //   print('video play----');
    //   setState(() {
    //
    //   });
    // });
    // _controller2 = VideoPlayerController.asset('assets/images/patient.mp4')..initialize().then((_) {
    //   print('video play----');
    //   setState(() {
    //
    //   });
    // });
    _controller = VideoPlayerController.network(
      // videoPlayerOptions: VideoPlayerOptions(
      //   allowBackgroundPlayback: true,
      //   mixWithOthers: true,
      // ),
        widget.videoModal!['video'])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();

  }

  // Future<void> initializePlayer() async {}


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _videoPlayerController = VlcPlayerController.network(
  //     widget.videoModal!['video'],
  //     hwAcc: HwAcc.full,
  //     autoPlay: false,
  //     options: VlcPlayerOptions(
  //
  //     ),
  //   );
  //   super.initState();
  // }
  // @override
  // void dispose() async {
  //   super.dispose();
  //   await _videoPlayerController.stopRendererScanning();
  //   // await _videoViewController.dispose();
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    // _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: appBar(context: context,title: 'Video',fontsize: 20),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio:_controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
              // if(user_Data!['type'].toString()=='1'){
              //   _controller.value.isPlaying
              //       ? _controller.pause()
              //       : _controller.play();
              // } else {
              //   _controller2.value.isPlaying
              //       ? _controller2.pause()
              //       : _controller2.play();
              // }

            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          //     :Icon(
          //   _controller2.value.isPlaying ? Icons.pause : Icons.play_arrow,
          // ),
        ),
      ),
    );
  }


}

  // @override
  // Widget build(BuildContext context) {
  //   // print(widget.videoModal.file);
  //   // return Scaffold(
  //   //   appBar: appBar(context: context,title: 'Video',fontsize: 20),
  //   //   body:  Column(
  //   //     children: [
  //   //       // ParagraphText(text:widget.videoModal.title),
  //   //       Container(
  //   //         height: MediaQuery.of(context).size.width*9/16,
  //   //         decoration: BoxDecoration(
  //   //           image: DecorationImage(
  //   //             image: NetworkImage(
  //   //               widget.videoModal!['video_thumbnail']
  //   //             ),
  //   //             fit: BoxFit.fill
  //   //           )
  //   //         ),
  //   //         child: Stack(
  //   //           children: [
  //   //             VlcPlayer(
  //   //               controller: _videoPlayerController,
  //   //               aspectRatio: 16 / 9,
  //   //               // virtualDisplay: true,
  //   //               placeholder: Center(child: CustomLoader()),
  //   //
  //   //             ),
  //   //             Center(
  //   //               child: IconButton(onPressed: ()async{
  //   //                 print('kljdsflksj');
  //   //                 print('${_videoPlayerController.isPlaying()}');
  //   //                 isPlaying = (await _videoPlayerController.isPlaying())??false;
  //   //                 if(isPlaying){
  //   //                   _videoPlayerController.pause();
  //   //                 }else{
  //   //                   _videoPlayerController.play();
  //   //                 }
  //   //                 setState(() {
  //   //
  //   //                 });
  //   //               }, icon: Icon(!isPlaying? Icons.pause:Icons.play_arrow, color: Colors.white,size: 40,)),
  //   //             )
  //   //           ],
  //   //         ),
  //   //
  //   //       ),
  //   //       // Row(
  //   //       //   mainAxisAlignment: MainAxisAlignment.center,
  //   //       //   children: [
  //   //       //     IconButton(onPressed: ()async{
  //   //       //       print('kljdsflksj');
  //   //       //       print('${_videoPlayerController.isPlaying()}');
  //   //       //       isPlaying = (await _videoPlayerController.isPlaying())??false;
  //   //       //       if(isPlaying){
  //   //       //             _videoPlayerController.pause();
  //   //       //           }else{
  //   //       //         _videoPlayerController.play();
  //   //       //       }
  //   //       //           setState(() {
  //   //       //
  //   //       //       });
  //   //       //     }, icon: Icon(!isPlaying? Icons.pause:Icons.play_arrow))
  //   //       //   ],
  //   //       // ),
  //   //     ],
  //   //   ),
  //   // );
  // }
// }
