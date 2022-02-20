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
    result.add(doc["round1Helipad"]);
    return result;
  }

  Map fixLocations(Map<dynamic, dynamic> data) {
    for (String key in data.keys) {
      data[key][""] = data[key]["Lobby"];
    }
    return data;
  }

  Future<List<Map>> getRound1Data() async {
    DocumentSnapshot settings =
        await firestore.collection('settings').document('settings').get();

    return [settings["round1Data"], settings["round1Helipad"]];
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

  Future<List<String>> getLatestVersionData() async {
    DocumentSnapshot data =
        await firestore.collection('settings').document('settings').get();
    // print(data.data);
    // print(data.data['latestVersion']);
    return [data.data['latestVersion'], data.data['latestVersionLink']];
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

  Future<void> updateUserData(String uid, String key, dynamic value) async {
    await firestore
        .collection('userData')
        .document(uid)
        .updateData({"$key": value});
  }

  Future<int> getRoundInfo() async {
    DocumentSnapshot data =
        await firestore.collection('settings').document('settings').get();
    return data.data["currentRound"];
  }

  Future<DocumentSnapshot> getUserData(String userID) async {
    print(userID);
    DocumentSnapshot doc =
        await firestore.collection('userData').document(userID).get();
    print(doc.data);
    return doc;
  }

  // Round 3 Stuff

  Future<Map> getRoundThreeData() async {
    DocumentSnapshot value =
        await firestore.collection('settings').document('settings').get();

    return value.data["round3Data"];
  }
}
