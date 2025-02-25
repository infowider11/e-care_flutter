// import 'package:calltofix/modals/videos_modal.dart';
// import 'package:calltofix/widgets/CustomTexts.dart';
// import 'package:calltofix/widgets/customLoader.dart';
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/appbar.dart';

class VideoPlayerPage extends StatefulWidget {
  final Map? videoModal;
  const VideoPlayerPage({Key? key, this.videoModal}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool isPlaying = false;

  late VideoPlayerController _controller;
  // late VideoPlayerController _controller2;

  @override
  void initState() {
   
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
  //   
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
    return Scaffold(
      appBar: appBar(context: context, title: 'Video', fontsize: 20),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
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
           
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        
      ),
    );
  }
}
