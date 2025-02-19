import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final double height;
  final double? width;
  final double size;
  const Loader(
      {super.key,
      this.height = 500,
      this.width = double.maxFinite,
      this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: SpinKitThreeBounce(
          color: const Color.fromARGB(255, 0, 59, 107),
          size: size,
        ),
      ),
    );
  }
}
