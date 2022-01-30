import 'package:bvsso/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Color mainColor = Color(0xFF003049);
// Color accentColor = Color(0xFFFABE4C);

// Color mainColor = Color(0xFFf49d3b);
Color mainColor = Color(0xFFe9912d);
Color accentColor = Colors.white;
Color annoyingRedColor = Colors.red[800];

Widget ButtonText(String text, {bool bold}) {
  if (bold == true) {
    return Text(
      text,
      style: TextStyle(
        color: mainColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  } else {
    return Text(
      text,
      style: TextStyle(
        color: mainColor,
      ),
    );
  }
}

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

Icon customIcon(IconData iconData, bool isAccentColor) {
  return Icon(
    iconData,
    color: isAccentColor ? accentColor : mainColor,
  );
}

Widget EmptyButton(Function onTap, String text) {
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
        color: accentColor,
        borderRadius: BorderRadius.circular(
          20000,
        ),
      ),
      child: ButtonText(text.toString()),
    ),
  );
}

Widget BackgroundImage({Widget child, bool opacityGradientMode = false}) {
  return Stack(
    children: [
      lowOpacityImage(
        opacityGradientMode: opacityGradientMode,
      ),
      child,
    ],
  );
}

void CustomSnackBar(BuildContext context, {String text}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(
        seconds: 3,
      ),
    ),
  );
}

Widget lowOpacityImage({bool opacityGradientMode = false}) => Opacity(
      opacity: opacityGradientMode ? 0.45 : 0.15,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                // 'assets/images/overlay.png',
                opacityGradientMode
                    ? 'assets/images/overlayGradient.png'
                    : "assets/images/overlay.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          // child: Image.asset(
          //   'assets/images/overlayGradient2.png',
          //   // fit: BoxFit.cover,
          //   // width: double.infinity,
          //   height: double.infinity,
          // ),
        ),
      ),
    );
