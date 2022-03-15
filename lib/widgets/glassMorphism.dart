import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:howyoudoin/utils/colors.dart';

class GlassMorphism extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final double borderRadius;
  final double verPad;
  final double horPad;
  const GlassMorphism({
    Key? key,
    required this.blur,
    required this.opacity,
    required this.child,
    required this.borderRadius,
    required this.verPad,
    required this.horPad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(opacity / 5),
                Colors.white.withOpacity(opacity / 4),
                Colors.white.withOpacity(opacity / 3),
                Colors.white.withOpacity(opacity / 2),
                Colors.white.withOpacity(opacity / 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horPad, vertical: verPad),
            child: child,
          ),
        ),
      ),
    );
  }
}
