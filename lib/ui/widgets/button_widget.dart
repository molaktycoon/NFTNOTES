import 'package:flutter/material.dart';
import 'package:nftnotes/ui/widgets/shared/globals.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;

 const  ButtonWidget({super.key, 
    required this.title,
     required this.hasBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: hasBorder ? Global.white : Global.mediumBlue,
          borderRadius: BorderRadius.circular(10),
          border: hasBorder
              ? Border.all(
                  color: Global.mediumBlue,
                  width: 1.0,
                )
              : const Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 60.0,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: hasBorder ? Global.mediumBlue : Global.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
