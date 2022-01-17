import 'package:bvsso/auth.dart';
import 'package:bvsso/constants.dart';
import 'package:bvsso/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      return Spinner();
    } else if (isModerator == false) {
      return MyApp(uid: widget.user.uid);
    } else {
      return Center(
        child: Text(
          'Mod perms granted\nYou are a legend',
          textAlign: TextAlign.center,
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
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            child: _controller.value.initialized
                ? GestureDetector(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    onTap: () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    },
                  )
                : Spinner(),
            padding: EdgeInsets.all(
              16,
            ),
          ),
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
        ],
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
  Map<String, List<String>> questions = {};

  String userState = "";

  stateCombine(String direction) {
    return "$userState$direction";
  }

  Widget CustomButton(String direction /* Should be 0, 1, 2 or 3*/) {
    double buttonHeight = 10;
    double buttonWidth = 40;

    String directionState = questions[userState][int.parse(direction)];
    if (directionState == null) {
      return Container();
    } else if (directionState == "Back") {
      return GestureDetector(
        onTap: () {
          setState(
            () {
              userState = userState.substring(0, userState.length - 1);
            },
          );
        },
        child: Container(
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
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            userState = stateCombine(direction);
          });
        },
        child: Container(
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
          child: ButtonText('$direction'),
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
        child: Text(
          userState,
        ),
      ),
    );
  }

  getIsModerator() async {
    isModerator = await databaseServices.getIsModerator(widget.uid);
    setState(() {});
  }

  getQuestions() async {
    questions = await databaseServices.getQuestions();
    setState(() {});
  }

  @override
  void initState() {
    // authServices = new AuthServices();
    // getIsModerator();
    databaseServices = new DatabaseServices();
    getQuestions();
    getIsModerator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isModerator == null) {
      return Scaffold(
        body: Spinner(),
      );
    } else if (isModerator == false) {
      if (questions.isEmpty) {
        return Scaffold(
          body: Spinner(),
        );
      } else {
        return Scaffold(
          body: Stack(
            children: [
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
