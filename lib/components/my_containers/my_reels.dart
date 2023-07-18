import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Reels extends StatefulWidget {
  final String postVideoUrl;
  const Reels({super.key, required this.postVideoUrl});

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.network(widget.postVideoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => videoController.play());
  }

  Future<void> initVideoPlayer() async {
    // Get the cached file using the cache manager
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(widget.postVideoUrl);

    // Use the cached file if it exists, otherwise fetch the video
  }

  @override
  void dispose() {
    videoController.pause();
    videoController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: videoController != null && videoController.value.isInitialized
          ? buildVideo()
          : Center(
              child: CircularProgressIndicator(color: Colors.deepPurple[600]),
            ),
    );
  }

  Widget buildVideo() {
    return InkWell(
        onTap: () {
          videoController.value.isPlaying
              ? videoController.pause()
              : videoController.play();
        },
        child: Stack(children: [
          Positioned.fill(child: buildVideoPlayer()),
          Positioned.fill(
              child: BasicOverlayWidget(controller: videoController)),
        ]));
  }

  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: videoController.value.aspectRatio,
      child: VideoPlayer(videoController));
}

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const BasicOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      buildPlay(),
      buildIndicator(),
    ]);
  }

  Widget buildIndicator() => VideoProgressIndicator(controller,
      allowScrubbing: true,
      padding: const EdgeInsets.all(8),
      colors: VideoProgressColors(
        playedColor: Colors.grey.shade100,
        backgroundColor: Colors.deepPurple.shade600,
      ));

  Widget buildPlay() {
    return controller.value.isPlaying
        ? Container()
        : Container(
            alignment: Alignment.center,
            color: Colors.black26,
            child: Icon(Icons.play_arrow_rounded,
                size: 70, color: Colors.grey[200]));
  }
}
