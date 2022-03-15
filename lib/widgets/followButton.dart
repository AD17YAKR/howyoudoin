import 'package:flutter/material.dart';

class FollowButtonPlaceHolder extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;
  FollowButtonPlaceHolder(
      {Key? key,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.textColor,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: function,
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.grey.shade700,
            minimumSize: Size(
              MediaQuery.of(context).size.width / 3,
              40,
            ),
          ),
        ),
      ],
    );
  }
}
