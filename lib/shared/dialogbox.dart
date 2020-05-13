
import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class DialogBox {
        static Future <DialogAction> yesAbortDialog(
            BuildContext context,
            String title,
            String body,
            ) async {
                final action = await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:  (BuildContext context) {
                                return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                        ),
                                        title: Text(title, style: TextStyle( fontWeight: FontWeight.w700 )),
                                        content: Text(body, style: TextStyle( fontWeight: FontWeight.w600 )),
                                        actions: <Widget>[
                                                FlatButton(
                                                        onPressed: () => Navigator.of(context).pop(DialogAction.abort),
                                                        child:  const Text(
                                                                '    NO   ',
                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                        ),
                                                ),
                                                FlatButton(
                                                        onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                                                        child: const Text(
                                                                '   YES   ',
                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                        ),
                                                ),
                                        ],
                                );
                        },
                );
                return (action != null) ? action : DialogAction.abort;
        }
}