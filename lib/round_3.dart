import 'package:bvsso/auth.dart';
import 'package:bvsso/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'dart:math' as math;

class RoundThreeHome extends StatefulWidget {
  String uid;
  RoundThreeHome({this.uid});

  @override
  _RoundThreeHomeState createState() => _RoundThreeHomeState();
}

class _RoundThreeHomeState extends State<RoundThreeHome> {
  void setEmptyAnswerGrid(List tableHeights, int tableWidth) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection('userData')
        .document(widget.uid)
        .get();
    if (!doc.data.containsKey("round3Answers")) {
      Map<String, bool> emptyMap = {};
      int totalTableHeight = 0;
      tableHeights.forEach((element) {
        totalTableHeight += int.parse(element.toString());
      });
      int numCells = totalTableHeight * tableWidth;
      for (int i = 1; i <= numCells; i++) {
        emptyMap[i.toString()] = false;
      }
      await Firestore.instance
          .collection('userData')
          .document(widget.uid)
          .updateData({"round3Answers": emptyMap});
    }
  }

  List<double> toDoubleList(Map input) {
    List<double> returnList = [];
    for (int i = 0; i < input.keys.length; i++) {
      returnList.add(double.parse(input[(i + 1).toString()].toString()));
    }
    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('settings')
            .document('settings')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map round3Data = snapshot.data.data["round3Data"];
            questions = round3Data["questions"];
            correctAnswers = toDoubleList(round3Data["answers"]);
            Map data = round3Data["introData"];
            setEmptyAnswerGrid(
                round3Data["tableHeights"], round3Data["tableWidth"]);
            return SafeArea(
              child: NotificationListener<OverscrollIndicatorNotification>(
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
                          data["introText"].toString().split('\\n').join('\n'),
                        ),
                        // Spacer(),
                        SizedBox(
                          height: 36,
                        ),
                        if (data["enableRound"])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EmptyButton(() {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) {
                                      return RoundThree(
                                        uid: widget.uid,
                                      );
                                    },
                                  ),
                                );
                              }, "Start"),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Spinner();
          }
        },
      ),
    );
  }
}

class RoundThree extends StatefulWidget {
  String uid;
  RoundThree({@required this.uid});
  @override
  _RoundThreeState createState() => _RoundThreeState();
}

List<TextEditingController> controllers = [];
List<bool> truthTable = [];
List<double> correctAnswers = [];

Map userAnswerMap;

Map questions;

int calculateScore(
  List<int> tableHeights,
  int tableWidth,
  Map<String, bool> userAnswers,
) {
  List<int> cumulativeTableHeights = [];
  int currentScore = 0;
  int score = 0;

  for (int value in tableHeights) {
    currentScore += value;
    cumulativeTableHeights.add(currentScore);
  }

  int lastIndex = 0;

  int baseScore = 5;
  int power = 2;

  int sectionNum = 0;

  for (int num in cumulativeTableHeights) {
    lastIndex++;
    sectionNum++;
    // print("Loop from $lastIndex to ${num * tableWidth}");
    print("");
    int lowerBound = lastIndex;
    int upperBound = num * tableWidth;
    for (int i = lowerBound; i <= upperBound; i++) {
      if (userAnswers.containsKey(i.toString())) {
        if (userAnswers[i.toString()] == true) {
          int scoreAdded = baseScore * math.pow(power, sectionNum - 1).toInt();
          print("$i is correct! Adding $scoreAdded points. (S$sectionNum)");
          score += scoreAdded;
        }
      } else {
        print("Didn't find $i");
      }
    }
    lastIndex = num * tableWidth;
  }

  print("");
  return score;
}

void setTruthTable(String uid) {
  Map<String, bool> returnVal = {};
  for (int i = 0; i < correctAnswers.length; i++) {
    try {
      // print(
      //     "Controller at ${i + 1} => ${double.parse(controllers[i].text) == correctAnswers[i]}");
      if (double.parse(controllers[i].text) == correctAnswers[i] ||
          userAnswerMap[(i + 1).toString()] == true) {
        returnVal[(i + 1).toString()] = true;
      } else {
        returnVal[(i + 1).toString()] = false;
      }
    } catch (e) {
      returnVal[(i + 1).toString()] = userAnswerMap[(i + 1).toString()];
    }
  }
  truthTable = answerMapToBoolList(returnVal);
  print(userAnswerMap);
  Firestore.instance.collection("userData").document(uid).updateData({
    "round3Answers": returnVal,
    "score": calculateScore(
      tableHeights,
      tableWidth,
      returnVal,
    )
  });
}

List<bool> answerMapToBoolList(Map input) {
  List<bool> list = [];
  int totalTableHeight = 0;
  tableHeights.forEach((element) {
    totalTableHeight += int.parse(element.toString());
  });
  print("tableWidth: $tableWidth");
  int numCells = totalTableHeight * tableWidth;

  for (int i = 0; i < numCells; i++) {
    list.add(input[(i + 1).toString()]);
  }
  return list;
}

int tableWidth;
List<int> tableHeights = [];

class _RoundThreeState extends State<RoundThree> {
  DatabaseServices databaseServices;
  Map roundThreeData;

  double boxSize;

  void getRoundThreeData() async {
    roundThreeData = await databaseServices.getRoundThreeData();

    tableWidth = roundThreeData["tableWidth"];
    for (dynamic value in roundThreeData["tableHeights"]) {
      print(value);
      tableHeights.add(int.parse(value.toString()));
    }
    tableHeights.reversed.toList();

    setEmptyValues();

    setState(() {});
  }

  void setEmptyValues() {
    int totalTableHeight = 0;
    tableHeights.forEach((element) {
      totalTableHeight += int.parse(element.toString());
    });
    print("tableWidth: $tableWidth");
    int numCells = totalTableHeight * tableWidth;
    for (int i = 1; i <= numCells; i++) {
      // emptyMap[i.toString()] = false;
      controllers.add(TextEditingController());
      // truthTable.add(false);
      correctAnswers.add(17.000);
    }
  }

  List<Widget> buildTables() {
    int rowIndex = 0;
    List<Widget> returnVal = [];
    for (int heightIndex = 0;
        heightIndex < tableHeights.length;
        heightIndex++) {
      print(heightIndex * 0.2);
      List<Widget> columnList = [];
      for (int i = 0; i < tableHeights[heightIndex]; i++) {
        List<Widget> rowList = [];
        for (int j = 0; j < tableWidth; j++) {
          rowList.add(
            Box(
              data: "${rowIndex * tableWidth + j + 1}",
              overlayMultiplier: 0.2 * heightIndex + 0.3,
              boxSize: boxSize,
              correct: truthTable[rowIndex * tableWidth + j],
              uid: widget.uid,
            ),
          );
        }
        columnList.add(
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: rowList,
            ),
          ),
        );
        rowIndex++;
      }
      returnVal.add(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: columnList.reversed.toList(),
          ),
        ),
      );
      returnVal.add(
        SizedBox(
          height: 12,
        ),
      );
    }
    returnVal.removeLast();
    returnVal = returnVal.reversed.toList();

    return returnVal;
  }

  @override
  void initState() {
    databaseServices = new DatabaseServices();
    getRoundThreeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double totalSize = 0.8 * size.width;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('userData')
          .document(widget.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        if (roundThreeData != null && userSnapshot.hasData) {
          double singleUnit = totalSize / ((15 * tableWidth) - 1);
          boxSize = singleUnit * 14;

          userAnswerMap = userSnapshot.data.data["round3Answers"];
          truthTable = answerMapToBoolList(userAnswerMap);

          return Scaffold(
            body: BackgroundImage(
                child: SafeArea(
              child: Center(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Capture the Territory',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...buildTables(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        } else {
          return BackgroundImage(
            child: Spinner(),
          );
        }
      },
    );
  }
}

class Box extends StatelessWidget {
  double boxSize;
  String data;
  double overlayMultiplier;
  bool correct;
  String uid;

  Box({
    @required this.data,
    @required this.overlayMultiplier,
    @required this.boxSize,
    @required this.correct,
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        /* showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // insetPadding:
              //     EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
              content: Container(),
            );
          },
        ); */
        await showDialog(
          // backgroundColor: accentColor,
          // context: context,
          builder: (context) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: AnswerSheet(
                index: this.data,
                uid: this.uid,
              ),
            );
          },
          context: context,
        );
      },
      child: Padding(
        padding: EdgeInsets.all(boxSize / 14),
        child: Stack(
          children: [
            if (correct)
              Opacity(
                opacity: 1.0,
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  color: Color(0xff16b525),
                  // decoration: BoxDecoration(
                  // ),
                ),
              ),
            if (!correct)
              Opacity(
                opacity: overlayMultiplier,
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  color: Colors.black,
                  // decoration: BoxDecoration(
                  // ),
                ),
              ),
            Container(
              width: boxSize,
              height: boxSize,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: accentColor,
              //     width: 1.5,
              //   ),
              // ),
              child: Center(
                child: Text(
                  data,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerSheet extends StatefulWidget {
  String index;
  String uid;
  AnswerSheet({
    @required this.index,
    @required this.uid,
  });
  @override
  _AnswerSheetState createState() => _AnswerSheetState();
}

class _AnswerSheetState extends State<AnswerSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            padding: EdgeInsets.zero,
            child: Image.network(
              // 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_128dp.png',
              // "https://i.ibb.co/4pQwv5k/image.png",
              questions[widget.index],
              fit: BoxFit.fitWidth,
            ),
          ),
          Spacer(),
          Padding(
            // padding: EdgeInsets.symmetric(
            //   horizontal: 24,
            //   vertical: 16,
            // ),
            padding: EdgeInsets.zero,
            child: EmptyTextField(
              'Answer',
              controllers[int.parse(widget.index) - 1],
              // suffix: IconButton(
              //   icon: Icon(Icons.check),
              //   onPressed: () {},
              // ),
              keyboardType: TextInputType.number,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2000),
                borderSide: BorderSide(
                  // color: fieldColors[j],
                  color: controllers[int.parse(widget.index) - 1].text == ""
                      ? mainColor
                      : truthTable[int.parse(widget.index) - 1]
                          ? Colors.green
                          : Colors.red,
                  width: 1.5,
                  // width: 3,
                ),
              ),
              // color: fieldColors[j],
              color: controllers[int.parse(widget.index) - 1].text == ""
                  ? mainColor
                  : truthTable[int.parse(widget.index) - 1]
                      ? Colors.green
                      : Colors.red,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyButton(
                () {
                  setTruthTable(
                    widget.uid,
                  );
                  super.setState(() {});
                },
                "Check",
                inverse: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
