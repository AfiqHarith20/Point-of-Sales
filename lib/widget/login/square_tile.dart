import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.white),
      //     borderRadius: BorderRadius.circular(16),
      //     color: Colors.grey[200]),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
