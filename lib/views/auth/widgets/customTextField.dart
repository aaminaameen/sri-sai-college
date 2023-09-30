import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomTextField extends StatelessWidget {
  final String heading;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final Widget? icon;
  final Widget? suficon;
  final TextInputType? keyBoard;
  final TextEditingController? controller;
  const CustomTextField({
    Key? key, required this.heading, required this.hintText, this.icon, this.controller, this.validator, this.onSaved, this.onChanged, this.suficon, this.keyBoard
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 5,),
        SizedBox(
          height: 70,
          child: TextFormField(
            controller: controller,
            validator: validator,
            onSaved: onSaved,
            onChanged: onChanged,
            keyboardType: keyBoard,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: kTextfieldColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: kPrimaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: kSecondaryColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: kSecondaryColor,
                ),
              ),
             prefixIcon: icon,
              suffixIcon: suficon,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                color: kHintText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}