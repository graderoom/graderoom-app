import 'package:bot_toast/bot_toast.dart';

load({load = true}) {
  if (!load) return;
  BotToast.showLoading();
}

loadStop({load = true}) {
  if (!load) return;
  BotToast.closeAllLoading();
}