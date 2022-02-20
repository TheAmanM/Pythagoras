import 'package:bvsso/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class Moderator extends StatefulWidget {
  String uid;
  int currentRound;
  Moderator({
    @required this.uid,
    @required this.currentRound,
  });
  @override
  _ModeratorState createState() => _ModeratorState();
}

class _ModeratorState extends State<Moderator> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> stream;
    if (widget.currentRound == 1) {
      stream = Firestore.instance
          .collection('userData')
          .orderBy('currentLevel', descending: true)
          .getDocuments()
          .asStream();
    } else {
      stream = null;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor.withOpacity(1),
        title: Text(
          'Round ${widget.currentRound}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: customIcon(
              Icons.exit_to_app,
              true,
            ),
            onPressed: () async {
              await AuthServices().signOut();
            },
          ),
        ],
      ),
      body: BackgroundImage(
        child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return Center(
                child: Spinner(),
              );
            } else {
              List<DocumentSnapshot> documents = streamSnapshot.data.documents
                ..removeWhere((DocumentSnapshot element) {
                  if (widget.uid == element.documentID) {
                    return true;
                  } else {
                    return false;
                  }
                });

              return Container(
                child: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    children: documents.map((DocumentSnapshot doc) {
                      ListTile tile;
                      if (widget.currentRound == 1) {
                        tile = ListTile(
                          title: Text(
                            doc.data["name"],
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: accentColor,
                            child: Text(
                              doc.data["currentLevel"] == 4
                                  ? "H"
                                  : doc.data["currentLevel"].toString(),
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        tile = ListTile();
                      }
                      return tile;
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
