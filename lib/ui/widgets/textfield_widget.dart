import 'package:flutter/material.dart';
import 'package:nftnotes/ui/widgets/shared/globals.dart';



class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  // final Function onChanged;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.prefixIconData,
    required this.suffixIconData,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<HomeModel>(context);

    return TextField(
      // onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: Global.mediumBlue,
      style: const TextStyle(
        color: Global.mediumBlue,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Global.mediumBlue),
        focusColor: Global.mediumBlue,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Global.mediumBlue),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Global.mediumBlue,
        ),
        suffixIcon: GestureDetector(
          // onTap: () {
          //   // model.isVisible = !model.isVisible;
          // },
          // child: Icon(
          //   // suffixIconData,
          //   size: 18,
          //   color: Global.mediumBlue,
          // ),
        ),
      ),
    );
  }
}
