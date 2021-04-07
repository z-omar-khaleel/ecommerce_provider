import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _authTimer;
  String? get getToken {
    if (_token != null &&
        _expireDate != null &&
        DateTime.now().isBefore(_expireDate!)) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    print('getToken $getToken');
    return getToken != null;
  }

  String? get getUserId {
    return _userId;
  }

  addToSharedPref(String? token, String? userId, DateTime? expire) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
        'authData',
        jsonEncode({
          'token': token,
          'userId': userId,
          'expireDate': expire!.toIso8601String()
        }));
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDvBJMG1SCMKVwbaVnxz2hhU8rhPeYvvOo');
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw ExceptionHandle(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      autoLogOut();
      notifyListeners();
      addToSharedPref(_token, _userId, _expireDate);
    } on Exception catch (e) {
      throw (e);
    }
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDvBJMG1SCMKVwbaVnxz2hhU8rhPeYvvOo');
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw ExceptionHandle(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userId = responseData['localId'];
      autoLogOut();
      notifyListeners();
      addToSharedPref(_token, _userId, _expireDate);
    } on Exception catch (e) {
      throw (e);
    }
  }

  void logOut() async {
    _userId = null;
    _token = null;
    _expireDate = null;

    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    print('log out');
  }

  autoLogOut() {
    if (_authTimer != null) _authTimer!.cancel();
    final timeToEnd = _expireDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToEnd!), logOut);
  }

  Future<bool> autoLoginIn() async {
    print('auto');

    final pref = await SharedPreferences.getInstance();
    print('auto1');

    if (!pref.containsKey('authData')) {
      print(pref.containsKey('authData'));
      return false;
    }

    final extractData =
        jsonDecode(pref.getString('authData')!) as Map<String, dynamic>;
    print(extractData);
    print('extractData');
    if (DateTime.parse(extractData['expireDate']).isBefore(DateTime.now()))
      return false;
    _token = extractData['token'];
    _expireDate = DateTime.parse(extractData['expireDate']);
    _userId = extractData['userId'];
    print(_userId);
    print('_userId');
    notifyListeners();
    autoLogOut();
    return true;
  }
}
