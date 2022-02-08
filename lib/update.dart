import 'package:bvsso/constants.dart';
import 'package:flutter/material.dart';

class Update extends StatelessWidget {
  String currentVersion;
  String latestVersion;
  String latestVersionLink;

  Update({
    @required this.currentVersion,
    @required this.latestVersion,
    @required this.latestVersionLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 24,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Update Required!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Unfortunately, you're on an outdated version of the app. This version of the Pythagoras' Pantheon app is version $currentVersion, while all participants are on $latestVersion. \n\nNot to worry! Click on the button below and you should be good to go!",
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyButton(
                      () {
                        // Navigator.pop(context);
                        print(latestVersionLink);
                      },
                      "Update app",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
