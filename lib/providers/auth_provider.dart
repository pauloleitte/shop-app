import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/data/store.dart';
import 'package:shop_app/exceptions/auth_exception.dart';
import 'package:shop_app/utils/constants.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final response = await http.post(
        '${Constants.BASE_API_AUTH_URL}:$urlSegment?key=AIzaSyA5_WRJwgJ0oUsHhz4Ff13T3e3ddjGGoc4',
        body: json.encode(
            {"email": email, "password": password, "returnSecureToken": true}));
    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody["expiresIn"]),
        ),
      );

      Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> sign(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');
    if (userData == null) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _userId = userData["userId"];
    _token = userData["token"];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }
}
