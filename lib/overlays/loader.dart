import 'package:bot_toast/bot_toast.dart';

load() {
  try {
    BotToast.showLoading(
      allowClick: true,
    );
  } catch (_) {}
}

loadStop() {
  BotToast.closeAllLoading();
}
