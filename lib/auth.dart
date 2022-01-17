import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthServices {
  final FirebaseAuth _instance = FirebaseAuth.instance;

  // createUser(String email, String password) async {
  //   AuthResult result = await _instance.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   return result;
  // }

  Stream<FirebaseUser> get user {
    return _instance.onAuthStateChanged;
  }

  Future<List> signIn(String username, String password) async {
    try {
      String email = "$username@bvsso.com";
      AuthResult result = await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return [result.user, null];
    } catch (e) {
      PlatformException error = e;
      print(e.toString());
      String message;
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          {
            message = "Invalid username; such a user does not exist. ";
            break;
          }

        case "ERROR_WRONG_PASSWORD":
          {
            message =
                "Error: Invalid password. Please double-check your password or copy-paste it into the text field. ";
            break;
          }
        default:
          {
            message = error.message;
          }
      }
      return [
        null,
        message,
      ];
    }
  }

  Future<void> signOut() async {
    await _instance.signOut();
  }
}
