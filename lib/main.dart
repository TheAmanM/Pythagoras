import 'package:bvsso/constants.dart';
import 'model.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: mainColor),
      home: MyApp(),
    ),
  );
}

final Map<String, Floor> floors = {
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
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: InkWell(
          onTap: () {
            size = context.size;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Home();
                },
              ),
            );
          },
          child: Container(
            width: 108,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(
                2000,
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  // horizontal: 16,
                  vertical: 12,
                ),
                child: Text('Start'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Size size;
String currentPath = "1"; //TODO: Set this back to ""

Widget PositionedButton(context, String currentPath, String roomId) {
  // Widget button() {

  Offset offset;
  if (roomId == "2") {
    offset = new Offset(12, 0);
  } else if (roomId == "4") {
    offset = new Offset(-12, 0);
  } else {
    offset = new Offset(0, 0);
  }

  String buttonText = 'Room'; // TODO: Set room names with extra map like floors
  Floor currentFloor = floors["$currentPath"];
  int nextRoomIndex = int.parse(roomId) - 1;
  print(currentPath);
  print(currentFloor.rooms);
  String nextRoom = currentFloor.rooms[nextRoomIndex];
  if (nextRoom == null) {
    return Container(
      height: 0,
      width: 0,
    );
  } else if (nextRoom == returnText) {
    buttonText = 'Back';
  } else {
    return GestureDetector(
      onTap: () {
        /* Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return roomDisplay();
                },
              ),
            ); */
        if (floors["$currentPath"].rooms[int.parse(roomId)] == returnText) {
          currentPath = currentPath.substring(0, currentPath.length - 1);
          Navigator.pop(context);
        } else {
          currentPath = "$currentPath$roomId";
          print("New path: $currentPath");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return roomDisplay(context, currentPath);
              },
            ),
          );
        }
      },
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: int.parse(roomId) % 2 == 0 ? -math.pi / 2 : 0,
          child: Container(
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(
                2000,
              ),
            ),
            width: 108,
            height: 40,
            child: Center(
              child: Text(buttonText),
            ),
          ),
        ),
      ),
    );
  }
  // }

  /* if (posKey == 1)
    return Align(
      child: Positioned(
        top: 32,
        // height: 0.1,
        // left: (size.width - 108) / 2,
        // right: (size.width - 108) / 2,
        width: 108,
        child: button(),
      ),
      alignment: Alignment.topCenter,
    ); */
  /* else if (posKey == 2) {
    return Positioned(
      right: 0.1,
      top: 0.5,
      bottom: 0.5,
      child: button(),
    );
  } else if (posKey == 3) {
    return Positioned(
      // bottom: 32,
      height: 32,
      left: 0.5,
      right: 0.5,
      child: button(),
    );
  } else {
    return Positioned(
      left: 0.1,
      top: 0.5,
      bottom: 0.5,
      child: button(),
    );
  } */
  /* else {
    return Positioned(
      child: button(),
      left: 75,
      bottom: 70,
    );
  } */
}

Widget roomDisplay(context, String currentPath) {
  /* List<Widget> stackChildrenList = [];

  for (int i = 1; i <= 4; i++) {
    stackChildrenList.add(
      PositionedButton(
        i,
        // floors[userState.get()].rooms[i + 1].toString(),
        // userState.get(), // Button's text
        // userState.get() + i.toString(), // Text
        (i).toString(),
        userState.get() + i.toString(), // Path
        // "Text",
        () {},
      ),
    ); */
  return Scaffold(
    body: Padding(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: PositionedButton(context, currentPath, "1"),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: PositionedButton(context, currentPath, "2"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PositionedButton(context, currentPath, "3"),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: PositionedButton(context, currentPath, "4"),
          ),
        ],
      ),
    ),
  );
}

/* return Padding(
    padding: EdgeInsets.all(32),
    child: Stack(
      children: stackChildrenList,
      // children: [
      //   FlatButton(
      //     child: Text('TEST'),
      //     onPressed: null,
      //   )
      // ],
    ),
  ); */

GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return Scaffold(
      key: key,
      backgroundColor: mainColor,
      body: roomDisplay(context, currentPath),
      // ),
    );
  }
}

/* class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
          /* Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods. */
          roomDisplay(),
    );
  }
}
 */
