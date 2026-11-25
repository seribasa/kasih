import 'package:flutter/material.dart';
export 'package:snack/snack.dart';

SnackBar snackbarCustom(String? text) => SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Text(text.toString(), style: TextStyle(fontFamily: 'Nunito')),
      backgroundColor: Colors.black,
    );
