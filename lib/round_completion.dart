import 'package:bvsso/constants.dart';
import 'package:flutter/material.dart';

class RoundCompletion extends StatelessWidget {
  int roundNumber;

  RoundCompletion({
    this.roundNumber,
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
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Fantastic! You've finished Round ${this.roundNumber}, great job!\n\nBy the time you're reading this, we've already been notified that you've completed the round, but we recommend you return to Discord and let us know in your team chat. \n\nOf course, keep an eye out in the announcements channel for further updates. We wish you the best of luck!",
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyButton(
                      () {
                        Navigator.pop(context);
                      },
                      "Return to main menu",
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
