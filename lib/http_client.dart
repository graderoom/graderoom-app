import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HTTPClient {
  static const String baseUrl = 'https://beta.graderoom.me';

  static const String cookiePath = ".cookies";
  static const String loginPath = "/api/login";
  static const String statusPath = "/api/status";
  static const String checkUpdateBackgroundPath = "/checkUpdateBackground";
  static const String logoutPath = "/logout";

  static const String loginUrl = baseUrl + loginPath;
  static const String statusUrl = baseUrl + statusPath;
  static const String checkUpdateBackgroundUrl = baseUrl + checkUpdateBackgroundPath;
  static const String logoutUrl = baseUrl + logoutPath;

  static final Dio dio = Dio();
  static final Uri loginUri = Uri.parse(baseUrl + loginPath);

  static PersistCookieJar _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar != null) return _cookieJar;
    await _prepare();
    return _cookieJar;
  }

  static Future<Cookie> get cookie async {
    var cookies = (await cookieJar).loadForRequest(loginUri);
    if (cookies.length != 0) {
      return (await cookieJar).loadForRequest(loginUri)[0];
    }
    return null;
  }

  static _prepare() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    _cookieJar = PersistCookieJar(dir: join(appDocPath, cookiePath));
    dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<Response> getStatus() async {
    return await dio.get(
      statusUrl,
      options: Options(
        followRedirects: true,
        headers: {
          'referer': baseUrl,
        },
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
  }

  Future<Response> login(String username, String password) async {
    var body = {
      'username': username,
      'password': password,
    };

    var response = await dio.post(
      loginUrl,
      data: body,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );

    if (response.statusCode == 200) {
      var _cookie = Cookie.fromSetCookieValue(response.headers['set-cookie'][0]);
      (await cookieJar).saveFromResponse(loginUri, [_cookie]);
    }
    return response;
  }

  Future logout() async {
    await dio.get(
      logoutUrl,
      options: Options(
        followRedirects: false,
        headers: {
          'cookie': cookie,
          'referer': baseUrl,
        },
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
  }

  Stream<Response> checkUpdateBackgroundStream() async* {
    var status = "";
    if ((await getStatus()).statusCode == 401) yield null;
    await _checkUpdateBackground();
    while (!(["Sync Complete!", "Sync Failed.", "Already Synced!"]).contains(status)) {
      await Future.delayed(Duration(seconds: 1));
      var response = await _checkUpdateBackground();
      status = response.data['message'];
      yield response;
    }
  }

  Future<Response> _checkUpdateBackground() async {
    var response = await dio.get(
      checkUpdateBackgroundUrl,
      options: Options(
        followRedirects: false,
        headers: {
          'cookie': cookie,
          'referer': baseUrl,
        },
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );

    return response;
  }
}
