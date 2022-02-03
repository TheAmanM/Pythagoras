import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final Firestore firestore = Firestore.instance;

  Future<List<Map>> getData() async {
    DocumentSnapshot doc =
        await firestore.collection('settings').document('settings').get();
    // List<Map<String, Map<String, List<String>>>> result = [];

    // Map<String, Map<String, List<String>>>

    List<Map> result = [];
    // result[0] = doc["roomLocations"];
    result.add(fixLocations(doc["roomLocations"]));
    result.add(doc["roomNames"]);
    result.add(doc["questions"]);
    result.add(doc["answers"]);
    return result;
  }

  Map fixLocations(Map<dynamic, dynamic> data) {
    for (String key in data.keys) {
      data[key][""] = data[key]["Lobby"];
    }
    return data;
  }

  Future<Map> getRound1Data() async {
    DocumentSnapshot settings =
        await firestore.collection('settings').document('settings').get();

    return settings["round1Data"];
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
    // print(uid);

    return moderators.contains(uid);
    // return true;
  }

  Stream<DocumentSnapshot> getCurrentLevel(String userID) {
    print('given userid is $userID');
    return firestore.collection('userData').document(userID).snapshots();
  }

  Future<String> getUserName(String userID) async {
    DocumentSnapshot snapshot =
        await firestore.collection('userData').document(userID).get();
    return snapshot.data["name"];
  }

  Future<void> incrementLevel(int currentLevel, String userID) async {
    await firestore.collection('userData').document(userID).updateData({
      "currentLevel": currentLevel + 1,
    });
  }
  /* void update() {
    firestore.collection('settings').document('settings').updateData(
      <String, Map<String, Map<String, List<String>>>>{
        "roomLocations": {
          "1": {
            // "": ["0", "1", null, "3"],
            "0": [null, "01", "Back", null],
            "1": [null, null, null, "Back"],
            "3": [null, "Back", "32", null],
            "01": [null, null, null, "Back"],
            "32": ["Back", null, null, null],
          },
          "2": {
            // "": [null, "1", null, null],
            "1": [null, null, null, "Back"],
          },
          "3": {
            // "": ["0", null, null, null],
            "0": [null, "01", "Back", null],
            "01": [null, "011", null, "Back"],
            "011": [null, null, null, "Back"],
          },
        },
        // "roomNames": {
        //   "1": {
        //     "0": "TBD",
        //     "1": "TBD",
        //     "3": "TBD",
        //     "01": "TBD",
        //     "32": "TBD",
        //   },
        //   "2": {
        //     "1": "TBD",
        //   },
        //   "3": {
        //     // "": "TBD",
        //     "0": "TBD",
        //     "01": "TBD",
        //     "011": "TBD",
        //   }
        // },
        // "questions": {
        //   "1": {
        //     "01":
        //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTquTHEeNKqqejijf3vcEoZWKvrXC1WNj076ZAxXd-LfYBnwWA9hiY0Q1yqvG8f2iiBxgs&usqp=CAU",
        //     "1":
        //         "https://hips.hearstapps.com/seventeen/assets/15/26/1435095642-pemdas-problem.jpg",
        //     "32":
        //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXpstJHr9rmd0MefJvqVvdgfY1pH2tG4zr9O0FuY5Ax012qAWUnzSxylrSVbD8Vehcrtk&usqp=CAU",
        //   },
        // },
      },
    );
  } */
}
