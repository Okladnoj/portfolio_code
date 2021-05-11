import 'dart:async';

import 'package:cattle_scan/app/app_navigator.dart';
import 'package:cattle_scan/settings/constants.dart';

import 'domain/app_settings_repository.dart';
import 'models/app_settings_model.dart';
import 'models/app_settings_model_ui.dart';

class AppSettingInteractor {
  AppSettingInteractor() {
    _init();
  }

  final StreamController<AppSettingModelUI> _controller = StreamController.broadcast();
  StreamSink<AppSettingModelUI> get sink => _controller.sink;
  Stream<AppSettingModelUI> get observer => _controller.stream;

  AppSettingModel _appSettingModel;
  AppSettingRepository _appSettingRepository;

  void dispose() {
    _controller.close();
  }

  Future<void> saveNotification(String parameters, [bool isUpdateUI = true, bool isShowAlert = true]) async {
    final isSave = await _appSettingRepository.updateSettings(parameters);
    if (isUpdateUI) {
      await _loadSettings();
    }
    if (isShowAlert) {
      if (isSave) {
        AppNavigator.showSnackBar('Setting Saved', colorText: DesignStile.green);
      } else {
        AppNavigator.showSnackBar('FAILED TO SAVE');
      }
    }
  }

  Future<bool> saveEmail(String newEmail, String oldEmail, String currentPassword) async {
    final isCorrect = await _appSettingRepository.saveEmail(newEmail, oldEmail, currentPassword);
    return isCorrect;
  }

  Future<bool> savePassword(String currentEmail, String newPassword, String oldPassword) async {
    final isCorrect = await _appSettingRepository.savePassword(currentEmail, newPassword, oldPassword);
    return isCorrect;
  }

  void _init() {
    _appSettingRepository = AppSettingRepository();
    _loadSettings();
  }

  Future _loadSettings() async {
    _appSettingModel = await _appSettingRepository?.loadSettings();
    _updateUI();
  }

  void _updateUI() {
    sink.add(_mapToUI());
  }

  AppSettingModelUI _mapToUI() {
    return AppSettingModelUI(
      _appSettingModel?.email,
      _appSettingModel?.password,
      _mapToListNotificationPreferencesModelUI(_appSettingModel?.notificationPreferences),
      _mapToNotificationPeriodModelUI(_appSettingModel?.notificationPeriod),
    );
  }

  List<NotificationPreferencesModelUI> _mapToListNotificationPreferencesModelUI(
      List<NotificationPreferencesModel> notificationPreferences) {
    return notificationPreferences
            ?.map((e) => NotificationPreferencesModelUI(
                  e?.id,
                  e?.nameEvent,
                  e?.setKeyEvent,
                  e?.isActiveEmail,
                  e?.isActiveSMS,
                  e?.isActivePush,
                ))
            ?.toList() ??
        [];
  }

  NotificationPeriodModelUI _mapToNotificationPeriodModelUI(NotificationPeriodModel n) {
    return NotificationPeriodModelUI(
      n?.from,
      n?.to,
    );
  }
}
