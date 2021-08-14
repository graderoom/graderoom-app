import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graderoom_app/database/db.dart';
import 'package:intl/intl.dart';

final _timeFormat = DateFormat("HH:mm:ss");

const List<Alignment> _availableAlignments = [
  Alignment(0, 0.8),
  Alignment(0, 0.7),
  Alignment(0, 0.6),
  Alignment(0, 0.5),
  Alignment(0, 0.4),
  Alignment(0, 0.3),
  Alignment(0, 0.2),
  Alignment(0, 0.1),
  Alignment(0, 0),
  Alignment(0, -0.1),
  Alignment(0, -0.2),
  Alignment(0, -0.3),
  Alignment(0, -0.4),
  Alignment(0, -0.5),
  Alignment(0, -0.6),
  Alignment(0, -0.7),
  Alignment(0, -0.8),
];

int? _currentTimestamp;
List<Alignment> _usedAlignments = [];

toast(String message, {bool toast = true}) {
  if (!toast) return;
  BotToast.showText(
    text: message,
  );
}

Alignment _getFreeAlignment(int millisecondsSinceEpoch) {
  int _timestamp = millisecondsSinceEpoch % 1000 * 1000;
  if (_currentTimestamp == null) {
    _currentTimestamp = _timestamp;
  } else if (_timestamp > _currentTimestamp!) {
    BotToast.cleanAll();
    _usedAlignments = [];
  }
  _usedAlignments.add(_availableAlignments[_usedAlignments.length]);
  return _availableAlignments[_usedAlignments.length];
}

toastDebug(String message, {int? statusCode}) {
  var dateTime = DateTime.now();
  var time = dateTime.millisecondsSinceEpoch;
  var timestamp = _timeFormat.format(dateTime);
  var msg = timestamp + " | " + message;
  print(msg);
  if (DB.getLocal("showDebugToasts") == true) {
    var color;
    var duration;
    switch (statusCode) {
      case null:
        color = Colors.black54;
        duration = Duration(seconds: 2);
        break;
      default:
        color = statusCode! >= 400 ? Colors.red : (statusCode >= 300 ? null : Colors.green);
        duration = statusCode >= 400
            ? Duration(seconds: 3)
            : (statusCode >= 300 ? Duration(seconds: 2) : Duration(seconds: 2));
        break;
    }
    try {
      var _align = _getFreeAlignment(time);
      BotToast.showText(
        text: msg,
        contentColor: color,
        duration: duration,
        align: _align,
        onlyOne: false,
        onClose: () => _usedAlignments.removeWhere((element) => element.y == _align.y),
      );
    } catch (_) {}
  }
}

toastError(String message, {bool toast = true}) {
  if (!toast) return;
  BotToast.showText(
    text: message,
    contentColor: Colors.red,
    onlyOne: true,
  );
}
