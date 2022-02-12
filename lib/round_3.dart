import 'package:bvsso/database.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class RoundThree extends StatefulWidget {
  @override
  _RoundThreeState createState() => _RoundThreeState();
}

class _RoundThreeState extends State<RoundThree> {
  DatabaseServices databaseServices;
  Map roundThreeData;

  int tableWidth;
  List<int> tableHeights = [];
  double boxSize;

  void getRoundThreeData() async {
    roundThreeData = await databaseServices.getRoundThreeData();

    tableWidth = roundThreeData["tableWidth"];
    for (dynamic value in roundThreeData["tableHeights"]) {
      print(value);
      tableHeights.add(int.parse(value.toString()));
    }
    tableHeights.reversed.toList();
    setState(() {});
  }

  List<Widget> buildTables() {
    int rowIndex = 0;
    List<Widget> returnVal = [];
    for (int heightIndex = 0;
        heightIndex < tableHeights.length;
        heightIndex++) {
      print(heightIndex * 0.2);
      List<Widget> columnList = [];
      for (int i = 0; i < tableHeights[heightIndex]; i++) {
        List<Widget> rowList = [];
        for (int j = 0; j < tableWidth; j++) {
          rowList.add(
            Box(
              data: "${rowIndex * tableWidth + j + 1}",
              overlayMultiplier: 0.2 * heightIndex + 0.3,
              boxSize: boxSize,
            ),
          );
        }
        columnList.add(
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: rowList,
            ),
          ),
        );
        rowIndex++;
      }
      returnVal.add(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: columnList.reversed.toList(),
          ),
        ),
      );
      returnVal.add(
        SizedBox(
          height: 12,
        ),
      );
    }
    returnVal.removeLast();
    returnVal = returnVal.reversed.toList();

    return returnVal;
    // return tableHeights.map<Widget>((int tableHeight) {
    //   List<Widget> columnList = [];
    //   for (int i = 0; i < tableHeight; i++) {
    //     List<Widget> rowList = [];
    //     for (int j = 0; j < tableWidth; j++) {
    //       rowList.add(Box(
    //         data: "${i + 1}-${j + 1}",
    //       ));
    //     }
    //     columnList.add(Center(
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: rowList,
    //       ),
    //     ));
    //   }
    //   return Center(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: columnList,
    //     ),
    //   );
    // }).toList();
  }

  @override
  void initState() {
    databaseServices = new DatabaseServices();
    getRoundThreeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double totalSize = 0.8 * size.width;
    if (roundThreeData != null) {
      double singleUnit = totalSize / (15.0 * tableWidth - 1);
      boxSize = singleUnit * 14;
    }

    if (roundThreeData != null) {
      return Scaffold(
        body: BackgroundImage(
            child: SafeArea(
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Capture the Territory',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...buildTables(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      );
    } else {
      return BackgroundImage(
        child: Spinner(),
      );
    }
  }
}

class Box extends StatelessWidget {
  double boxSize;
  String data;
  double overlayMultiplier;

  Box({
    @required this.data,
    @required this.overlayMultiplier,
    @required this.boxSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /* showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // insetPadding:
              //     EdgeInsets.symmetric(horizontal: 40.0, vertical: 48.0),
              content: Container(),
            );
          },
        ); */
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container();
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.all(boxSize / 14),
        child: Stack(
          children: [
            Opacity(
              opacity: overlayMultiplier,
              child: Container(
                width: boxSize,
                height: boxSize,
                color: Colors.black,
                // decoration: BoxDecoration(
                // ),
              ),
            ),
            Container(
              width: boxSize,
              height: boxSize,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     color: accentColor,
              //     width: 1.5,
              //   ),
              // ),
              child: Center(
                child: Text(
                  data,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
