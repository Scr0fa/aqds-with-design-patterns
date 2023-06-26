import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'dio.dart';

class Auth with ChangeNotifier {
  static Auth? _instance;
  static Dio _dio = Dio();

  bool _isLoggedIn = false;
  late User _user = User(name: '', email: '', avatar: '');
  late String _token = '';

  bool get authenticated => _isLoggedIn;
  User get user => _user;

  final storage = FlutterSecureStorage();

  Auth._();

  static Auth getInstance() {
    if (_instance == null) {
      _instance = Auth._();
    }
    return _instance!;
  }

  Dio createDioInstance() {
    // Create and configure Dio instance
    Dio dio = Dio();
    // Add any necessary configurations to the Dio instance
    return dio;
  }

  Future<void> login({required Map<dynamic, dynamic> creds}) async {
    print(creds);

    try {
      final response = await dio().post('/sanctum/login', data: creds);
      print(response.data.toString());

      final token = response.data.toString();
      await tryToken(token: token);
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 422) {
        throw 'Invalid credentials';
      } else if (e.response?.statusCode == 403) {
        throw 'Please verify your email first.';
      } else {
        throw 'Failed to authenticate. Please try again later.';
      }
    }
  }

  Future<String> register({Map? creds}) async {
    print(creds);

    try {
      final response = await dio().post('/auth/register', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      this.tryToken(token: token);
      return token;
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        print(e.response?.data);
      } else {
        print(e);
      }
      throw e;
    }
  }

  Future<List<dynamic>> fetchPM() async {
    try {
      final response = await dio().get('/pm'); // Update the URL with the correct base address

      if (response.statusCode == 200) {
        final responseData = response.data;
        return List<dynamic>.from(responseData);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Dio Error: $error');
    }

    return []; // Return an empty list if there was an error
  }

  Future<void> tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        final response = await dio().get(
          '/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        if (response.data is Map<String, dynamic>) {
          _isLoggedIn = true;
          _user = User.fromJson(response.data);
          _token = token;
          storeToken(token: token);
          notifyListeners();
          print(_user);
        } else {
          throw 'Failed to authenticate. Please try again later.';
        }
      } catch (e) {
        throw 'Failed to authenticate. Please try again later.';
      }
    }
  }

  Future<void> storeToken({String? token}) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    try {
      final response = await dio().get(
        '/user/revoke',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() {
    _user = User(name: '', email: '', avatar: '');
    _isLoggedIn = false;
    _token = '';
    storage.delete(key: 'token');
  }
}
