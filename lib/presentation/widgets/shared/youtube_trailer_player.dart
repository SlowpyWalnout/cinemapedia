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
      autoPlay: true,
      params: const YoutubePlayerParams(
        mute: false,
        enableCaption: false,
        captionLanguage: 'es',
        interfaceLanguage: 'es',
        showVideoAnnotations: false,
        loop: false,
        strictRelatedVideos: true,
        privacyEnhancedMode: true,
        playsInline: true,
        enableKeyboard: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: const [
          YoutubePlayerTheme(
            progressBarActiveColor: Colors.red,
            progressBarBufferedColor: Colors.redAccent,
            progressBarBackgroundColor: Colors.white24,
            controlsColor: Colors.white,
            timerStyle: TextStyle(color: Colors.white, fontSize: 12),
            titleStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      child: YoutubePlayer(
        controller: controller,
        aspectRatio: 16 / 9,
        autoHideDuration: const Duration(seconds: 3),
        backgroundColor: Colors.black,
        autoFullScreen: true,
        enableFullScreenOnVerticalDrag: true,
        keepAlive: false,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
