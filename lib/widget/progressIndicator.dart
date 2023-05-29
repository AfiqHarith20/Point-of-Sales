import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildCircularProgressIndicator() {
  return Center(
      child: Container(
    color: Colors.transparent,
    child: Container(
      height: 72,
      width: 72,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
                height: 56,
                width: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Color(0xffEE3124),
                )),
            FaIcon(FontAwesomeIcons.salesforce),
          ],
        ),
      ),
    ),
  ));
}

Widget buildCupertinoProgressIndicator() {
  return Center(
    child: Container(
      width: 50,
      height: 50,
      color: Colors.transparent,
      child: CupertinoActivityIndicator(
        radius: 22,
      ),
    ),
  );
}
