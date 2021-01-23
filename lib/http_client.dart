import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:graderoom_app/constants.dart';

class HTTPClient {
  static const cookiePath = '.cookies';

  static const loginPath = "/api/login";
  static const checkUpdateBackgroundPath = "/checkUpdateBackground";
  static const logoutPath = "/logout";

  static final dio = Dio();
  static Uri cookieUri;
  static PersistCookieJar cookieJar;

  static bool ready = false;

  static String status = "";

  _prepare() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    cookieJar = PersistCookieJar(dir: join(appDocPath, cookiePath));
    dio.interceptors.add(CookieManager(cookieJar));
    ready = true;
  }

  Future<Response> login(String username, String password) async {
    if (!ready) await _prepare();

    var url = Constants.baseURL + loginPath;
    var body = {
      'username': username,
      'password': password,
    };

    var response = await dio.post(
      url,
      data: body,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    var cookie = Cookie.fromSetCookieValue(response.headers['set-cookie'][0]);
    cookieUri = Uri.parse(url);
    cookieJar.saveFromResponse(cookieUri, [cookie]);
    var redirect = response.headers['location'][0];
    var finalResponse = await dio.get(
      Constants.baseURL + redirect,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    return finalResponse;
  }

  Future<Response> logout() async {
    var url = Constants.baseURL + logoutPath;
    var cookie = cookieJar.loadForRequest(cookieUri);
    var response = await dio.get(
      url,
      options: Options(
        followRedirects: false,
        headers: {
          'cookie': cookie,
          'referer': Constants.baseURL,
        },
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    return response;
  }

  Stream<Response> checkUpdateBackgroundStream() async* {
    await _checkUpdateBackground();
    while (status != "Sync Complete!" && status != "Sync Failed.") {
      print(status);

      await Future.delayed(Duration(seconds: 1));
      yield await _checkUpdateBackground();
    }
  }

  Future<Response> _checkUpdateBackground() async {
    var url = Constants.baseURL + checkUpdateBackgroundPath;
    var cookie = cookieJar.loadForRequest(cookieUri);

    var response = await dio.get(url,
        options: Options(
            followRedirects: false,
            headers: {
              'cookie': cookie,
              'referer': Constants.baseURL,
            },
            validateStatus: (status) {
              return status < 500;
            }));

    print(response.data['message']);
    status = response.data['message'];

    return response;
  }
}
