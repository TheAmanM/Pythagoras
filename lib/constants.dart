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
