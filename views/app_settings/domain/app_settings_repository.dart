import 'dart:convert';

import 'package:cattle_scan/api/api.dart';

import '../models/app_settings_model.dart';
import '../models/app_settings_model_network.dart';

class AppSettingRepository {
  Future<bool> updateSettings(String parameters) async {
    bool isUpdate = false;

    final responseData = await CallApi.parsData(parameters, [], HttpMethod.put);
    if (responseData != null) {
      isUpdate = true;
    }
    return isUpdate;
  }

  Future<AppSettingModel> loadSettings() async {
    AppSettingModel appSettingModel;
    final responseData = await CallApi.parsData('getSettings');
    final p = jsonEncode(responseData);
    if (responseData != null) {
      final r = AppSettingResponseModelNetwork.fromJson(responseData as Map<String, dynamic>);
      appSettingModel = _mapToAppSettingModel(r.data);
    }
    return appSettingModel;
  }

  Future<bool> saveEmail(String newEmail, String oldEmail, String currentPassword) async {
    bool isCorrect = false;
    final dynamic postData = [
      newEmail,
      oldEmail,
      currentPassword,
    ];
    final responseData = await CallApi.parsData('changeEmail', postData);
    final p = jsonEncode(responseData);
    if (responseData != null) {
      isCorrect = true;
    }
    return isCorrect;
  }

  Future<bool> savePassword(String currentEmail, String newPassword, String oldPassword) async {
    bool isCorrect = false;
    final dynamic postData = [
      currentEmail,
      newPassword,
      oldPassword,
    ];
    final responseData = await CallApi.parsData('changePassword', postData);
    final p = jsonEncode(responseData);
    if (responseData != null) {
      isCorrect = true;
    }
    return isCorrect;
  }

  AppSettingModel _mapToAppSettingModel(AppSettingModelNetwork r) {
    return AppSettingModel(
      r?.email,
      r?.password ?? '',
      _mapToNotificationPreferences(r?.preferences),
      _mapToNotificationPeriodModel(r?.preferences),
    );
  }

  NotificationPeriodModel _mapToNotificationPeriodModel(List<PreferencesModelNetwork> preferences) {
    final p = preferences?.first?.notificationPeriod;
    return NotificationPeriodModel(
      p?.from ?? '0',
      p?.to ?? '24',
    );
  }

  List<NotificationPreferencesModel> _mapToNotificationPreferences(List<PreferencesModelNetwork> preferences) {
    final p = preferences?.first;
    int id = 1;
    return [
          p.q405Rules,
          p.q41Rules,
          p.wI20Rules,
          p.cihRules,
        ]
            ?.map(
              (e) => NotificationPreferencesModel(
                id,
                _mapNames[id],
                _mapKeys[id++],
                e.emailOn == 'true',
                e.smsOn == 'true',
                e.pushOn == 'true',
              ),
            )
            ?.toList() ??
        [];
  }

  final _mapNames = {
    1: 'Sustain Temperature',
    2: 'Critical Temperature',
    3: 'Water Intake',
    4: 'Calving Prediction',
  };

  final _mapKeys = {
    1: 'setQ405Rule',
    2: 'setQ41Rule',
    3: 'setWI20Rule',
    4: 'setCIHRule',
  };
}
