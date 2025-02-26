// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:ecare/modals/file_upload_modal.dart';
import 'package:ecare/widgets/appbar.dart';
import 'package:ecare/widgets/custom_circular_image.dart';
import 'package:ecare/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final FileUploadModal documentData;

  const VideoPlayerWidget({super.key, required this.documentData});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  ValueNotifier<bool> pageLoadNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    print("widget.documentData.filePath ${widget.documentData.filePath}");
    // Initialize the video player controller with the video URL
    initializeVideoPlayer();

    // Initialize the Chewie controller
    // _chewieController = ChewieController(
    //   videoPlayerController: _videoPlayerController,
    //   aspectRatio: 5 / 9, // Adjust this to match your video's aspect ratio
    //   autoInitialize: true,

    //   autoPlay:
    //       true, // Set this to true if you want the video to start automatically
    //   looping: false, // Set this to true if you want the video to loop
    //   showControls: true, // Show video player controls
    //   allowMuting: true, // Allow audio muting
    // );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    _videoPlayerController = widget.documentData.fileType == CustomFileType.file
        ? VideoPlayerController.file(
            File(widget.documentData.filePath.path),
          )
        : VideoPlayerController.networkUrl(
            Uri.parse(widget.documentData.filePath));
    await _videoPlayerController!.initialize();

    setState(() {
      // Automatically set aspect ratio based on video dimensions
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoInitialize: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_chewieController != null && _chewieController!.isFullScreen) {
          _chewieController!.toggleFullScreen();
          return true;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: appBar(context: context, title: 'Video', fontsize: 20),
        body: Center(
            child: _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : const CustomLoader()),
      ),
    );
  }
}
