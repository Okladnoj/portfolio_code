import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_model_network.g.dart';

@JsonSerializable()
class AppSettingResponseModelNetwork {
  @JsonKey(name: "data")
  final AppSettingModelNetwork data;
  @JsonKey(name: "status")
  final String status;

  AppSettingResponseModelNetwork(
    this.data,
    this.status,
  );

  factory AppSettingResponseModelNetwork.fromJson(Map<String, dynamic> json) {
    return _$AppSettingResponseModelNetworkFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AppSettingResponseModelNetworkToJson(this);
}

@JsonSerializable()
class AppSettingModelNetwork {
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "preferences")
  final List<PreferencesModelNetwork> preferences;

  AppSettingModelNetwork(
    this.email,
    this.password,
    this.preferences,
  );

  factory AppSettingModelNetwork.fromJson(Map<String, dynamic> json) {
    return _$AppSettingModelNetworkFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AppSettingModelNetworkToJson(this);
}

@JsonSerializable()
class PreferencesModelNetwork {
  @JsonKey(name: "Q41_RULES")
  final RulesModelNetwork q41Rules;
  @JsonKey(name: "Q405_RULES")
  final RulesModelNetwork q405Rules;
  @JsonKey(name: "WI20_RULES")
  final RulesModelNetwork wI20Rules;
  @JsonKey(name: "CIH_RULES")
  final RulesModelNetwork cihRules;
  @JsonKey(name: "NOTIFICATION_PERIOD")
  final NotificationPeriodModelNetwork notificationPeriod;

  PreferencesModelNetwork(
    this.q41Rules,
    this.q405Rules,
    this.cihRules,
    this.wI20Rules,
    this.notificationPeriod,
  );

  factory PreferencesModelNetwork.fromJson(Map<String, dynamic> json) {
    return _$PreferencesModelNetworkFromJson(json);
  }
  Map<String, dynamic> toJson() => _$PreferencesModelNetworkToJson(this);
}

@JsonSerializable()
class RulesModelNetwork {
  @JsonKey(name: "EMAIL_ON")
  final String emailOn;
  @JsonKey(name: "PUSH_ON")
  final String pushOn;
  @JsonKey(name: "SMS_ON")
  final String smsOn;

  RulesModelNetwork(
    this.emailOn,
    this.pushOn,
    this.smsOn,
  );

  factory RulesModelNetwork.fromJson(Map<String, dynamic> json) {
    return _$RulesModelNetworkFromJson(json);
  }
  Map<String, dynamic> toJson() => _$RulesModelNetworkToJson(this);
}

@JsonSerializable()
class NotificationPeriodModelNetwork {
  @JsonKey(name: "FROM")
  final String from;
  @JsonKey(name: "TO")
  final String to;

  NotificationPeriodModelNetwork(
    this.from,
    this.to,
  );

  factory NotificationPeriodModelNetwork.fromJson(Map<String, dynamic> json) {
    return _$NotificationPeriodModelNetworkFromJson(json);
  }
  Map<String, dynamic> toJson() => _$NotificationPeriodModelNetworkToJson(this);
}
