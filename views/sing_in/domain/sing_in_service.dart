import 'package:cattle_scan/app/app_navigator.dart';

import '../models/user_model.dart';

import 'sing_in_functions.dart';

class SingInService {
  Future<void> init() async {
    final isLogin = await redirectIfUserLogged();
    if (isLogin) {
      AppNavigator.navigateToHomeScreen();
    } else {
      //  AppNavigator.navigateToSignInPage();
    }
  }

  Future<void> singIn(UserModel userModel) async {
    final isLogin = await gSingIn(userModel);
    if (isLogin) {
      AppNavigator.navigateToHomeScreen();
    } else {
      AppNavigator.navigateToSignInPage();
    }
  }

  Future<void> singOut() async {
    await gSingOut();
  }
}
