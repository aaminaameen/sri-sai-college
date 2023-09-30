import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sri_sai_col/constants.dart';

import 'loginScreen.dart';

enum DialogsAction { yes, cancel}
final FirebaseAuth auth = FirebaseAuth.instance;



class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext  context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            title: Text(title,),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(DialogsAction.yes);
                  },
                  child: Text(
                    'confirm',
                    style: Theme.of(context).textTheme.caption?.copyWith(color: kSecondaryColor)
                  )),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(DialogsAction.cancel);
                  },
                  child: Text(
                    'cancel',
                    style: Theme.of(context).textTheme.caption?.copyWith(color: kSecondaryColor)
                  ))
            ],
          );
        });
    return (action != null) ? action : DialogsAction.cancel;
  }
}