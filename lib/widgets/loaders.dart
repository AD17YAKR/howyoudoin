import 'package:flutter/material.dart';
import 'package:howyoudoin/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget ButtonLoader(double size) {
  return LoadingAnimationWidget.threeArchedCircle(
    color: Colors.white,
    size: size,
  );
}

Widget ScreenLoader() {
  return LoadingAnimationWidget.threeArchedCircle(
    color: neon,
    size: 40,
  );
}
