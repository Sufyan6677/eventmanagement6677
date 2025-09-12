// ignore_for_file: deprecated_member_use

import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextButton extends StatefulWidget {
  final Color? textColor;
  final double textSize;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  bool? isIcon;
  IconData? icon;
  FontWeight? fontWeight;
  double? buttonHeight;
  double? buttonWidth;
  final VoidCallback onPressed;
  final double borderRadiusCircular;
  CustomTextButton({
    super.key,
    required this.textSize,
    this.fontWeight,
    this.isIcon = false,
   this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    this.icon,
    this.buttonHeight,
    this.buttonWidth,
    required this.borderRadiusCircular,
    required this.onPressed,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadiusCircular),
              side: BorderSide(
                color: widget.borderColor, // Border color
                width: 1, // Border width
              ),
            ),
          ),
        ),

        child: Center(
          child:
              widget.isIcon == false
                  ? GoogleText(
                    widget.text,
                    color: widget.textColor, fontSize: widget.textSize,fontWeight: widget.fontWeight
                  )
                  : Icon(widget.icon, color: widget.textColor),
        ),
      ),
    );
  }
}
