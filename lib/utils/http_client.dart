import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static final _storage = const FlutterSecureStorage();
  static bool _isRefreshing = false;
  static List<Function(String)> _subscribers = [];

  static Dio get instance => _dio;

  static void init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final status = error.response?.statusCode ?? 0;
          final requestOptions = error.requestOptions;

          if (status == 401 && !_isRefreshing) {
            _isRefreshing = true;

            final refreshToken = await _storage.read(key: 'refreshToken');
            if (refreshToken == null) {
              _forceLogout();
              return handler.reject(error);
            }

            try {
              final newAccessToken = await _refreshToken(refreshToken);
              _subscribers.forEach((cb) => cb(newAccessToken));
              _subscribers.clear();

              final cloneReq = await _retry(requestOptions, newAccessToken);
              return handler.resolve(cloneReq);
            } catch (e) {
              _forceLogout();
              return handler.reject(error);
            } finally {
              _isRefreshing = false;
            }
          } else if (status == 401 && _isRefreshing) {
            final completer = Completer<Response>();

            _subscribers.add((newToken) async {
              final cloneReq = await _retry(requestOptions, newToken);
              completer.complete(cloneReq);
            });

            completer.future.then((response) {
              handler.resolve(response); // ✅ trả về đúng cách
            }).catchError((e) {
              handler.reject(e);
            });

            return; // ✅ không return Future<Response>
          }

          return handler.next(error);
        },
      ),
    );
  }

  static Future<String> _refreshToken(String refreshToken) async {
    final oldAccess = await _storage.read(key: 'accessToken');

    final res = await Dio().post(
      "${dotenv.env['BASE_URL']}/Auth/refresh-token",
      data: {
        "refreshToken": refreshToken,
        "accessToken": oldAccess,
      },
      options: Options(
        headers: oldAccess != null ? {"Authorization": oldAccess} : {},
      ),
    );

    final data = res.data;
    final newAccess = data['accessToken'] as String;
    final newRefresh = data['refreshToken'] ?? refreshToken;

    await _storage.write(key: 'accessToken', value: newAccess);
    await _storage.write(key: 'refreshToken', value: newRefresh);

    return newAccess;
  }

  static Future<Response> _retry(RequestOptions req, String token) {
    final opts = Options(
      method: req.method,
      headers: {...req.headers, 'Authorization': token},
    );
    return _dio.request(
      req.path,
      options: opts,
      data: req.data,
      queryParameters: req.queryParameters,
    );
  }

  static void _forceLogout() async {
    await _storage.deleteAll();
    // TODO: điều hướng về màn login
    print("⚠️ Token hết hạn → logout");
  }
}
