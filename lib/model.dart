import 'package:flutter/material.dart';

// Need to create floors and rooms
// Map<String, ?> for every floor
// keys will be floor numbers, values will be rooms in that floor
// values of floors map will be maps representing the rooms for that floor
// custom classes?

String returnText = "Back";

// [null, null, null, null] For copy-pasting

/* Map<String, dynamic> floors = {
  "": Floor(room1: "1", room2: "2", room3: null, room4: "4"),
  "1": Floor(room1: null, room2: "12", room3: returnText, room4: null),
  "2": Floor(room1: null, room2: null, room3: null, room4: null),
  "4": Floor(room1: null, room2: null, room3: "43", room4: null),
  "12": Floor(room1: null, room2: null, room3: null, room4: null),
  "43": Floor(room1: null, room2: null, room3: null, room4: null),
}; */
/* final Map<String, Floor> floors = {
  "": Floor(
    rooms: ["1", "2", null, "4"],
  ),
  "1": Floor(
    rooms: [null, "12", returnText, null],
  ),
  "2": Floor(
    rooms: [null, null, null, null],
  ),
  "4": Floor(
    rooms: [null, null, "43", null],
  ),
  "12": Floor(
    rooms: [null, null, null, returnText],
  ),
  "43": Floor(
    rooms: [returnText, null, null, null],
  ),
}; */

class Floor {
  // String room1;
  // String room2;
  // String room3;
  // String room4;
  List<String> rooms;

  Floor({
    /* @required this.room1,
    @required this.room2,
    @required this.room3,
    @required this.room4, */

    @required rooms,
  });
}

/*
class Room {
  int id;
  Floor leadingRooms;

  Room({this.id, this.leadingRooms});
} */

/* class UserState {
  String _state = "";

  String get() => _state;

  void push(input) => _state + input;

  void pop() {
    _state = _state.substring(0, _state.length - 1);
  }
} */
