import 'package:bvsso/auth.dart';
import 'package:bvsso/constants.dart';
import 'package:bvsso/database.dart';
import 'package:bvsso/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ModeratorWrapper extends StatefulWidget {
  FirebaseUser user;
  ModeratorWrapper({
    @required this.user,
  });

  @override
  _ModeratorWrapperState createState() => _ModeratorWrapperState();
}

class _ModeratorWrapperState extends State<ModeratorWrapper> {
  FirebaseUser user;
  String userid;
  DatabaseServices databaseServices;
  bool isModerator;

  void setUid() {
    // print("setting uid: ${widget.uid}");
    print("user is ${user.toString()}");
    setState(() {
      userid = widget.user.uid;
    });
  }

  void setModerator() async {
    print("checking uid is $userid");
    isModerator = await databaseServices.getIsModerator(userid);
    setState(() {});
  }

  @override
  void initState() {
    setUid();
    databaseServices = new DatabaseServices();
    setModerator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("data sent is ${widget.user.uid}");
    if (isModerator == null) {
      return BackgroundImage(
        child: Spinner(),
      );
    } else if (isModerator == false) {
      return MyApp(uid: widget.user.uid);
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: customIcon(
                Icons.exit_to_app,
                true,
              ),
              onPressed: () async {
                await AuthServices().signOut();
              },
            )
          ],
        ),
        body: BackgroundImage(
          child: Center(
            child: Text(
              'Mod perms granted\nYou are a legend',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}

class MyApp extends StatefulWidget {
  String uid;

  MyApp({
    @required uid,
  });
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VideoPlayerController _controller;

  YoutubePlayerController youtubePlayerController = YoutubePlayerController(
    // initialVideoId: 'bOHslUK2E5w',
    initialVideoId: '8bJrWrTSHvY',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      hideThumbnail: true,
      // hideControls: true,
    ),
  );

  bool _isPlayerReady = false;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController.value.isFullScreen) {
      setState(() {
        _playerState = youtubePlayerController.value.playerState;
        _videoMetaData = youtubePlayerController.metadata;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      // 'https://www.youtube.com/watch?v=jZBDluCITmE',
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        /* appBar: !youtubePlayerController.value.isFullScreen
            ? AppBar(
                elevation: 0,
                backgroundColor: mainColor,
                actions: [
                  IconButton(
                    icon: customIcon(
                      Icons.exit_to_app,
                      true,
                    ),
                    onPressed: () async {
                      await AuthServices().signOut();
                    },
                  )
                ],
              )
            // : Container(),
            : null, */
        body: BackgroundImage(
          child: YoutubePlayerBuilder(
            onEnterFullScreen: () {
              setState(() {});
            },
            onExitFullScreen: () {
              setState(() {});
            },
            player: YoutubePlayer(
              aspectRatio: 16.0 / 9.0,
              controller: youtubePlayerController,
              progressIndicatorColor: Colors.lime,
              progressColors: ProgressBarColors(
                playedColor: mainColor,
                handleColor: mainColor,
              ),
              // topActions: [
              //   Text(
              //     "BVS Science Olympiad",
              //   ),
              // ],
              // bottomActions: [
              //   CurrentPosition(
              //     controller: youtubePlayerController,
              //   ),
              //   ProgressBar(
              //     controller: youtubePlayerController,
              //   ),
              //   RemainingDuration(
              //     controller: youtubePlayerController,
              //   ),
              // ],
              // bottomActions: [
              //   CurrentPosition(),
              //   ProgressBar(isExpanded: true),
              //   RemainingDuration(),
              //   FullScreenButton()
              //   // TotalDuration(),
              // ],
            ),
            builder: (context, player) =>
                NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!youtubePlayerController.value.isFullScreen)
                        AppBar(
                          elevation: 0,
                          backgroundColor: mainColor,
                          actions: [
                            IconButton(
                              icon: customIcon(
                                Icons.exit_to_app,
                                true,
                              ),
                              onPressed: () async {
                                await AuthServices().signOut();
                              },
                            )
                          ],
                        ),
                      /* Padding(
                  child: _controller.value.initialized
                      ? /* GestureDetector(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          onTap: () {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          },
                        ) */

                      /* YoutubePlayer(
                          controller: youtubePlayerController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: ProgressBarColors(
                            // playedColor: Colors.amber,
                            playedColor: mainColor,
                            handleColor: mainColor,
                          ),
                          onReady: () {
                            _controller.addListener(listener);
                          },
                        ) */
                      player
                      // Container()
                      : Spinner(),
                  padding: EdgeInsets.all(
                    16,
                  ),
                ), */
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          child: Image(
                            image: AssetImage(
                              'assets/images/icon3.png',
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Welcome to the Pythagoras' Pantheon app!\n\nThis app will host the various challenges that you will face in the module. We have two pieces of great news for you. The first is that since you see this text, our app works as intended, which is fantastic! Secondly, as the team who watched our ideas develop from simple thoughts to complex inventions, we are thrilled and exhillerated to see you oscillate between having fun in our module to grinding through questions.\n\nOf course, we wish you the very best. See you on the other side! 😁\n",
                      ),
                      // SizedBox(height: 12),
                      // Text(
                      //     "This app will host the various challenges that you will face in the module. We have two pieces of great news for you. The first is that since you see this text, our app works as intended, which is fantastic! Secondly, as the team who watched our ideas develop from simple thoughts to complex inventions, we are thrilled and exhillerated to see you oscillate between having fun in our module to grinding through questions."),
                      // SizedBox(height: 12),
                      // Text(
                      //   "Ofcourse, we wish you the very best. See you on the other side! 😁",
                      // ),
                      // SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'We have uploaded an introduction video on YouTube, which you can watch ',
                            ),
                            TextSpan(
                              text: 'here',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: '. ',
                              // style: TextStyle(
                              // decoration: TextDecoration.underline,
                              // ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 48),
                      // Padding(
                      //   padding: youtubePlayerController.value.isFullScreen
                      //       ? EdgeInsets.all(8.0)
                      //       : EdgeInsets.zero,
                      //   child: player,
                      // ),
                      SizedBox(height: 36),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Home(uid: widget.uid);
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(
                                20000,
                              ),
                            ),
                            child: ButtonText('Start'),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  String uid;

  Home({
    @required uid,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthServices authServices;
  bool isModerator;
  DatabaseServices databaseServices;
  Map<String, List<String>> roomLocations = {};
  Map<int, Map<String, List<String>>> roomLocationsCollection = {};
  Map<String, String> roomNames = {};
  Map<int, Map<String, String>> roomNamesCollection = {};

  int currentFloor = 1;

  String userState = "";

  stateCombine(String direction) {
    return "$userState$direction";
  }

  Widget CustomButton(String direction /* Should be 0, 1, 2 or 3*/) {
    // print("direction is $direction");
    String directionState = roomLocations[userState][int.parse(direction)];
    if (directionState == null) {
      return Container();
    } else if (directionState == "Back") {
      double offsetFactor = 45;
      Offset offset = new Offset(0, 0);

      if (direction == "1") {
        offset = Offset(offsetFactor, 0);
      } else if (direction == "3") {
        offset = Offset(-offsetFactor, 0);
      }

      return Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: int.parse(direction) % 2 == 0 ? 0 : -math.pi / 2,
          child: EmptyButton(
            () {
              setState(
                () {
                  userState = userState.substring(0, userState.length - 1);
                },
              );
            },
            'Back',
            /* child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: buttonWidth,
            vertical: buttonHeight,
          ),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(
              20000,
            ),
          ),
          child: ButtonText('Back'),
        ),
      ); */
          ),
        ),
      );
    } else {
      double offsetFactor = 45;
      Offset offset = new Offset(0, 0);

      if (direction == "1") {
        offset = Offset(offsetFactor, 0);
      } else if (direction == "3") {
        offset = Offset(-offsetFactor, 0);
      }

      return Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: int.parse(direction) % 2 == 0 ? 0 : -math.pi / 2,
          child: EmptyButton(
            () {
              setState(
                () {
                  // userState = userState.substring(0, userState.length - 1);
                  userState = stateCombine(direction);
                },
              );
            },
            // '$direction',
            // 'TBD',
            // "${roomNames["${stateCombine(direction)}"]}${stateCombine(direction)}",
            "${roomNames["${stateCombine(direction)}"]}",
          ),
        ),
      );
    }
  }

  Widget roomsDisplay() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CustomButton("0"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton("1"),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton("2"),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomButton("3"),
            ),
          ],
        ),
      ),
    );
  }

  Widget navigationPanel() {
    return Container(
      child: Center(
        child: userState == ""
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (roomLocationsCollection.containsKey(currentFloor + 1))
                    EmptyButton(() {
                      setState(() {
                        currentFloor++;
                        roomLocations = roomLocationsCollection[currentFloor];
                        roomNames = roomNamesCollection[currentFloor];
                        userState = "";
                      });
                    }, "Next floor"),
                  Text(
                    // userState,
                    "\nCurrent Floor: $currentFloor\nRoom: Lobby\n",
                    textAlign: TextAlign.center,
                  ),
                  if (roomLocationsCollection.containsKey(currentFloor - 1))
                    EmptyButton(() {
                      setState(() {
                        currentFloor--;
                        roomLocations = roomLocationsCollection[currentFloor];
                        roomNames = roomNamesCollection[currentFloor];
                        userState = "";
                      });
                    }, "Previous floor"),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      // "Current Floor: $currentFloor\nCurrent room: ${roomNames["$userState"]}",
                      "Current Floor: $currentFloor\nCurrent room: $userState",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  getIsModerator() async {
    isModerator = await databaseServices.getIsModerator(widget.uid);
    setState(() {});
  }

  getRoomNames() async {
    roomNamesCollection = await databaseServices.getRoomNames();
    roomNames = roomNamesCollection[currentFloor];
    setState(() {});
  }

  getRoomLocations() async {
    roomLocationsCollection = await databaseServices.getRoomLocations();
    roomLocations = roomLocationsCollection[currentFloor];
    setState(() {});
  }

  @override
  void initState() {
    // authServices = new AuthServices();
    // getIsModerator();
    databaseServices = new DatabaseServices();
    getRoomNames();
    getRoomLocations();
    getIsModerator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isModerator == null) {
      return Scaffold(
        body: BackgroundImage(
          child: Spinner(),
        ),
      );
    } else if (isModerator == false) {
      if (roomLocations.isEmpty || roomNames.isEmpty) {
        return Scaffold(
          body: BackgroundImage(
            child: Spinner(),
          ),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
              lowOpacityImage(),
              roomsDisplay(),
              navigationPanel(),
            ],
          ),
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: Text('Moderator permissions granted'),
        ),
      );
    }
  }
}
