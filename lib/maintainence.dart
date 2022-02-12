import 'package:bvsso/constants.dart';
import 'package:flutter/material.dart';

class Maintainence extends StatelessWidget {
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
                    'Maintainence Mode',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "The Pythagoras' Pantheon app is currently in maintainence mode. Please try beginning the round a few minutes later. \n\nIf you still see this issue afterward, please ping a moderator on Discord. ",
                ),
                Spacer(),
                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EmptyButton(
                      () {
                      },
                      "Retry",
                    ),
                  ],
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
