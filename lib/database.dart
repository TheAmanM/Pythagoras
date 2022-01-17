import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final Firestore firestore = Firestore.instance;
  Future<Map<String, List<String>>> getQuestions() async {
    // return Map<String, List<String>> floors = {
    await Future.delayed(
      Duration(
        seconds: 2,
      ),
    );
    return {
      "": ["0", "1", null, "3"],
      "0": [null, "01", "Back", null],
      "1": [null, null, null, "Back"],
      "3": [null, "Back", "32", null],
      "01": [null, null, null, "Back"],
      "32": ["Back", null, null, null],
    };
  }

  Future<bool> getIsModerator(String uid) async {
    DocumentSnapshot settings =
        await firestore.collection('settings').document('settings').get();
    // print('ABCD');
    // print("Settings: $settings");

    // await Future.delayed(Duration(seconds: 2));
    List<dynamic> moderators = settings['moderators'];
    print(moderators);

    moderators.map((dynamic element) {
      return element.toString();
    });
    print(uid);

    return moderators.contains(uid);
    // return true;
  }
}
