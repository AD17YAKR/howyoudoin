import 'package:flutter/material.dart';

String authenia = "Authenia";
String lemonMilk = "LemonMilkRegular";
String brickson = "Brickson";
String sunday = "Sundaycoffee";
String library = "LibraryRecordsRegular";
String moon = "MoongladeDemoBold";

Color? green = _colorFromHex("#018219");

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
