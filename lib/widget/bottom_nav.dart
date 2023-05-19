import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pointofsales/screen/home_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index_color = 0;
  List Screen = [
    HomeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 0;
                });
              },
              child: FaIcon(
                FontAwesomeIcons.houseChimney,
                size: 25,
                color: index_color == 0 ? kSecondaryColor : Colors.blueGrey,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 1;
                });
              },
              child: FaIcon(
                FontAwesomeIcons.fileInvoiceDollar,
                size: 25,
                color: index_color == 1 ? kSecondaryColor : Colors.blueGrey,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 2;
                });
              },
              child: FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                size: 25,
                color: index_color == 2 ? kSecondaryColor : Colors.blueGrey,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 3;
                });
              },
              child: FaIcon(
                FontAwesomeIcons.clipboardList,
                size: 25,
                color: index_color == 3 ? kSecondaryColor : Colors.blueGrey,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 4;
                });
              },
              child: FaIcon(
                FontAwesomeIcons.gear,
                size: 25,
                color: index_color == 4 ? kSecondaryColor : Colors.blueGrey,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
