import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class C {
  static snackBar(context, {required String message, Color? color}) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void toast({required String text, Color? color}) {
    Fluttertoast.showToast(msg: text, backgroundColor: color);
  }

  static String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  static earnDialog(context, {int? index, bool? isDone}) {
    Dialog dialog = Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[Text('ass')],
      ),
    );
    showDialog(
      context: context,
      builder: (context) => DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: dialog),
    );
  }
}
