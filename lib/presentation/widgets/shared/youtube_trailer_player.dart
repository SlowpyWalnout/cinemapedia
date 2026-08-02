import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeTrailerPlayer extends StatefulWidget {
  final String videoId;

  const YoutubeTrailerPlayer({super.key, required this.videoId});

  @override
  State<YoutubeTrailerPlayer> createState() => _YoutubeTrailerPlayerState();
}

class _YoutubeTrailerPlayerState extends State<YoutubeTrailerPlayer> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = _createController();
  }

  YoutubePlayerController _createController() {
    return YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(controller: controller, aspectRatio: 16 / 9);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
