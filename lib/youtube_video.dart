import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  String url;
  VideoDisplay({
    @required String url,
  });

  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  String url;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    _controller = VideoPlayerController.network(
      url,
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.initialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: GestureDetector(
          child: VideoPlayer(_controller),
          onTap: () {
            /* setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            }); */
          },
        ),
      );
    } else {
      return Text('Not ready for some reason');
    }
  }
}
/* 
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

YoutubePlayerController _controller = YoutubePlayerController(
  initialVideoId: 'iLnmTe5Q2Qw',
  flags: YoutubePlayerFlags(
    autoPlay: true,
    mute: true,
  ),
);

Widget player = YoutubePlayer(
  controller: _controller,
  showVideoProgressIndicator: true,
  progressIndicatorColor: Colors.amber,
  progressColors: ProgressBarColors(
    playedColor: Colors.amber,
    handleColor: Colors.amberAccent,
  ),
  onReady: () {
    _controller.addListener(listener);
  },
);

void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  } */
