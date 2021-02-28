import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:graderoom_app/toaster.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'loader.dart';

enum Method {
  GET,
  POST,
}

class HTTPClient {
  static const String cookiePath = ".cookies";
  static const String baseUrl = 'http://192.168.1.23:5998';
  static const String loginPath = "/api/login";
  static const String statusPath = "/api/status";
  static const String checkUpdateBackgroundPath = "/checkUpdateBackground";
  static const String logoutPath = "/api/logout";
  static const String settingsPath = "/api/settings";

  static final Map<String, dynamic> _defaultHeaders = {
    'connection': 'keep-alive',
  };
  static final Function(int) _validateStatus = (int status) => status < 500;
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    contentType: ContentType.json.toString(),
    responseType: ResponseType.json,
    connectTimeout: 5000,
    receiveTimeout: 10000,
    headers: _defaultHeaders,
    validateStatus: _validateStatus,
  );
  static final Dio dio = Dio(_baseOptions);
  static final Uri loginUri = Uri.parse(baseUrl + loginPath);

  static PersistCookieJar _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar != null) return _cookieJar;
    await _prepare();
    return _cookieJar;
  }

  static Future<Cookie> get cookie async {
    var _cookieJar = await cookieJar;
    var cookies = _cookieJar.loadForRequest(loginUri);
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

  Future<Response> _sendRequest(
    Method method,
    String url, {
    dynamic data,
    Cookie cookie,
    String referer,
    bool followRedirects = true,
    Map<String, dynamic> headers,
    Function(int) validateStatus,
    bool showToast = true,
    bool showLoading = true,
  }) async {
    toastDebug(
      "Sending " + method.toString().substring(7) + " request to " + url,
      toast: showToast,
    );

    if (headers == null) {
      headers = _defaultHeaders;
    }
    if (validateStatus == null) {
      validateStatus = _validateStatus;
    }
    if (cookie != null) {
      headers['Cookie'] = cookie;
    }
    if (referer != null) {
      headers['referer'] = referer;
    }

    var options = Options(
      headers: headers,
      validateStatus: validateStatus,
      followRedirects: followRedirects,
    );

    load(load: showLoading);
    try {
      switch (method) {
        case Method.GET:
          var response = await dio.get(
            url,
            options: options,
          );
          toastDebug(
            "Received a response of " + response.statusCode.toString() + " " + response.statusMessage,
            statusCode: response.statusCode,
            toast: showToast,
          );
          loadStop(load: showLoading);
          return response;
        case Method.POST:
          var response = await dio.post(
            url,
            data: data,
            options: options,
          );
          toastDebug(
            "Received a response of " + response.statusCode.toString() + " " + response.statusMessage,
            statusCode: response.statusCode,
            toast: showToast,
          );
          loadStop(load: showLoading);
          return response;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        toastError(
          "Could not connect to server.",
          toast: showToast,
        );
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        toastError(
          "Server failed to respond.",
          toast: showToast,
        );
      }
    } on Error {
      toastError(
        "An Unknown Error Occurred",
        toast: showToast,
      );
    }
    loadStop(load: showLoading);
    return null;
  }

  Future<Response> getStatus({showToast = true, showLoading = true}) async {
    return _sendRequest(Method.GET, statusPath, cookie: await cookie, referer: baseUrl, showToast: showToast, showLoading: showLoading);
  }

  Future<Map<String, dynamic>> getSettings() async {
    var response = await _sendRequest(Method.GET, settingsPath, cookie: await cookie, referer: baseUrl);
    if (response is Response && response.statusCode == 200) {
      return json.decode(response.data);
    }
    return null;
  }

  Future<Response> login(String username, String password) async {
    var body = {
      'username': username,
      'password': password,
    };

    var response = await _sendRequest(
      Method.POST,
      loginPath,
      data: body,
    );

    if (response?.statusCode == 200) {
      var _cookie = Cookie.fromSetCookieValue(response.headers['set-cookie'][0]);
      (await cookieJar).saveFromResponse(loginUri, [_cookie]);
    }
    return response;
  }

  Future logout() async {
    await _sendRequest(
      Method.GET,
      logoutPath,
      cookie: await cookie,
      referer: baseUrl,
    );
  }

  Stream<Response> checkUpdateBackgroundStream() async* {
    var status = "";
    load();
    while (!(["Sync Complete!", "Sync Failed.", "Already Synced!"]).contains(status)) {
      await Future.delayed(Duration(seconds: 1));
      var response = await _checkUpdateBackground(showLoading: false);
      if (response.statusCode == 401) yield null;
      status = response.data['message'];
      yield response;
    }
    loadStop();
  }

  Future<Response> _checkUpdateBackground({showLoading = true}) async {
    var response = _sendRequest(
      Method.GET,
      checkUpdateBackgroundPath,
      cookie: await cookie,
      referer: baseUrl,
      showLoading: showLoading,
    );

    return response;
  }
}
