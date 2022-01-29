import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final Firestore firestore = Firestore.instance;
  Future<Map<int, Map<String, List<String>>>> getRoomLocations() async {
    // return Map<String, List<String>> floors = {
    await Future.delayed(
      Duration(seconds: 1),
    );
    return {
      1: {
        "": ["0", "1", null, "3"],
        "0": [null, "01", "Back", null],
        "1": [null, null, null, "Back"],
        "3": [null, "Back", "32", null],
        "01": [null, null, null, "Back"],
        "32": ["Back", null, null, null],
      },
      2: {
        "": [null, "1", null, null],
        "1": [null, null, null, "Back"],
      },
      3: {
        "": ["0", null, null, null],
        "0": [null, "01", "Back", null],
        "01": [null, "011", null, "Back"],
        "011": [null, null, null, "Back"],
      }
    };
  }

  Future<Map<int, Map<String, String>>> getRoomNames() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    return {
      1: {
        "0": "TBD",
        "1": "TBD",
        "3": "TBD",
        "01": "TBD",
        "32": "TBD",
      },
      2: {
        "1": "TBD",
      },
      3: {
        "": "TBD",
        "0": "TBD",
        "01": "TBD",
        "011": "TBD",
      }
    };
  }

  Future<Map<int, Map<String, String>>> getQuestions() async {
    await Future.delayed(
      Duration(
        seconds: 1,
      ),
    );
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
