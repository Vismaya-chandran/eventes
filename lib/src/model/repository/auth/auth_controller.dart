import 'dart:developer';

import 'package:evantez/app/app.dart';
import 'package:evantez/app/router/router_constant.dart';
import 'package:evantez/src/model/components/snackbar_widget.dart';
import 'package:evantez/src/model/repository/events/events_controller.dart';
import 'package:evantez/src/providers/auth/login/login_providers.dart';
import 'package:evantez/src/view/view/auth/models/authresponse.dart';
import 'package:evantez/src/view/view/auth/models/error_response.dart';
import 'package:evantez/src/view/view/auth/sign_up/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  bool showPassword = false;

  bool isRememberMe = true;

  void changeRememberMe() {
    isRememberMe = !isRememberMe;
    notifyListeners();
  }

  void showOrHidePassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  AuthResponse? authResponse;
  String? _accesToken;

  String? get accesToken => _accesToken;

  set accesToken(String? accesToken) {
    _accesToken = accesToken;
    notifyListeners();
  }

  String? _countryCode;

  String? get countryCode => _countryCode;

  set countryCode(String? countryCode) {
    _countryCode = countryCode;
    notifyListeners();
  }

  int? _userId;

  int? get userId => _userId;

  set userId(int? userId) {
    _userId = userId;
    notifyListeners();
  }

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  Future<String?> loadCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('accessToken')) {
      accesToken = sharedPreferences.getString('accessToken')!;
      countryCode = sharedPreferences.getString('countryCode');
      userId = int.parse(sharedPreferences.getString('userId')!);
      bool hasExpired = JwtDecoder.isExpired(accesToken!);
      if (hasExpired) {
        // logout();
        return null;
      } else {
        return accesToken;
      }
    } else {
      return null;
    }
  }

  Future<dynamic> login(BuildContext context) async {
    EventController eventController =
        Provider.of<EventController>(context, listen: false);
    try {
      authResponse = null;
      final response = await EventsAuth().login(
          email: signInEmailController.text.trim(),
          password: signInPasswordController.text.trim());
      if ((response as AuthResponse).access != null) {
        log('message');
        authResponse = response;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('accessToken', response.access!);
        accesToken = sharedPreferences.getString('accessToken')!;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response.access!);
        userId = decodedToken['user_id'];
        sharedPreferences.setString('userId', userId.toString());
        signInEmailController.clear();
        signInPasswordController.clear();
        navigate(context, RouterConstants.dashboardRoute);
        eventController.events(accesToken ?? '');
      }
    } catch (e) {
      log('fghgh');
      return rootScaffoldMessengerKey.currentState
          ?.showSnackBar(snackBarWidget(e.toString()));
    }
  }
}
