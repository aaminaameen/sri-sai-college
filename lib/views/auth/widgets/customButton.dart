import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  final Function() ontap;
  const CustomButton({
    Key? key,
    this.borderColor = kPrimaryColor,
    this.buttonColor = kPrimaryColor,
    this.textColor = kWhiteText,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          width: 230,
          height: 50,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: borderColor, width: 2
            ),
            boxShadow:[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), //color of shadow
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
           ),

          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
