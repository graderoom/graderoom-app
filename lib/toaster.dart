import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:intl/intl.dart';


final _timeFormat = DateFormat("HH:mm:ss");

toast(String message, {bool toast = true}) {
  if (!toast) return;
  BotToast.showText(
    text: message,
  );
}

toastDebug(String message, {int statusCode, bool toast = true}) {
  var timestamp = _timeFormat.format(DateTime.now());
  var msg = timestamp + " | " + message;
  print(msg);
  if (toast && DB.getLocal("showDebugToasts") == true) {
    var color;
    var duration;
    switch (statusCode) {
      case null:
        color = Colors.black54;
        duration = Duration(seconds: 2);
        break;
      default:
        color = statusCode >= 400 ? Colors.red : (statusCode >= 300 ? null : Colors.green );
        duration = statusCode >= 400
            ? Duration(seconds: 3)
            : (statusCode >= 300 ? Duration(seconds: 2) : Duration(seconds: 2));
        break;
    }
      BotToast.showText(
        text: msg,
        contentColor: color,
        duration: duration,
      );
  }
}

toastError(String message, {bool toast = true}) {
  if (!toast) return;
  BotToast.showText(
    text: message,
    contentColor: Colors.red,
    onlyOne: false,
  );
}
