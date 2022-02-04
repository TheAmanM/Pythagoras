import 'package:bvsso/auth.dart';
import 'package:bvsso/constants.dart';
import 'package:bvsso/database.dart';
import 'package:flutter/cupertino.dart';
// import 'package:bvsso/main.dart';
import 'credits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    @required this.uid,
  });
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
/*   VideoPlayerController _controller;

  YoutubePlayerController youtubePlayerController = YoutubePlayerController(
    // initialVideoId: 'bOHslUK2E5w',
    initialVideoId: '8bJrWrTSHvY',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      hideThumbnail: true,
      // hideControls: true,
    ),
  ); */

  // PlayerState _playerState;
  // YoutubeMetaData _videoMetaData;

  /* void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController.value.isFullScreen) {
      setState(() {
        _playerState = youtubePlayerController.value.playerState;
        _videoMetaData = youtubePlayerController.metadata;
      });
    }
  } */

  bool enableRound1;
  String round1Text = "";

  String name;

  void setName() async {
    name = await DatabaseServices().getUserName(widget.uid);
    setState(() {});
  }

  @override
  void initState() {
    // _controller = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   // 'https://www.youtube.com/watch?v=jZBDluCITmE',
    // )..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    setName();
    setEnableRound1();
    super.initState();
  }

  void setEnableRound1() async {
    Map round1Data = await DatabaseServices().getRound1Data();
    enableRound1 = round1Data["enableRound1"];
    round1Text = round1Data["introText"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
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
          child:
              // YoutubePlayerBuilder(
              //   onEnterFullScreen: () {
              //     setState(() {});
              //   },
              //   onExitFullScreen: () {
              //     setState(() {});
              //   },
              //   player: YoutubePlayer(
              //     aspectRatio: 16.0 / 9.0,
              //     controller: youtubePlayerController,
              //     progressIndicatorColor: Colors.lime,
              //     progressColors: ProgressBarColors(
              //       playedColor: mainColor,
              //       handleColor: mainColor,
              //     ),
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
              // ),
              // builder: (context, player) =>
              enableRound1 != null && name != null
                  ? SafeArea(
                      child:
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
                                // if (!youtubePlayerController.value.isFullScreen)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: customIcon(
                                      Icons.exit_to_app,
                                      true,
                                    ),
                                    onPressed: () async {
                                      await AuthServices().signOut();
                                    },
                                  ),
                                ),
                                /* AppBar(
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
                        ), */
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
                                  round1Text
                                      .split("\\n")
                                      .join("\n")
                                      .replaceAll(RegExp('<name>'), '$name'),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    // style: TextStyle(
                                    //   fontSize: 15,
                                    // ),
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
                                Opacity(
                                  opacity: enableRound1 ? 1.0 : 0.4,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: enableRound1
                                          ? () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) {
                                                    return Home(
                                                        uid: widget.uid);
                                                  },
                                                ),
                                              );
                                            }
                                          : () {
                                              //   Scaffold.of(context).showSnackBar(
                                              //     SnackBar(
                                              //       content: Text(
                                              //         'Sorry, Round 1 has not begun yet. Please stay updated on our Discord server to find out more. ',
                                              //       ),
                                              //       duration:
                                              //           Duration(seconds: 3),
                                              //     ),
                                              //   );
                                              CustomSnackBar(
                                                context,
                                                text:
                                                    "Round 1 has not begun yet. Please stay updated on our Discord server to find out more. ",
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
                                          child: ButtonText('Start')),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // ),
                    )
                  : Spinner(),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  String uid;

  Home({
    @required this.uid,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthServices authServices;
  bool isModerator;
  DatabaseServices databaseServices;
  // Map<String, List<String>> roomLocations = {};
  Map roomLocations = {};
  // Map<String, Map<String, List<String>>> roomLocationsCollection = {};
  Map roomLocationsCollection = {};
  // Map<String, String> roomNames = {};
  Map roomNames = {};
  // Map<String, Map<String, String>> roomNamesCollection = {};
  Map roomNamesCollection = {};
  // Map<String, Map<String, String>> questionsCollection = {};
  Map questionsCollection = {};

  Map answersCollection = {};

  int currentFloor = 1;
  String userState = "";

  List<Widget> textFieldList = [];
  List<String> textFieldStates = [];
  List<TextEditingController> controllers = [];
  List<String> answerKeys = [];

  void clearFields() {
    textFieldList = [];
    textFieldStates = [];
    controllers = [];
    answerKeys = [];
  }

  void prepareCheckAnswer() {
    Map questionsData = questionsCollection[currentFloor.toString()];
    for (int i = 0; i < questionsData.keys.length; i++) {
      String key = questionsData.keys.toList()[i];
      controllers.add(
        new TextEditingController(),
      );
      answerKeys.add(key);

      textFieldList.add(
        EmptyTextField(
          "${roomNames[key].toString()}",
          controllers[i],
          keyboardType: TextInputType.number,
          // border: OutlineInputBorder(
          //   borderSide: BorderSide(color: )
          // )
        ),
      );
      // textFieldList.add(
      //   SizedBox(
      //     height: 12,
      //   ),
      // );
      textFieldStates.add("");
    }
  }

  void setTextFieldStates(List<int> userAnswersList, List<int> correctAnswers) {
    Map<String, int> userAnswers = {};
    for (int i = 0; i < userAnswersList.length; i++) {
      print(answerKeys[i]);
      userAnswers[answerKeys[i].toString()] = userAnswersList[i];
    }
    Map correctAnswers = answersCollection[currentFloor.toString()];
    Map questionsData = questionsCollection[currentFloor.toString()];
    List<MaterialColor> fieldColors = [];
    for (int i = 0; i < questionsData.keys.length; i++) {
      String key = questionsData.keys.toList()[i];
      // Color fieldColor;
      if (correctAnswers[key] == userAnswers[key]) {
        print('Correct => green');
        fieldColors.add(Colors.green);
      } else {
        // print(correctAnswers[key]);
        // print(userAnswers[key]);
        print(
            "Key $key at ${roomNames[key]}: Should be ${correctAnswers[key]}, is ${userAnswers[key]}");
        print('Incorrect => red');
        fieldColors.add(Colors.red);
      }
      // }
    }
    for (int j = 0; j < textFieldList.length; j++) {
      String key = questionsData.keys.toList()[j];
      textFieldList[j] =
          EmptyTextField("${roomNames[key].toString()}", controllers[j],
              keyboardType: TextInputType.number,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2000),
                borderSide: BorderSide(
                  color: fieldColors[j],
                  // width: 3,
                ),
              )
              // ),
              );
    }
  }

  bool compareLists(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  List<int> answerCheckFormat(/* Map<String, String> */ ans) {
    List<int> returnAnswer = [];
    for (String key in ans.keys) {
      print('ANSWER CHECK FORMAT');
      print(ans);
      print(key);
      print(ans[key.toString()].runtimeType);
      returnAnswer.add(ans[key.toString()]);
    }
    return returnAnswer;
  }

  Future<void> checkAnswer() async {
    List<int> answers = [];
    for (TextEditingController controller in controllers) {
      print("controller text is ${controller.text}");
      answers.add(
        int.parse(controller.text),
      );
    }
    List<int> correctAnswer =
        answerCheckFormat(answersCollection[currentFloor.toString()]);
    // correctAnswer.sort();
    // answers.sort();
    print(
      "correct answer is $correctAnswer",
    );
    print(
      'user answer is $answers',
    );
    // if (correctAnswer.toString() == answers.toString()) {
    if (compareLists(correctAnswer, answers)) {
      print("CORRECT ANSWER WORKS LETS GOOOO");
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
      Navigator.pop(context);
      await databaseServices.incrementLevel(currentFloor, widget.uid);
    } else {
      print(answers);
      print('Setting state');
      super.setState(() {
        setTextFieldStates(answers, correctAnswer);
      });
      // Scaffold.of(context)
      // .showSnackBar(
      /* CustomSnackBar(
                                                                                      context,
                                                                                      text: 'Invalid answer',
                                                                                      // ),
                                                                                    ); */
      print("INVALID ANSWER");
      // print(textFieldList);
    }
  }

  void checkForQuestion(BuildContext context) async {
    await Future.delayed(
      Duration(
        milliseconds: 10,
      ),
    );
    if (questionsCollection[currentFloor.toString()].containsKey(userState)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Image.network(
                questionsCollection[currentFloor.toString()][userState],
              ),
            ),
            contentPadding: EdgeInsets.zero,
          );
        },
      );
    }
  }

  Widget checkAnswerDialog(/* BuildContext context */) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Answers',
            style: TextStyle(
              color: mainColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 18,
          ),
          ...textFieldList,
          Spacer(),
          Align(
            alignment: Alignment.center,
            child: EmptyButton(
              () async {
                await checkAnswer();
                setState(() {});
              },
              'Check',
              inverse: true,
            ),
          ),
        ],
      ),
    );
  }

  listToMap(List<int> input, Map<String, String> conversion) {
    // for (String key in conversion.keys.toList()) {
    //   String value =
    // }
  }

  stateCombine(String direction) {
    return "$userState$direction";
  }

  Widget CustomButton(
      String direction /* Should be 0, 1, 2 or 3*/, Alignment alignment) {
    // print("direction is $direction");
    String directionState = roomLocations[userState][int.parse(direction)];
    // print("directionState: $directionState");
    if (directionState == null) {
      return Container();

      //   return Container(
      //     child: Align(
      //       alignment: alignment,
      //       child: Transform.translate(
      //         offset: Offset.zero,
      //         // offset: offset,
      //         child: Transform.rotate(
      //           // angle: int.parse(direction) % 2 == 0 ? 0 : -math.pi / 2,
      //           angle: 0,
      //           child: RotatedBox(
      //             quarterTurns:
      //                 int.parse(direction) % 2 == 0 ? 0 : -int.parse(direction),
      //             child: Text('${directionState.toString()} value'),
      //           ),
      //         ),
      //       ),
      //     ),
      //   );
    } else if (directionState == "Back") {
      // if (userState == "3" && direction == "1") {
      //   print("its $direction and $userState");
      //   print('$directionState');
      //   return Text('HIIIIIIIII');
      // }
      // print('Back');
      // double offsetFactor = 45;
      // Offset offset = new Offset(0, 0);

      // if (direction == "1") {
      //   offset = Offset(offsetFactor, 0);
      // } else if (direction == "3") {
      //   offset = Offset(-offsetFactor, 0);
      // }

      return Align(
        alignment: alignment,
        child: RotatedBox(
          quarterTurns:
              int.parse(direction) % 2 == 0 ? 0 : -int.parse(direction),
          child: EmptyButton(
            () {
              setState(
                () {
                  userState = userState.substring(0, userState.length - 1);
                },
              );
              // checkForQuestion(context);
            },
            'Back ',
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
      double offsetFactor = 90;
      Offset offset = new Offset(0, 0);

      if (direction == "1") {
        offset = Offset(offsetFactor, 0);
      } else if (direction == "3") {
        offset = Offset(-offsetFactor, 0);
      }

      return Align(
        alignment: alignment,
        child:
            // Align(
            //   alignment: direction == "1"
            //       ? Alignment.centerLeft
            //       : direction == "3"
            //           ? Alignment.centerRight
            //           : direction == "0"
            //               ? Alignment.topCenter
            //               : Alignment.bottomCenter,
            //   child:
            Transform.translate(
          offset: Offset.zero,
          // offset: offset,
          child: Transform.rotate(
            // angle: int.parse(direction) % 2 == 0 ? 0 : -math.pi / 2,
            angle: 0,
            child: RotatedBox(
              quarterTurns:
                  int.parse(direction) % 2 == 0 ? 0 : -int.parse(direction),
              child: EmptyButton(
                () {
                  setState(
                    () {
                      // userState = userState.substring(0, userState.length - 1);
                      userState = stateCombine(direction);
                    },
                  );
                  // checkForQuestion(context);
                },
                // '$direction',
                // 'TBD',
                // "${roomNames["${stateCombine(direction)}"]}${stateCombine(direction)}",
                "${roomNames["${stateCombine(direction)}"]}",
              ),
            ),
          ),
          // ),
        ),
      );
    }
  }

  Widget roomsDisplay() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Stack(
        children: [
          CustomButton(
            "0",
            Alignment.topCenter,
          ),
          CustomButton(
            "1",
            Alignment.centerRight,
          ),
          CustomButton(
            "2",
            Alignment.bottomCenter,
          ),
          CustomButton(
            "3",
            Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

  Widget navigationPanel(int maxFloor) {
    return Container(
      child: Center(
        child: userState == ""
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (roomLocationsCollection
                      .containsKey((currentFloor).toString()))
                    maxFloor != currentFloor
                        ? EmptyButton(
                            () {
                              if (roomLocationsCollection
                                  .containsKey((currentFloor + 1).toString())) {
                                setState(() {
                                  currentFloor++;
                                  roomLocations = roomLocationsCollection[
                                      currentFloor.toString()];
                                  roomNames = roomNamesCollection[
                                      currentFloor.toString()];
                                  userState = "";
                                  clearFields();
                                  prepareCheckAnswer();
                                });
                                checkForQuestion(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) {
                                      return Credits();
                                    },
                                  ),
                                );
                              }
                            },
                            roomLocationsCollection
                                    .containsKey((currentFloor + 2).toString())
                                ? "Next floor"
                                : roomLocationsCollection.containsKey(
                                        (currentFloor + 1).toString())
                                    ? "Final floor"
                                    : "Finish",
                          )
                        : GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                // builder: nextLevelMenuBuilder,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      // vertical: 360,
                                    ),
                                    child: checkAnswerDialog(),
                                    // ),
                                  );
                                },
                              );
                            },
                            child: FractionallySizedBox(
                              widthFactor: 0.175,
                              child: Image.asset(
                                'assets/images/lock.png',
                              ),
                            ),
                          ),
                  Text(
                    // userState,
                    "\nCurrent Floor: $currentFloor\nLobby\n",
                    textAlign: TextAlign.center,
                  ),
                  if (roomLocationsCollection
                      .containsKey((currentFloor - 1).toString()))
                    EmptyButton(() {
                      setState(() {
                        currentFloor--;
                        roomLocations =
                            roomLocationsCollection[currentFloor.toString()];
                        roomNames =
                            roomNamesCollection[currentFloor.toString()];
                        userState = "";
                      });
                      checkForQuestion(context);
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
                      "Current Floor: $currentFloor\n${roomNames[userState]}",
                      textAlign: TextAlign.center,
                    ),
                    if (questionsCollection[currentFloor.toString()]
                        .containsKey(userState))
                      EmptyButton(
                        () {
                          checkForQuestion(context);
                        },
                        'Question',
                      )
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

/*   getQuestions() async {
    questionsCollection = await databaseServices.getQuestions();
    setState(() {});
  }

  getRoomNames() async {
    roomNamesCollection = await databaseServices.getRoomNames();
    roomNames = roomNamesCollection[currentFloor.toString()];
    setState(() {});
  }

  getRoomLocations() async {
    roomLocationsCollection = await databaseServices.getRoomLocations();
    roomLocations = roomLocationsCollection[currentFloor.toString()];
    setState(() {});
  } */

  void setData() async {
    List result = await databaseServices.getData();
    roomLocationsCollection = result[0];
    roomLocations = roomLocationsCollection["1"];
    print(roomLocations);

    roomNamesCollection = result[1];
    roomNames = roomNamesCollection[currentFloor.toString()];

    questionsCollection = result[2];
    prepareCheckAnswer();
    // clearFields();

    answersCollection = result[3];

    // checkForQuestion(context);

    setState(() {});
  }

  @override
  void initState() {
    // authServices = new AuthServices();
    // getIsModerator();
    databaseServices = new DatabaseServices();
    getIsModerator();

    setData();
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
        // checkForQuestion(context);
        return Scaffold(
          body: StreamBuilder(
            stream: databaseServices.getCurrentLevel(widget.uid),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                // currentFloor = snapshot.data.data["currentLevel"];
                // print(snapshot.data.data);
                print(snapshot.data.data["currentLevel"]);
              }
              return snapshot.hasData
                  ? Stack(
                      children: [
                        lowOpacityImage(),
                        roomsDisplay(),
                        navigationPanel(snapshot.data.data["currentLevel"]),
                      ],
                    )
                  : BackgroundImage(
                      child: Spinner(),
                    );
            },
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
