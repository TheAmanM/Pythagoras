import 'package:bvsso/constants.dart';
import 'package:bvsso/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class Helipad extends StatefulWidget {
  String userID;
  Map settingsData;

  Helipad({
    @required this.userID,
    @required this.settingsData,
  });

  @override
  _HelipadState createState() => _HelipadState();
}

class _HelipadState extends State<Helipad> {
  bool enableButton = false;
  Map settingsData;
  DateTime endTime;
  bool outOfTime = false;

  CountdownTimerController controller;

  @override
  void initState() {
    settingsData = widget.settingsData;
    // controller = CountdownTimerController();
    super.initState();
  }

  void setEndTime(Map data) {
    // DatabaseServices().updateUserData(widget.userID, "beganHelipad", true);
    if (data.containsKey("endTime")) {
      endTime = DateTime.parse(data["endTime"].toDate().toString());
      // endTime = data["endTime"];
      print("Date comparison: ${DateTime.now().compareTo(endTime)}");
    } else {
      // endTime = DateTime.now().add(
      //   Duration(
      //     minutes: 10,
      //   ),
      // );
      endTime = DateTime.now().add(
        Duration(
          // minutes: 5,
          seconds: settingsData["helipadTime"],
        ),
      );
      // controller.endTime = endTime.millisecondsSinceEpoch;
      // Map<dynamic, dynamic> data = {
      //   "endTime": endTime,
      // };
      DatabaseServices().updateUserData(
        widget.userID,
        // data,
        "endTime", endTime,
      );
    }
  }

  void onEnd() {
    if (!controller.isRunning) {
      print("ENDEDDDDDD");
      // if (!enableButton &&
      //     DateTime.now().compareTo(endTime) !=
      //         1) {
      // try {
      //   FocusScopeNode currentFocus =
      //       FocusScope.of(context);
      //   currentFocus.unfocus();
      // } catch (e) {}
      super.setState(() {
        outOfTime = true;
      });
      print("Time over");
    }
  }

  String formatTimeValue(int value) {
    if (value.toString().length == 1) {
      return "0$value";
    }
    return value.toString();
  }

  Widget FinishButton(Function onTap, String text) {
    double buttonHeight = 10;
    double buttonWidth = 40;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: buttonWidth,
          vertical: buttonHeight,
        ),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(
              20000,
            ),
            border: Border.all(color: Colors.green, width: 2)),
        child: ButtonText(text.toString(), inverse: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: FutureBuilder(
            future: DatabaseServices().getUserData(widget.userID),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data.data);
                setEndTime(snapshot.data.data);
                controller = new CountdownTimerController(
                  endTime: endTime.millisecondsSinceEpoch,
                );
                // if (controller.currentRemainingTime.sec == 0 &&
                //     controller.currentRemainingTime.min == 0 &&
                //     outOfTime == false) {
                //   print("outOfTime is now true");
                //   setState(() {
                //     outOfTime = true;
                //   });
                // }
                // if (enableButton) {
                //   controller.disposeTimer();
                // }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Helipad!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        // "Fantastic! You've finished Round 1, great job!\n\nBy the time you're reading this, we've already been notified that you've completed the round, but we recommend you return to Discord and let us know in your team chat. \n\nOf course, keep an eye out in the announcements channel for further updates. We wish you luck in proceeding to Round 2!",
                        // "Helipad story goes here",
                        settingsData["text"].toString().split("\\n").join("\n"),
                      ),
                      // Spacer(),
                      SizedBox(height: 24),
                      Divider(
                        color: accentColor.withOpacity(0.8),
                        indent: 0.2,
                        endIndent: 0.2,
                      ),
                      SizedBox(height: 24),
                      DateTime.now().compareTo(endTime) != -1
                          ? Container()
                          :
                          // Flexible(
                          //     child:
                          outOfTime
                              ? Container()
                              :
                              // AbsorbPointer(
                              //     absorbing: outOfTime,
                              //     child:
                              Center(
                                  child: OTPTextField(
                                      // controller: otpController,
                                      length: 5,
                                      width: MediaQuery.of(context).size.width,
                                      textFieldAlignment:
                                          MainAxisAlignment.spaceAround,
                                      fieldWidth: 55,
                                      fieldStyle: FieldStyle.rounded,
                                      // outlineBorderRadius: 15,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: accentColor,
                                      ),
                                      inputDecoration: InputDecoration(
                                        counterText: "",
                                        // counter: Container(),
                                        // border: OutlineInputBorder(
                                        //   borderSide: BorderSide(
                                        //     color: Colors.white,
                                        //     width: 15,
                                        //   ),
                                        //   borderRadius: BorderRadius.circular(
                                        //     20,
                                        //   ),
                                        // ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      onChanged: (pin) {
                                        // onEnd();
                                        print("Changed: " + pin);
                                        if (enableButton ||
                                            snapshot.data.data
                                                .containsKey("remainingTime")) {
                                          setState(() {
                                            outOfTime = true;
                                          });
                                        }
                                      },
                                      onCompleted: (pin) {
                                        if (pin == settingsData["answer"] &&
                                            !outOfTime)
                                          setState(() {
                                            {
                                              enableButton = true;
                                              DatabaseServices().updateUserData(
                                                  widget.userID,
                                                  "remainingTime", {
                                                "m": formatTimeValue(controller
                                                    .currentRemainingTime.min),
                                                "s": formatTimeValue(controller
                                                    .currentRemainingTime.sec),
                                              });
                                              controller.disposeTimer();
                                            }
                                          });
                                        print("Completed: " + pin);
                                      }),
                                  // ),
                                  // ),
                                  // ),
                                ),
                      Spacer(),
                      !(enableButton ||
                              snapshot.data.data.containsKey("remainingTime"))
                          ? Container(
                              child: snapshot.data.data
                                      .containsKey('remainingTime')
                                  ? Text(
                                      '00 : ${snapshot.data.data["remainingTime"]["m"]} : ${snapshot.data.data["remainingTime"]["s"]}',
                                      style: TextStyle(
                                        fontSize: 29,
                                      ),
                                    )
                                  : CountdownTimer(
                                      controller: controller,
                                      // endTime: endTime.millisecondsSinceEpoch,
                                      endWidget: Text(
                                        '00 : 00 : 00',
                                        style: TextStyle(
                                          fontSize: 29,
                                        ),
                                      ),
                                      onEnd: onEnd,
                                      // },
                                      // textStyle: Theme.of(context).textTheme.bodyText2,
                                      textStyle: TextStyle(
                                        fontSize: 29,
                                      ),
                                    ),
                            )
                          : EmptyButton(
                              enableButton ||
                                      snapshot.data.data
                                          .containsKey("remainingTime")
                                  ? () async {
                                      await DatabaseServices().updateUserData(
                                          widget.userID, "helipadDone", true);
                                      Navigator.pop(context);
                                    }
                                  : null,
                              "Finish",
                            ),
                      /* CountdownTimer(
                        controller: controller,
                        // endTime: endTime.millisecondsSinceEpoch,
                        endWidget: Text(
                          '00 : 00 : 00',
                          style: TextStyle(
                            fontSize: 29,
                          ),
                        ),
                        // onEnd: onEnd,
                        // },
                        // textStyle: Theme.of(context).textTheme.bodyText2,
                        textStyle: TextStyle(
                          fontSize: 29,
                        ),
                      ), */
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                );
              } else {
                return Spinner();
              }
            },
          ),
        ),
      ),
      // ),
      // ),
    );
  }
}
