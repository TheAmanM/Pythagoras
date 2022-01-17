// import 'package:bvsso/auth.dart';
// import 'package:bvsso/youtube_video.dart';
import 'package:bvsso/auth.dart';
import 'package:bvsso/myapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bvsso/constants.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:bvsso/database.dart';
// import 'package:video_player/video_player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // brightness: Brightness.dark,
          // primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: mainColor,
          primaryColor: mainColor,
          accentColor: accentColor,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // inputDecorationTheme: InputDecorationTheme(
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(
          //       360,
          //     ),
          //     borderSide: BorderSide(
          //       color: Colors.white,
          //       width: 30,
          //     ),
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(
          //       360,
          //     ),
          //     borderSide: BorderSide(
          //       color: Colors.white,
          //       width: 30,
          //     ),
          //   ),
          //   focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(
          //       12,
          //     ),
          //     borderSide: BorderSide(
          //       color: Colors.white,
          //       width: 30,
          //     ),
          //   ),
          // ),
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: accentColor,
              fontSize: 18,
            ),
          ),
        ),
        title: "Pythagoras' Pantheon",
        home: StreamProvider<FirebaseUser>.value(
          child: Wrapper(),
          value: AuthServices().user,
        ),
      ),
    ),
  );
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return Scaffold(body: Authenticate());
    } else {
      print('sending uid: ${user.uid}');
      return Scaffold(
        body: ModeratorWrapper(user: user),
      );
    }
  }
}

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  String userNameError;
  String passwordError;

  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();

    userNameError = null;
    passwordError = null;
  }

  void resetErrorMessages() {
    setState(() {
      // userNameError = null;
      // passwordError = null;
      validateUserName();
      validatePassword();
    });
  }

  bool validateUserName() {
    usernameEditingController.text = usernameEditingController.text.trim();
    //TODO: Complete validation of username through team code

    if (usernameEditingController.text.toString() == "") {
      setState(() {
        userNameError = "Please enter a valid username. ";
      });
      return false;
    }

    setState(() {
      userNameError = null;
    });
    return true;
  }

  bool validatePassword() {
    passwordEditingController.text = passwordEditingController.text.trim();
    if (passwordEditingController.text.length < 8) {
      setState(() {
        passwordError = "Your password should be longer than 8 characters. ";
      });
      return false;
    }
    setState(() {
      passwordError = null;
    });
    return true;
  }

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
          fillColor: Colors.white.withOpacity(0.15),
          // filled: true,
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

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 1.4,
            child: Image(
              image: AssetImage(
                'assets/images/icon3.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      customTextField(
        'Username',
        usernameEditingController,
        userNameError,
        Icons.person,
        TextInputType.text,
        false,
      ),
      customTextField(
        'Password',
        passwordEditingController,
        passwordError,
        Icons.lock,
        TextInputType.text,
        true,
      ),
      // TextField(
      //   decoration: InputDecoration(
      //     border: OutlineInputBorder(
      //       borderSide: BorderSide(
      //         color: Colors.white,
      //       ),
      //       borderRadius: BorderRadius.circular(200),
      //     ),
      //   ),
      // ),
      Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          24,
        ),
        child:
            /* Container(
          // width: MediaQuery.of(context).size.width,
          height: 48,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(
              2000,
            ),
          ),
          child: Center(
            child: ButtonText(
              'Login',
            ),
          ),
        ), */
            Opacity(
          opacity: isButtonEnabled ? 1.0 : 0.5,
          child: FlatButton(
            color: accentColor,
            height: 52,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                1000,
              ),
            ),
            onPressed: () async {
              if (isButtonEnabled) {
                if (validateUserName() & validatePassword()) {
                  setState(() {
                    isButtonEnabled = false;
                  });
                  List result = await AuthServices().signIn(
                    usernameEditingController.text,
                    passwordEditingController.text,
                  );
                  setState(() {
                    isButtonEnabled = true;
                  });
                  if (result[1] != null) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result[1].toString(),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonText('Login', bold: true),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
