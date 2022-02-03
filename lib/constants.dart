import 'package:bvsso/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Color mainColor = Color(0xFF003049);
// Color accentColor = Color(0xFFFABE4C);

// Color mainColor = Color(0xFFf49d3b);
Color mainColor = Color(0xFFe9912d);
Color accentColor = Colors.white;
Color annoyingRedColor = Colors.red[800];

Widget ButtonText(String text, {bool bold, bool inverse = false}) {
  if (bold == true) {
    return Text(
      text,
      style: TextStyle(
        color: inverse ? accentColor : mainColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  } else {
    return Text(
      text,
      style: TextStyle(
        color: inverse ? accentColor : mainColor,
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

Widget EmptyButton(Function onTap, String text, {bool inverse = false}) {
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
        color: inverse ? mainColor : accentColor,
        borderRadius: BorderRadius.circular(
          20000,
        ),
      ),
      child: ButtonText(text.toString(), inverse: inverse),
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

Widget customTextField(
  String fieldName,
  TextEditingController textEditingController,
  String errorText,
  IconData iconData,
  TextInputType inputType,
  bool isPassword,
) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 1.5,
    ),
    borderRadius: BorderRadius.circular(
      2000,
    ),
  );
  OutlineInputBorder errorBorder = outlineInputBorder.copyWith(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
  );
  return Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      0,
      16,
      12,
    ),
    child: TextField(
      style: TextStyle(
        // fontSize: 14,
        color: accentColor,
      ),
      // onChanged: (String input) {
      //   resetErrorMessages();
      // },
      // cursorColor: mainColor,
      cursorColor: accentColor,
      obscureText: isPassword,
      controller: textEditingController,
      decoration: InputDecoration(
        isDense: true,
        // fillColor: Colors.white.withOpacity(0.15),
        fillColor: mainColor.withOpacity(0.6),
        filled: true,
        errorText: errorText,
        labelText: fieldName,
        labelStyle: TextStyle(
          // color: mainColor,
          color: accentColor.withOpacity(0.6),
        ),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: errorBorder,
        prefixIcon: customIcon(
          iconData,
          // color: accentColor,
          // false,
          true,
        ),
      ),
      keyboardType: inputType,
    ),
  );
}

Widget EmptyTextField(String label, TextEditingController controller,
    {TextInputType keyboardType = TextInputType.number}) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: mainColor,
      width: 1.5,
    ),
    borderRadius: BorderRadius.circular(
      2000,
    ),
  );
  return Padding(
    padding: EdgeInsets.fromLTRB(
      0,
      0,
      0,
      12,
    ),
    child: TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: mainColor.withOpacity(0.6)),
        // isDense: true,
        border: outlineInputBorder,
        contentPadding: EdgeInsets.fromLTRB(24, 8, 12, 8),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
      ),
    ),
  );
}
