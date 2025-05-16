import 'dart:convert';
import 'package:flutter_oauth2_login/helpers/constant.dart';
import 'package:http/http.dart';

class AuthService {
  // Add these URI declarations at class level
  final loginUri = Uri.parse('${Constants.baseUrl}/oauth/token');
  final registerUri = Uri.parse('${Constants.baseUrl}/oauth/signup');

  Future<Response?> login(String username, String password) async {
    const client = 'express-client';
    const secret = 'express-secret';
    final basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    final res = await post(
      loginUri,
      headers: {'authorization': basicAuth},
      body: {
        "username": username,
        "grant_type": "password",
        "password": password
      },
    );
    return res;
  }

  Future<Response?> refreshToken(String token) async {
    const client = 'express-client';
    const secret = 'express-secret';
    final basicAuth = 'Basic ${base64.encode(utf8.encode('$client:$secret'))}';

    final res = await post(
      loginUri,
      headers: {'authorization': basicAuth},
      body: {
        "refresh_token": token,
        "grant_type": "refresh_token"
      },
    );
    return res;
  }

  Future<Response?> register(String username, String password, String name) async {
    final res = await post(
      registerUri,
      body: {
        "username": username,
        "password": password,
        "name": name
      },
    );
    return res;
  }
}
