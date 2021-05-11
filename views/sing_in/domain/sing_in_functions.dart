import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:cattle_scan/pre_start_app/setting_cloud_message.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/views/sing_in/models/user_model.dart';

Future<bool> redirectIfUserLogged() async {
  final SharedPreferences localStorage = await SharedPreferences.getInstance();
  final bool userLogged = localStorage.getBool('userLogged') ?? false;
  await checkFirebaseToken(localStorage);
  return userLogged;
}

Future<void> gSingOut() async {
  await CallApi.userLogout();
}

Random r = Random();
int get ir => r.nextInt(10000);

Future<void> checkFirebaseToken(SharedPreferences localStorage) async {
  final firebaseToken = await _getFirebaseToken();
  final user = jsonDecode(localStorage?.getString('user') ?? '{}');
  final userToken = user['token'];
  if (userToken == firebaseToken) {
    print('============> Token is correct');
  } else if (userToken != null) {
    print('============> Token mast update');

    final Map<String, dynamic> body = {"token": firebaseToken};
    try {
      final response = await CallApi.parsData('updateToken', body);
      _storeUserData(response, CallApi.sessionCookie);

      if (response == null) {
        print('============> Token ERROR update');
      }
    } catch (e) {
      print(e);
    }
  } else {
    print('============> Token is absent');
  }
}

Future<bool> gSingIn(UserModel userModel) async {
  bool _submitting = false;

  String firebaseToken = 'FakeToken_$ir-sg534$ir-uhiou$ir-kmlhv$ir-275';
  firebaseToken = await _getFirebaseToken();

  final Map<String, dynamic> loginData = {
    'email': userModel.email,
    'password': userModel.password,
    "token": firebaseToken,
  };

  try {
    final response = await CallApi().postData(loginData, 'login');
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseData['status'] == 'ok') {
        _submitting = true;
        final cookie = response.headers['set-cookie'];
        _storeUserData(responseData, cookie);
      } else {
        // Error

        final String errorMessage = responseData['data'] as String;
        AppNavigator.showSnackBar(errorMessage);
      }
    } else {}
  } catch (e) {
    print(e);
  }

  return _submitting;
}

Future<String> _getFirebaseToken() async {
  String firebaseToken;
  try {
    if (Platform.isAndroid) {
      firebaseToken = await gFirebaseMessaging.getToken();
    } else if (Platform.isIOS) {
      firebaseToken = await gFirebaseMessaging.getToken();
    }
  } catch (e) {
    firebaseToken = 'ErrorFirBaseToken';
  }
  return firebaseToken;
}

Future<void> _storeUserData(responseData, String cookie) async {
  final localStorage = await SharedPreferences.getInstance();
  final Map<String, dynamic> user = {};
  bool isDemo = false;
  try {
    user['token'] = responseData['data'];
    user['is_demo'] = responseData['is_demo'];
    isDemo = user['is_demo'] as bool;
  } catch (e) {
    developer.log(e.toString());
  }

  if (isDemo) {
    DesignStile.maskCode = 3;
  } else {
    DesignStile.maskCode = 1;
  }
  CallApi.sessionCookie = cookie;
  localStorage.setString('user', json.encode(user));
  localStorage.setBool('userLogged', true);
  localStorage.setInt(CallApi.keyMaskCode, DesignStile.maskCode);
  localStorage.setString(CallApi.keyCookie, cookie);
}
