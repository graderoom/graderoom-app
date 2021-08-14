import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graderoom_app/overlays/toaster.dart';

class SecureStorage {
  static const String _usernameKey = "GRADEROOM_USERNAME";
  static const String _passwordKey = "GRADEROOM_PASSWORD";

  static final _store = new FlutterSecureStorage();

  static Future<void> saveLoginInformation(String username, String password) async {
    await _store.write(key: _usernameKey, value: username);
    await _store.write(key: _passwordKey, value: password);
    toastDebug("Saved login information");
  }

  static Future<Map<String, String?>> getLoginInformation() async {
    var info = new Map<String, String?>();
    info["username"] = await _store.read(key: _usernameKey);
    info["password"] = await _store.read(key: _passwordKey);
    return info;
  }

  static Future<void> deleteLoginInformation() async {
    await _store.delete(key: _usernameKey);
    await _store.delete(key: _passwordKey);
    toastDebug("Deleted login information");
  }
}
