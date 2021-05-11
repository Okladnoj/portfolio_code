// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingResponseModelNetwork _$AppSettingResponseModelNetworkFromJson(
    Map<String, dynamic> json) {
  return AppSettingResponseModelNetwork(
    json['data'] == null
        ? null
        : AppSettingModelNetwork.fromJson(json['data'] as Map<String, dynamic>),
    json['status'] as String,
  );
}

Map<String, dynamic> _$AppSettingResponseModelNetworkToJson(
        AppSettingResponseModelNetwork instance) =>
    <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
    };

AppSettingModelNetwork _$AppSettingModelNetworkFromJson(
    Map<String, dynamic> json) {
  return AppSettingModelNetwork(
    json['email'] as String,
    json['password'] as String,
    (json['preferences'] as List)
        ?.map((e) => e == null
            ? null
            : PreferencesModelNetwork.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AppSettingModelNetworkToJson(
        AppSettingModelNetwork instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'preferences': instance.preferences,
    };

PreferencesModelNetwork _$PreferencesModelNetworkFromJson(
    Map<String, dynamic> json) {
  return PreferencesModelNetwork(
    json['Q41_RULES'] == null
        ? null
        : RulesModelNetwork.fromJson(json['Q41_RULES'] as Map<String, dynamic>),
    json['Q405_RULES'] == null
        ? null
        : RulesModelNetwork.fromJson(
            json['Q405_RULES'] as Map<String, dynamic>),
    json['CIH_RULES'] == null
        ? null
        : RulesModelNetwork.fromJson(json['CIH_RULES'] as Map<String, dynamic>),
    json['WI20_RULES'] == null
        ? null
        : RulesModelNetwork.fromJson(
            json['WI20_RULES'] as Map<String, dynamic>),
    json['NOTIFICATION_PERIOD'] == null
        ? null
        : NotificationPeriodModelNetwork.fromJson(
            json['NOTIFICATION_PERIOD'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PreferencesModelNetworkToJson(
        PreferencesModelNetwork instance) =>
    <String, dynamic>{
      'Q41_RULES': instance.q41Rules,
      'Q405_RULES': instance.q405Rules,
      'WI20_RULES': instance.wI20Rules,
      'CIH_RULES': instance.cihRules,
      'NOTIFICATION_PERIOD': instance.notificationPeriod,
    };

RulesModelNetwork _$RulesModelNetworkFromJson(Map<String, dynamic> json) {
  return RulesModelNetwork(
    json['EMAIL_ON'] as String,
    json['PUSH_ON'] as String,
    json['SMS_ON'] as String,
  );
}

Map<String, dynamic> _$RulesModelNetworkToJson(RulesModelNetwork instance) =>
    <String, dynamic>{
      'EMAIL_ON': instance.emailOn,
      'PUSH_ON': instance.pushOn,
      'SMS_ON': instance.smsOn,
    };

NotificationPeriodModelNetwork _$NotificationPeriodModelNetworkFromJson(
    Map<String, dynamic> json) {
  return NotificationPeriodModelNetwork(
    json['FROM'] as String,
    json['TO'] as String,
  );
}

Map<String, dynamic> _$NotificationPeriodModelNetworkToJson(
        NotificationPeriodModelNetwork instance) =>
    <String, dynamic>{
      'FROM': instance.from,
      'TO': instance.to,
    };
