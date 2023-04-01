import 'package:flutter/material.dart';
import 'package:nftnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you a password reset link, please check your mail for more information',
    optionsBuilder: () =>{
      'OK': null,
    },
  );
}
